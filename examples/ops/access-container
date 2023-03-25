#!/bin/bash

CLUSTER=$1
SERVICE=$2
CONTAINER=$3
PROFILE=${4-default}

aws ecs execute-command \
  --cluster $CLUSTER \
  --task $( \
      aws ecs list-tasks \
      --cluster $CLUSTER \
      --service-name $SERVICE \
      --profile $PROFILE \
      | jq -r '.["taskArns"][0] | split("/")[-1]' \
  ) \
  --container $CONTAINER \
  --profile $PROFILE \
  --command "/bin/bash" \
  --interactive
