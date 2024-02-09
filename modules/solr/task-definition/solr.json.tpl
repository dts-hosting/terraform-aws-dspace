[
  {
    "name": "solr",
    "image": "${img}",
    "networkMode": "${network_mode}",
    "essential": true,
    "workingDirectory": "/var/solr",
    "entrypoint": [
      "/bin/bash",
      "-c",
      "${join(" ", [
        "init-var-solr;",
        "precreate-core authority /opt/solr/server/solr/configsets/authority;",
        "cp -r /opt/solr/server/solr/configsets/authority/* authority;",
        "precreate-core oai /opt/solr/server/solr/configsets/oai;",
        "cp -r /opt/solr/server/solr/configsets/oai/* oai;",
        "precreate-core search /opt/solr/server/solr/configsets/search;",
        "cp -r /opt/solr/server/solr/configsets/search/* search;",
        "precreate-core statistics /opt/solr/server/solr/configsets/statistics;",
        "cp -r /opt/solr/server/solr/configsets/statistics/* statistics;",
        "exec solr -f"
      ])}"
    ],
    "environment": [
      {
        "name": "SOLR_JAVA_MEM",
        "value": "-Xms${memory}m -Xmx${memory}m"
      },
      {
        "name": "SOLR_OPTS",
        "value": "-Dsolr.lock.type=${lock_type}"
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
        "awslogs-stream-prefix": "dspace"
      }
    }
  }
]
