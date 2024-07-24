# Stale Storage Trends

We are assuming that diskover is installed with elasticseach in the system.

## Indexing 

In order to index the filesystem in elasticdearch using diskover follow the below commands.

```
# change directory to diskover
cd diskvoer/diskover

# this command will do indexing of folder in /var/www in the elasticsearch 
python3 diskover.py   /var/www/ -f

```


## Add ElasticSearch Datasource in Grafana (https://github.com/openflighthpc/monitoring-dashboard/blob/master/grafana/provisioning/datasources/metrics.yaml)

Here is the sample of updated datasource file used.

```
apiVersion: 1
datasources:
  - name: Short Term Metrics
    type: prometheus
    url: http://localhost:8428
    isDefault: true
    uid: P27AA5C6EF93B953C
  - name: Long Term Metrics
    type: prometheus
    url: http://localhost:8429
    uid: P3D096F30CDAF9ECC 


  - name: Elasticsearch Data Source
    type: elasticsearch
    access: proxy
    url: http://10.151.17.221:9200
    database: diskover-*
    jsonData:
      esVersion: 7
      timeField: 'atime'
      interval: Daily
    uid: P27AA5C6EF93B9RDC
    isDefault: false
```
