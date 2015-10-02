#censed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# concurrency is hard, let's have a beer

# This script is based onthe `para-vagrant.sh` script by Joe Miller, available at https://github.com/joemiller/sensu-tests/blob/master/para-vagrant.sh.

MAX_PROCS="-j 8"

#A 5 seconds delay between tasks has been introduced to avoid race conditions in getting floating IPs.

parallel_up() {
    while read box; do
        echo $box
     done | parallel $MAX_PROCS --delay 8 -I"NODE" -q \
        sh -c 'LOGFILE="logs/NODE.start.out.txt" ;                                 \
                printf  "[NODE] Provisioning. Log: $LOGFILE, Result: " ;     \
                vagrant up --no-provision NODE > $LOGFILE 2>&1 ;                      \
                echo "vagrant up --no-provision NODE > $LOGFILE 2>&1" ;               \
                RETVAL=$? ;                                                 \
                if [ $RETVAL -gt 0 ]; then                                  \
                    echo " FAILURE";                                        \
                    tail -12 $LOGFILE | sed -e "s/^/[NODE]  /g";             \
                    echo "[NODE] ---------------------------------------------------------------------------";   \
                    echo "FAILURE ec=$RETVAL" >>$LOGFILE;                   \
                else                                                        \
                    echo " SUCCESS";                                        \
                    tail -5 $LOGFILE | sed -e "s/^/[NODE]  /g";              \
                    echo "[NODE] ---------------------------------------------------------------------------";   \
                    echo "SUCCESS" >>$LOGFILE;                              \
                fi;                                                         \
                exit $RETVAL'

    failures=$(egrep  '^FAILURE' logs/*.out.txt | sed -e 's/^logs\///' -e 's/\.out\.txt:.*//' -e 's/^/  /')
    successes=$(egrep '^SUCCESS' logs/*.out.txt | sed -e 's/^logs\///' -e 's/\.out\.txt:.*//' -e 's/^/  /')

    echo
    echo "Failures:"
    echo '------------------'
    echo "$failures"
    echo
    echo "Successes:"
    echo '------------------'
    echo "$successes"
}

## -- main -- ##

# cleanup old logs
mkdir logs >/dev/null 2>&1
rm -f logs/*

# but run startup tasks in parallel
echo " ==> Beginning parallel 'vagrant up --no-provision' processes ..."

    cat <<EOF | parallel_up
master
ambari1
ambari2
ambari3
ambari4
ambari5
ambari6
ambari7
ambari8
ambari9
EOF



rm -f logs/*.tmp



