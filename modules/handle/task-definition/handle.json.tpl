[
  {
    "name": "handle",
    "image": "${img}",
    "networkMode": "${network_mode}",
    "essential": true,
    "environment": [
      {
        "name": "CONTACT_EMAIL",
        "value": "${contact_email}"
      },
      {
        "name": "CONTACT_NAME",
        "value": "${contact_name}"
      },
      {
        "name": "HANDLE_HOST_IP",
        "value": "${host_ip}"
      },
      {
        "name": "HANDLE_SERVER_NAME",
        "value": "${server_name}"
      },
      {
        "name": "ORG_NAME",
        "value": "${org_name}"
      },
      {
        "name": "REPLICATION_ADMINS",
        "value": "${replication_admins}"
      },
      {
        "name": "S3_HANDLE_DSPACE_PLUGIN_CFG_URL",
        "value": "${s3_handle_dspace_plugin_cfg_url}"
      },
      {
        "name": "S3_SITEBNDL_UPLOAD_URL",
        "value": "${s3_sitebndl_upload_url}"
      },
      {
        "name": "SERVER_ADMINS",
        "value": "${server_admins}"
      },
      {
        "name": "STORAGE_TYPE",
        "value": "CUSTOM"
      }
    ],
    "secrets": [
      {
        "name": "SERVER_PRIVATE_KEY_PEM",
        "valueFrom": "${private_key_name}"
      },
      {
        "name": "SERVER_PUBLIC_KEY_PEM",
        "valueFrom": "${public_key_name}"
      }
    ],
    "portMappings": [
      {
        "containerPort": 2641
      },
      {
        "containerPort": 8000
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "handle"
      }
    }
  }
]