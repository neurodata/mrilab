#!/bin/bash -e
# A function to measure memory usage summary in the background while another script is
# running using the free -m command
#
# Usage ./memlog.sh /path/to/output tres

./memlog_worker.sh $2 > ${1} &
memkey=$!

echo "$memkey"

sleep 5