[
  {
    "name": "frontend",
    "image": "${img}",
    "networkMode": "${network_mode}",
    "essential": true,
    "environment": [
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
    "portMappings": [
      {
        "containerPort": ${port}
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "frontend"
      }
    }
  }
]
