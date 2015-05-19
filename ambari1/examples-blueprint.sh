# gets blueprint of an existing cluster
curl -H "X-Requested-By: ambari" -X GET -u admin:admin http://master.ambari.keedio.org:8080/api/v1/clusters/test?format=blueprint
# registers blueprint
# check /api/v1/blueprints
curl -H "X-Requested-By: ambari" -X POST -u admin:admin http://master.ambari.keedio.org:8080/api/v1/blueprints/test2-blueprint --data @test2-blueprint
# Start the cluster
curl -H "X-Requested-By: ambari" -X POST -u admin:admin http://master.ambari.keedio.org:8080/api/v1/clusters/test2-blueprint  -d @host-mapping.json
