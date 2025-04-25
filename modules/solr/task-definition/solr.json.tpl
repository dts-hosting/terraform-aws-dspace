[
  {
    "name": "solr",
    "image": "${img}",
    "networkMode": "${network_mode}",
    "essential": true,
    "workingDirectory": "/var/solr",
    "${cmd_type}": [
      "/bin/bash",
      "-c",
      "${join(" ", cmd_args)}"
    ],
    "environment": [
      {
        "name": "SOLR_JAVA_MEM",
        "value": "-Xms${memory}m -Xmx${memory}m"
      },
      {
        "name": "SOLR_MODULES",
        "value": "${solr_modules}"
      },
      {
        "name": "SOLR_OPTS",
        "value": "${solr_opts}"
      }
    ],
    "portMappings": [
      {
        "containerPort": ${port}
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "${data}",
        "containerPath": "/var/solr"
      }
    ],
    %{ if capacity_provider == "EC2" }
    "linuxParameters": {
        "maxSwap": ${swap_size},
        "swappiness": 60
    },
    %{ endif ~}
    "ulimits": [
      {
        "name": "nofile",
        "softLimit": 65000,
        "hardLimit": 65000
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${log_prefix}"
      }
    }
  }
]
