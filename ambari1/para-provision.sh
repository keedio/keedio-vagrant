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
# see NOTICE file

# any valid parallel argument will work here, such as -P x.
MAX_PROCS="-j 16"

# Read parameter from vagrantconfig.yaml file
NUM_INSTANCE=10
RUN_SMOKE_TESTS=false

parallel_provision() {
    while read box; do
        echo $box
     done | parallel $MAX_PROCS -I"NODE" -q \
        sh -c 'LOGFILE="logs/NODE.out.txt" ;                                 \
                printf  "[NODE] Provisioning. Log: $LOGFILE, Result: " ;     \
                vagrant provision NODE > $LOGFILE 2>&1 ;                      \
                echo "vagrant provision NODE > $LOGFILE 2>&1" ;               \
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


master_name=`grep -v "#" hiera/configuration.yaml|grep   'set_master' | awk '{ print $2}'`
if [ -z "$master_name" ]
then
master_name=`grep  'set_master' hiera/default.yaml| awk '{print $2}'`
fi

echo "Starting master:",$master_name

master_name="${master_name%\'}" 
master_name="${master_name#\'}" 


echo "$master_name" | parallel_provision


# but run provision tasks in parallel
echo " ==> Beginning parallel 'vagrant provision' processes ..."
grep "config.vm.define"  Vagrantfile | grep -v buildoop |awk '{print $2}'| cut -c2-  | parallel_provision


#run smoketest on the last node when all node finish provisioning

rm -f logs/*.tmp

#export $( grep resolution hiera/configuration.yaml |sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g')
