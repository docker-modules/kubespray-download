#!/bin/sh
set -e

nohup dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 &

cd /tmp/download

ansible-playbook \
	-i kubespray/inventory/local/hosts.ini \
	-e download_localhost=true \
	-e download_always_pull=true \
	-e local_release_dir=/tmp/download/releases \
	-e ingress_nginx_enabled=true \
	--tags download \
	kubespray/cluster.yml

docker save $(docker images | sed '1d' | awk '{print $1 ":" $2}') -o containers.tar

exec "$@"