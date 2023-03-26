# DSpace Ops

Example scripts to interact with DSpace services.

## Usage

### Accessing containers

Requires the AWS CLI [Session Manager plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html).

```bash
./access-container $CLUSTER $SERVICE $CONTAINER [$PROFILE]
./access-container dspace-ex-complete dspace-ex-complete-solr solr
./access-container dspace-ex-complete dspace-ex-complete-backend backend
./access-container dspace-ex-complete dspace-ex-complete-frontend frontend
```

### Running CLI commands

Requires the AWS CLI and Fargate must be enabled on the cluster.

```bash
./cli $CLUSTER $SECURITY_GROUP_ID $SUBNET_ID $TASK_DEF_NAME $COMMAND [$PROFILE]

./cli dspace-ex-complete \
  sg-04cb149cb610941b4 \
  subnet-0cb48c2a16e02466a \
  dspace-ex-complete-backend-cli \
  '["version"]'
```

The security group and subnet selected must provide access to
the internal services used by DSpace (DB, Solr etc.).

The command must be a valid json array of strings. Examples:

```bash
./cli ... '["create-administrator","-e","admin@dspace.org","-f","DSpace","-l","Administrator","-p","dspace","-c","en"]'
./cli ... '["index-discovery","-b"]'
```

The script will return a task arn. Check the logs for the outcome.
