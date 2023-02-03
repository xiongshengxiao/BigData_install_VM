#!/bin/bash
/export/server/hadoop-3.3.0/sbin/start-dfs.sh
/export/server/hadoop-3.3.0/sbin/start-yarn.sh
/export/server/hadoop-3.3.0/bin/mapred --daemon start historyserver
