#!/bin/bash

JQ1=batch-queue1-handson-topic8
JQ2=batch-queue2-handson-topic8
JD=batch-jd-handson-topic8
JOB1_NAME=sleep
JOB2_NAME=hello
JOB3_NAME=world
JOB4_NAME=p1
JOB5_NAME=p2
JOB6_NAME=p3

# start head job of queue2
jobhead2_id=`aws batch submit-job --job-name que2-$JOB1_NAME --job-queue $JQ2  --job-definition $JD --share-identifier test --scheduling-priority-override 4 --container-overrides command="sleep","10" | jq '.jobId' `
# start head job of queue1
jobhead1_id=`aws batch submit-job --job-name que1-$JOB1_NAME --job-queue $JQ1  --job-definition $JD --share-identifier test --scheduling-priority-override 4 --container-overrides command="sleep","10" | jq '.jobId' `
sleep 1
# start p1 job of queue1
aws batch submit-job --job-name que1-$JOB4_NAME --job-queue $JQ1  --job-definition $JD --share-identifier test --depends-on jobId=$jobhead1_id --scheduling-priority-override 1 --container-overrides command="echo","P1~~~lowqueue"
sleep 1
# start p2 job of queue1
aws batch submit-job --job-name que1-$JOB5_NAME --job-queue $JQ1  --job-definition $JD --share-identifier test --depends-on jobId=$jobhead1_id --scheduling-priority-override 2 --container-overrides command="echo","P2~~~lowqueue"
sleep 1
# start p3 job of queue1
aws batch submit-job --job-name que1-$JOB6_NAME --job-queue $JQ1  --job-definition $JD --share-identifier test --depends-on jobId=$jobhead1_id --scheduling-priority-override 3 --container-overrides command="echo","P3~~~lowqueue"
sleep 1
# start hello job of queue1
jobhello1_id=`aws batch submit-job --job-name que1-$JOB2_NAME --job-queue $JQ1  --job-definition $JD --share-identifier test --depends-on jobId=$jobhead1_id --scheduling-priority-override 4 --container-overrides command="echo","lowqueue~hello" | jq '.jobId' `
sleep 1
# start word job of queue1
aws batch submit-job --job-name que1-$JOB3_NAME --job-queue $JQ1  --job-definition $JD --share-identifier test --depends-on jobId=$jobhello1_id --scheduling-priority-override 4 --container-overrides command="echo","world~lowqueue"
sleep 1


# start p1 job of queue2
aws batch submit-job --job-name que2-$JOB4_NAME --job-queue $JQ2  --job-definition $JD --share-identifier test --depends-on jobId=$jobhead2_id --scheduling-priority-override 1 --container-overrides command="echo","P1~~~highqueue"
sleep 1
# start p2 job of queue2
aws batch submit-job --job-name que2-$JOB5_NAME --job-queue $JQ2  --job-definition $JD --share-identifier test --depends-on jobId=$jobhead2_id --scheduling-priority-override 2 --container-overrides command="echo","P2~~~highqueue"
sleep 1
# start p3 job of queue2
aws batch submit-job --job-name que2-$JOB6_NAME --job-queue $JQ2  --job-definition $JD --share-identifier test --depends-on jobId=$jobhead2_id --scheduling-priority-override 3 --container-overrides command="echo","P3~~~highqueue"
sleep 1
# start hello job of queue2
jobhello2_id=`aws batch submit-job --job-name que2-$JOB2_NAME --job-queue $JQ2  --job-definition $JD --share-identifier test --depends-on jobId=$jobhead2_id --scheduling-priority-override 4 --container-overrides command="echo","highqueue~hello" | jq '.jobId' `
sleep 1
# start word job of queue2
aws batch submit-job --job-name que2-$JOB3_NAME --job-queue $JQ2  --job-definition $JD --share-identifier test --depends-on jobId=$jobhello2_id --scheduling-priority-override 4 --container-overrides command="echo","world~highqueue"
sleep 1
















#job1_id=`aws batch submit-job --job-name sleep --job-queue batch-queue1-handson-topic8 --job-definition batch-jd-handson-topic8 --share-identifier test --scheduling-priority-override 1  --container-overrides command="sleep","10" | jq '.jobId' `