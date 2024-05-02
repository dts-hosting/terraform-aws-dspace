[
  {
    "name"  : "createdb",
    "image" : "postgres:latest",
    "networkMode": "${network_mode}",
    "essential": false,
    "command" : [
      "/bin/sh",
      "-c",
      "createdb --encoding=UTF8 ${db_name} || true"
    ],
    "environment": [
      {
        "name" : "PGHOST",
        "value" : "${db_host}"
      }
    ],
    "secrets": [
      {
        "name" : "PGPASSWORD",
        "valueFrom" : "${db_password_arn}"
      },
      {
        "name" : "PGUSER",
        "valueFrom" : "${db_username_arn}"
      }
    ]
  },
  {
    "name"  : "pgcrypto",
    "image" : "postgres:latest",
    "networkMode": "${network_mode}",
    "essential": false,
    "command" : [
      "/bin/sh",
      "-c",
      "psql -c \"CREATE EXTENSION pgcrypto;\" || true"
    ],
    "environment": [
      {
        "name" : "PGDATABASE",
        "value" : "${db_name}"
      },
      {
        "name" : "PGHOST",
        "value" : "${db_host}"
      }
    ],
    "secrets": [
      {
        "name" : "PGPASSWORD",
        "valueFrom" : "${db_password_arn}"
      },
      {
        "name" : "PGUSER",
        "valueFrom" : "${db_username_arn}"
      }
    ],
    "dependsOn": [
      {
        "containerName": "createdb",
        "condition": "COMPLETE"
      }
    ]
  },
  {
    "name": "backend",
    "image": "${img}",
    %{ if capacity_provider == "EC2" }
    "memory": ${memory_limit},
    %{ endif ~}
    "networkMode": "${network_mode}",
    "essential": true,
    "entrypoint": [
      "/bin/bash",
      "-c",
      "${join(" ", [
        "${startup_script};",
        "${dspace_dir}/bin/dspace database ${startup_db_cmd};",
        "${startup_dspace_cmd}"
      ])}"
    ],
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
        "value": "-XX:+PerfDisableSharedMem -Xmx${memory}m -Xms${memory}m -Xss512k -Dfile.encoding=UTF-8 -Djava.awt.headless=true -server"
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
    "portMappings": [
      {
        "containerPort": ${port}
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
    %{ if capacity_provider == "EC2" }
    "linuxParameters": {
        "maxSwap": ${swap_size},
        "swappiness": 60
    },
    %{ endif ~}
    "dependsOn": [
      {
        "containerName": "pgcrypto",
        "condition": "COMPLETE"
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
