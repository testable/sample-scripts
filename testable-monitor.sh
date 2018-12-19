#!/bin/bash

# Takes as input a test execution ID to monitor

execution_id=$1
echo "[$(date)] Waiting for execution to complete (view online at https://a.testable.io/results/$execution_id)"
while [ $(curl -H "X-Testable-Key:$TESTABLE_KEY" --silent https://api.testable.io/executions/$execution_id | jq -r ".completed") = "false" ]; do
  echo -n "."
  sleep 5
done

if [ $(curl -H "X-Testable-Key:$TESTABLE_KEY" --silent https://api.testable.io/executions/$execution_id | jq -r ".success") = "false" ]; then
  echo -e "\n[$(date)] Test FAILED"
else 
  echo -e "\n[$(date)] Test SUCCESS"
fi

epoch=$(date +"%s")
echo "[$(date)] Storing CSV results at results-$epoch.csv"
curl -H "X-Testable-Key:$TESTABLE_KEY" --silent https://api.testable.io/executions/$execution_id/results.csv > results-$epoch.csv
