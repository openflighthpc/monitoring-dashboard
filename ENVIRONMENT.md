# Development Environment
The monitoring dashboard requires data from multiple exporters, which in turn require data from Slurm and hardware sensors. Setting up a suitable environment for testing and development can be difficult, and so instructions to build a development environment on top of a Flight Solo cluster are detailed here.

## Initial Environment Setup
This setup assumes you are running a Flight Solo cluster on Openstack. If you are running this elsewhere, you may have to adapt some of the setup.

[Launch](https://www.openflighthpc.org/latest/docs/flight-solo/cluster-build-methods/slurm-multinode-openstack/) a two node Flight Solo Cluster using the Flight Solo 2024.1 image and attach floating IPs to your instances. In this example, the head node will be called `dashboard01` and the example compute node `node01`.

Configure the two nodes as a `SLURM multinode cluster` with one login + one compute profile applied. (This installs Slurm `23.02.01`).

```
flight hunter parse
flight profile configure
flight profile apply scheduler login
flight profile apply compute compute
```

Install `slurmdbd`:
```
sudo su -
yum install https://repo.openflighthpc.org/openflight/centos/9/x86_64/openflighthpc-release-3-1.noarch.rpm
yum install flight-slurm-slurmdbd
cp /opt/flight/opt/slurm/etc/slurmdbd.conf.example /opt/flight/opt/slurm/etc/slurmdbd.conf
chown nobody /opt/flight/opt/slurm/etc/slurmdbd.conf
```

Install and configure `MySQL`:
```
sudo su -
yum install mysql-server
systemctl enable --now mysqld
/usr/bin/mysql_secure_installation
mysql -p #Create slurm default db as per: https://slurm.schedmd.com/accounting.html
mysql> create user 'slurm'@'localhost' identified by 'password'; 
mysql> grant all on slurm_acct_db.* TO 'slurm'@'localhost';
mysql> SHOW ENGINES; #Verify InnoDB is enabled
mysql> create database slurm_acct_db;
```

Update slurm + slurmdbd config (use User=daemon not `nobody`):
```
vim /opt/flight/opt/slurm/etc/slurmdbd.conf #update conf to have correct user + db pass etc
vim /opt/flight/opt/slurm/etc/slurm.conf #update conf to know accounting exists (add: AccountingStorageType=accounting_storage/slurmdbd)
chown daemon /opt/flight/opt/slurm/etc/slurmdbd.conf
chown daemon /opt/flight/opt/slurm/var/* -R
systemctl restart flight-slurmctld
systemctl enable --now flight-slurmdbd
systemctl restart flight-slurmdbd
#Copy conf to compute
scp /opt/flight/opt/slurm/etc/slurm.conf node01:/opt/flight/opt/slurm/etc/slurm.conf
pdsh -w node01 systemctl restart flight-slurmd
```
Add flight user to SLURM DB:
```
sacctmgr create cluster dashboard
sacctmgr create account flight-users
sacctmgr add user flight account=flight-users
```

## Exporter Installation

### Node Exporter
On each node in your Flight Solo cluster, you must install `node-exporter`. This is the only exporter that must be installed on all of your nodes.
```
mkdir -p /opt/node-exporter
mkdir -p /opt/node-exporter/textfile-collector

wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz
tar -xzvf node_exporter-1.8.1.linux-amd64.tar.gz
mv node_exporter-1.8.1.linux-amd64 /opt/node-exporter/bin

cat << EOF > /usr/lib/systemd/system/node-exporter.service
[Unit]
Description=Node Exporter service
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/node-exporter
ExecStart=/opt/node-exporter/bin/node_exporter --log.level=error --collector.textfile --collector.textfile.directory=/opt/node-exporter/textfile-collector/

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now node-exporter
```

On the scheduler node of your Flight Solo cluster, you must also install the other required exporters.

### Prometheus Slurm Exporter
```
yum install -y golang git
git clone https://github.com/vpenso/prometheus-slurm-exporter.git
cd prometheus-slurm-exporter
git checkout 0.20
go build
cp prometheus-slurm-exporter /usr/local/sbin/

cat << EOF > /usr/lib/systemd/system/prometheus-slurm-exporter.service
[Unit]
Description=Prometheus SLURM Exporter

[Service]
Environment=PATH="$PATH:/opt/flight/opt/slurm/bin"
ExecStart=/usr/local/sbin/prometheus-slurm-exporter --listen-address=:9103
Restart=always
RestartSec=15

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now prometheus-slurm-exporter
```

### Slurm Job Exporter
```
git clone https://github.com/openflighthpc/slurm-job-exporter.git
cd slurm-job-exporter
git checkout <release>
bash install.sh

cat << EOF > /usr/lib/systemd/system/slurm-job-exporter.service
[Unit]
Description=Slurm Job Exporter service
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/slurm-job-exporter
ExecStart=/opt/flight/bin/ruby /opt/slurm-job-exporter/bin/exporter.rb
Restart=always

[Install]
WantedBy=multi-user.target
EOF

cd /opt/slurm-job-exporter
/opt/flight/bin/bundle install

cat << EOF > /opt/slurm-job-exporter/etc/config.yaml
exporter:
  port: 9107
  log: log/slurm-job-exporter.log
slurm:
  sacct: /opt/flight/opt/slurm/bin/sacct
EOF

systemctl daemon-reload
systemctl enable --now slurm-job-exporter
```
