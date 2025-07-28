#!/bin/sh

prog=$(basename "$0")
if ! [ -S /var/run/docker.sock ]
then
	echo "$prog: there are no running docker" >&2
	exit 2
fi

cd "$(dirname "$0")" || exit
PATH=$(pwd):$PATH
plugin=mackerel-plugin-oracle
if ! which "$plugin" >/dev/null
then
	echo "$prog: $plugin is not installed" >&2
	exit 2
fi

password=password
port=11521
image=container-registry.oracle.com/database/free:latest

docker run -d \
	--name "test-$plugin" \
	-p $port:1521 \
	-e ORACLE_PWD=$password \
	"$image"
trap 'docker stop test-$plugin; docker rm test-$plugin; exit 1' 1 2 3 15
sleep 10

#export MACKEREL_PLUGIN_WORKDIR=tmp

# wait until bootstrap mysqld..
for i in $(seq 5)
do
	echo "Connecting $i..."
	if $plugin -sid FREE -port $port -password $password >/dev/null 2>&1
	then
		break
	fi
	sleep 3
done
sleep 1

$plugin -sid FREE -username SYS -port $port -password $password >/dev/null 2>&1
status=$?
sleep 1

docker stop "test-$plugin"
docker rm "test-$plugin"
exit $status
