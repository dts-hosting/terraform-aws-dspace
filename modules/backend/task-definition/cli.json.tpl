[
  {
    "name": "cli",
    "image": "${img}",
    "networkMode": "awsvpc",
    "essential": true,
    "entryPoint": ["/bin/bash", "-c"],
    "environment": [
      %{ for name, value in custom_env_cfg }
      {
        "name": "${name}",
        "value": "${value}"
      },
      %{ endfor ~}
      {
        "name": "db__P__url",
        "value": "${db_url}"
      },
      {
        "name": "dspace__P__dir",
        "value": "${dspace_dir}"
      },
      {
        "name": "dspace__P__hostname",
        "value": "${host}"
      },
      {
        "name": "dspace__P__name",
        "value": "${dspace_name}"
      },
      {
        "name": "dspace__P__server__P__url",
        "value": "${backend_url}"
      },
      {
        "name": "dspace__P__ui__P__url",
        "value": "${frontend_url}"
      },
      {
        "name": "jwt__P__login__P__token__P__secret",
        "value": "${jwt_token_secret}"
      },
      {
        "name": "jwt__P__shortLived__P__token__P__secret",
        "value": "${jwt_token_secret}"
      },
      {
        "name": "solr__P__server",
        "value": "${solr_url}"
      },
      {
        "name": "JAVA_OPTS",
        "value": "-XX:+PerfDisableSharedMem -Xmx${memory}m -Xms${memory}m"
      },
      {
        "name": "LOGGING_CONFIG",
        "value": "${log4j2_url}"
      },
      {
        "name": "TZ",
        "value": "${timezone}"
      }
    ],
    "secrets": [
      %{ for name, value in custom_secrets_cfg }
      {
        "name": "${name}",
        "valueFrom": "${value}"
      },
      %{ endfor ~}
      {
        "name": "db__P__password",
        "valueFrom": "${db_password_arn}"
      },
      {
        "name": "db__P__username",
        "valueFrom": "${db_username_arn}"
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "${assetstore}",
        "containerPath": "${dspace_dir}/assetstore"
      },
      {
        "sourceVolume": "${ctqueues}",
        "containerPath": "${dspace_dir}/ctqueues"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "dspace"
      }
    }
  }
]
