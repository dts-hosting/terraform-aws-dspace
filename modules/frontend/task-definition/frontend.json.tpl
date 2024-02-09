[
  {
    "name": "frontend",
    "image": "${img}",
    "networkMode": "${network_mode}",
    "essential": true,
    "environment": [
      %{ for name, value in custom_env_cfg }
      {
        "name": "${name}",
        "value": "${value}"
      },
      %{ endfor ~}
      {
        "name": "DSPACE_UI_SSL",
        "value": "${ssl}"
      },
      {
        "name": "DSPACE_UI_HOST",
        "value": "${bind}"
      },
      {
        "name": "DSPACE_UI_PORT",
        "value": "${port}"
      },
      {
        "name": "DSPACE_UI_NAMESPACE",
        "value": "/"
      },
      {
        "name": "DSPACE_REST_SSL",
        "value": "${rest_ssl}"
      },
      {
        "name": "DSPACE_REST_HOST",
        "value": "${rest_host}"
      },
      {
        "name": "DSPACE_REST_PORT",
        "value": "${rest_port}"
      },
      {
        "name": "DSPACE_REST_NAMESPACE",
        "value": "${rest_namespace}"
      },
      {
        "name": "NODE_ENV",
        "value": "${env}"
      },
      {
        "name": "NODE_OPTIONS",
        "value": "--max-old-space-size=${memory}"
      }
    ],
    "secrets": [
      %{ for name, value in custom_secrets_cfg }
      {
        "name": "${name}",
        "valueFrom": "${value}"
      },
      %{ endfor ~}
    ],
    "portMappings": [
      {
        "containerPort": ${port}
      }
    ],
    %{ if capacity_provider == "EC2" }
    "linuxParameters": {
        "maxSwap": ${swap_size},
        "swappiness": 60
    },
    %{ endif ~}
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
