#!/bin/bash

hive_tmp1=`/export/server/jdk1.8.0_202/bin/jps | grep 'RunJar' | awk '{print $1}' | sed -n '1p'`
hive_tmp2=`/export/server/jdk1.8.0_202/bin/jps | grep 'RunJar' | awk '{print $1}' | sed -n '2p'`
kill -9 $hive_tmp1 $hive_tmp2
