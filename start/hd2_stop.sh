#!/bin/bash
/export/server/hadoop-3.3.0/sbin/stop-dfs.sh
/export/server/hadoop-3.3.0/sbin/stop-yarn.sh
/export/server/hadoop-3.3.0/bin/mapred --daemon stop historyserver
