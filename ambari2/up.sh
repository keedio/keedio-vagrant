#!/bin/bash

vagrant up master
for i in `seq  1 $1`;
do
  vagrant up ambari$i
done
