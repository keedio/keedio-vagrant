#!/bin/bash
service=""
while [ $# -gt 0 ]; do
  case $1 in
    "--service"|"-s")
      service=$2
      shift
      shift
      ;;
    "--full"|"-f")
      full=True
      shift
      ;;
    *)
      echo "Invalid argument $1"
      exit 1
      ;;
  esac
done

if [ "$service" = "flume" ]; then  
  echo "Stopping flume"
  for i in 1; do ssh ambari$i "service flume-agent stop &>/dev/null" & done
  echo "Removing flume agents conf"
  for i in 1; do ssh ambari$i "rm -f /etc/flume/conf.d/*" & done
fi

if [ "$service" = "kafka" ]; then
  for i in 1; do echo $i; ssh ambari$i service kafka stop; done
  for i in 1; do ssh ambari$i service zookeeper-server stop; done
  for i in 1; do ssh ambari$i service jmxtrans stop; done
  for i in 1; do ssh ambari$i rm -rf /hadoop/zookeeper/*; done

  for i in 1; do ssh ambari$i "yum remove -y kafka zookeeper-server zookeeper &>/dev/null" & done
  wait
  for i in 1; do ssh ambari$i "rm -rf /kafka-logs"; done
fi

if [ "$service" = "ganglia" ]; then
  echo "Stopping gmond"
  for i in 1; do ssh ambari$i "service gmond stop &>/dev/null" & done
  wait
  echo "Stopping gmond symbilic links"
  for i in 1; do ssh ambari$i "service gmond.Slaves stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service gmond.DataNode stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service gmond.FlumeServer stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service gmond.HistoryServer stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service gmond.NameNode stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service gmond.NodeManager stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service gmond.ResourceManager stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service gmetad stop &>/dev/null" & done
  wait
  echo "Removing ganglia configs"
  for i in 1; do ssh ambari$i "rm -rf /etc/init.d/gmond.* &>/dev/null" & done
  for i in 1; do ssh ambari$i "rm -rf /etc/init.d/gmond-* &>/dev/null" & done
  for i in 1; do ssh ambari$i "rm -rf /etc/ganglia &>/dev/null" & done
  wait
  echo "Uninstalling gmond and gmetad"
  for i in 1; do ssh ambari$i "yum remove -y ganglia-gmond ganglia-gmetad &>/dev/null" & done
  wait
  service="hdfs"
fi

if [ "$service" = "hdfs" ]; then
  echo "Stopping services"
  for i in 1; do ssh ambari$i "service hadoop-mapreduce-historyserver stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service hadoop-yarn-nodemanager stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service hadoop-yarn-resourcemanager stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service monit stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service hadoop-hdfs-secondarynamenode stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service hadoop-hdfs-zkfc stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service hadoop-hdfs-namenode stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service hadoop-hdfs-journalnode stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service hadoop-hdfs-datanode stop &>/dev/null" & done
  for i in 1; do ssh ambari$i "service zookeeper-server stop &>/dev/null" & done
  wait 
  for i in 1; do ssh ambari$i "rm -rf /var/lib/hadoop-hdfs/formatted" & done

  if [ -n "$full" ] ; then
    echo "Uninstalling rpms"
    for i in 1; do ssh ambari$i "yum remove -y hadoop zookeeper-server storm hadoop-libhdfs zookeeper hadoop-hdfs-zkfc storm-nimbus hadoop-hdfs zookeeper-rest hadoop-hdfs-datanode hadoop-hdfs-journalnode storm-drcp &>/dev/null" & done
    wait

    echo "Deleting directories under /etc"
    for i in 1; do ssh ambari$i "rm -rf /etc/hadoop" & done
    for i in 1; do ssh ambari$i "rm -rf /etc/zookeeper" & done
    for i in 1; do ssh ambari$i "rm -rf /etc/storm" & done
    wait

    echo "Deleting directories under /var/run"
    for i in 1; do ssh ambari$i "rm -rf /var/run/hadoop" & done
    for i in 1; do ssh ambari$i "rm -rf /var/run/zookeeper" & done
    for i in 1; do ssh ambari$i "rm -rf /var/run/hadoop-hdfs" & done
    wait

    echo "Deleting directories under /var/log"
    for i in 1; do ssh ambari$i "rm -rf /var/log/hadoop" & done
    for i in 1; do ssh ambari$i "rm -rf /var/log/zookeeper" & done
    for i in 1; do ssh ambari$i "rm -rf /var/log/storm" & done
    for i in 1; do ssh ambari$i "rm -rf /var/log/hadoop-hdfs" & done

    echo "Deleting directories under /usr/lib"
    for i in 1; do ssh ambari$i "rm -rf /usr/lib/hadoop" & done
    for i in 1; do ssh ambari$i "rm -rf /usr/lib/oozie" & done
    for i in 1; do ssh ambari$i "rm -rf /usr/lib/zookeeper" & done
    for i in 1; do ssh ambari$i "rm -rf /usr/lib/storm" & done
    for i in 1; do ssh ambari$i "rm -rf /usr/lib/hadoop-hdfs" & done
    wait

    echo "Deleting directories under /var"
    for i in 1; do ssh ambari$i "rm -rf /var/lib/zookeeper" & done
    for i in 1; do ssh ambari$i "rm -rf /var/lib/hadoop-hdfs" & done
    for i in 1; do ssh ambari$i "rm -rf /var/lib/hdfs" & done
    for i in 1; do ssh ambari$i "rm -rf /var/lib/oozie" & done
    wait
  fi

  echo "Deleting directories under /tmp"
  for i in 1; do ssh ambari$i "rm -rf /tmp/hadoop-hdfs" & done
  wait

  echo "Deleting directories under /hadoop"
  for i in 1; do ssh ambari$i "rm -rf /hadoop/zookeeper/*" & done
  for i in 1; do ssh ambari$i "rm -rf /hadoop/hdfs/*" & done
  wait

fi

echo "Cleaning mysql"
mysql -e "drop database ambari;create database ambari; use ambari; source /var/lib/ambari-server/resources/Ambari-DDL-MySQL-CREATE.sql;"
echo "Stopping ambari-server"
service ambari-server stop &>/dev/null
echo "Starting ambari-server"
service ambari-server start &>/dev/null
for i in 1; do ssh ambari$i service ambari-agent restart; done
