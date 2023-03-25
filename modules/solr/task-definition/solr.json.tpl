[
  {
    "name": "solr",
    "image": "${img}",
    "networkMode": "${network_mode}",
    "essential": true,
    "memoryReservation": ${memory},
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
      }
    ],
    "portMappings": [
      {
        "containerPort": ${port}
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "${name}",
        "containerPath": "/var/solr"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${name}"
      }
    }
  }
]
