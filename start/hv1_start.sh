#!/bin/bash

nohup /export/server/hive-3.1.2/bin/hive --service metastore &
nohup /export/server/hive-3.1.2/bin/hive --service hiveserver2 &
