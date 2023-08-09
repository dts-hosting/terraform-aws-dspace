[
  {
    "name": "certbot",
    "image": "${img}",
    "networkMode": "${network_mode}",
    "essential": true,
    "environment": [
      {
        "name": "CERTBOT_ALB_NAME",
        "value": "${lb_name}"
      },
      {
        "name": "CERTBOT_DOMAINS",
        "value": "${hostname}"
      },
      {
        "name": "CERTBOT_EMAIL",
        "value": "${email}"
      },
      {
        "name": "CERTBOT_ENABLED",
        "value": "${enabled}"
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
        "awslogs-stream-prefix": "dspace"
      }
    }
  }
]
