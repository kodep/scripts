#!/bin/bash

extract_backup() {
    if [ -n "$backupfile" ]; then
        tar xvf $backupfile
    fi
   
}

clean_database_data() {
  set +e
  docker exec harbor-db psql -U postgres -d template1 -c "REVOKE CONNECT ON DATABASE registry FROM public;"
  docker exec harbor-db psql -U postgres -d template1 -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'registry';"
  docker exec harbor-db psql -U postgres -d template1 -c "drop database registry;" 
  docker exec harbor-db psql -U postgres -d template1 -c "drop database postgres;"
  docker exec harbor-db psql -U postgres -d template1 -c "drop database notarysigner; "
  docker exec harbor-db psql -U postgres -d template1 -c "drop database notaryserver;"
  set -e 

  docker exec harbor-db psql -U postgres -d template1 -c "create database registry;"
  docker exec harbor-db psql -U postgres -d template1 -c "create database postgres;"
  docker exec harbor-db psql -U postgres -d template1 -c "create database notarysigner;"
  docker exec harbor-db psql -U postgres -d template1 -c "create database notaryserver;"
}

restore_database() {
    docker cp /home/kodep/harbor-backup/db/registry.sql harbor-db:/tmp/
    docker cp /home/kodep/harbor-backup/db/postgres.sql harbor-db:/tmp/
    docker cp /home/kodep/harbor-backup/db/notarysigner.sql harbor-db:/tmp/
    docker cp /home/kodep/harbor-backup/db/notaryserver.sql harbor-db:/tmp/
    docker exec harbor-db sh -c 'psql -U postgres registry < /tmp/registry.sql'
    docker exec harbor-db sh -c 'psql -U postgres postgres < /tmp/postgres.sql'
    docker exec harbor-db sh -c 'psql -U postgres notarysigner < /tmp/notarysigner.sql'
    docker exec harbor-db sh -c 'psql -U postgres notaryserver < /tmp/notaryserver.sql'
    docker exec -u root harbor-db sh -c 'rm -f /tmp/*'
}

restore_registry() {
    cp -r harbor-backup/registry/ /mnt/volume-harbor/
    chown -R 10000 /mnt/volume-harbor/registry
}

restore_redis() {
    cp -r harbor-backup/redis/ /mnt/volume-harbor/
    chown -R 999 /mnt/volume-harbor/redis
}

restore_secret() {
    if [ -f harbor-backup/secret/secretkey ]; then
        cp -f harbor-backup/secret/secretkey /mnt/volume-harbor/secretkey 
    fi
    if [ -f harbor-backup/secret/defaultalias ]; then
        cp -f harbor-backup/secret/defaultalias /mnt/volume-harbor/secretkey 
    fi
    if [ -d harbor-backup/secret/keys ]; then
        cp -r harbor-backup/secret/keys/ /mnt/volume-harbor/secret/
    fi
}

del_useless_dir() {
    rm -rf harbor-backup
}

if [ $# -eq 0 ]
then
    echo "Необходимо добавить параметр --backupfile [filename]"
    exit 1
else
    while [ $# -gt 0 ]; do
        case $1 in
            --backupfile)
            if [ "$2" == "" ]
            then
                echo "Необходимо указать название backup-файла."
                exit 1
            else
                backupfile=$2
            fi
            shift ;;
            *)
            echo "Необходимо добавить параметр --backupfile [filename]"
            exit 1;;
        esac
        shift
    done
fi

set -ex

extract_backup
clean_database_data
restore_database
restore_redis
restore_registry
restore_secret
del_useless_dir