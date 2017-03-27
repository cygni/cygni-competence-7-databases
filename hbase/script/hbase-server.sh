#!/bin/bash

MASTER_PID=/var/run/hbase-master.pid
REGION_PID=/var/run/hbase-region.pid
THRIFT_PID=/var/run/hbase-thrift.pid
REST_PID=/var/run/hbase-rest.pid

cleanup() {
  if [ -f ${MASTER_PID} ]; then
    # If the process is still running time to tear it down.
    kill -9 `cat ${MASTER_PID}` > /dev/null 2>&1
    rm -f ${MASTER_PID} > /dev/null 2>&1
  fi

  if [ -f ${REGION_PID} ]; then
    # If the process is still running time to tear it down.
    kill -9 `cat ${REGION_PID}` > /dev/null 2>&1
    rm -f ${REGION_PID} > /dev/null 2>&1
  fi

  if [ -f ${THRIFT_PID} ]; then
    # If the process is still running time to tear it down.
    kill -9 `cat ${THRIFT_PID}` > /dev/null 2>&1
    rm -f ${THRIFT_PID} > /dev/null 2>&1
  fi

  if [ -f ${REST_PID} ]; then
    # If the process is still running time to tear it down.
    kill -9 `cat ${REST_PID}` > /dev/null 2>&1
    rm -f ${REST_PID} > /dev/null 2>&1
  fi
}

trap cleanup SIGHUP SIGINT SIGTERM EXIT

hbase master start 2>&1 &
master_pid=$!
echo $master_pid ${MASTER_PID}
sleep 1;

hbase regionserver start 2>&1 &
region_pid=$!
echo $region_pid > ${REGION_PID}

hbase thrift start 2>&1 &
thrift_pid=$!
echo $thrift_pid > ${THRIFT_PID}

hbase rest start 2>&1 &
rest_pid=$!
echo $rest_pid > ${REST_PID}

wait $master_pid $region_pid $thrift_pid $rest_pid