#! /usr/bin/env bash

if [ "$HOSTNAME_ZOOKEEPER" != "" ]; then
	sleep 5
	nslookup $HOSTNAME_ZOOKEEPER >> zk.cluster

	echo "the zookeeper cluster is the following one"
	cat zk.cluster

	# Configure Zookeeper
	NO=$(($(wc -l < zk.cluster) - 2))

	while read line; do
		ip=$(echo $line | grep -oE "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b")
		echo "$ip" >> zk.cluster.tmp
	done < 'zk.cluster'
	rm zk.cluster

	sort -n zk.cluster.tmp > zk.cluster.tmp.sort
	mv zk.cluster.tmp.sort zk.cluster.tmp

	no_instances=1
	while read line; do
        	if [ "$line" != "" ]; then
			echo "$(cat hosts) $line:2181" >  hosts
			no_instances=$(($no_instances + 1))
		fi
	done < 'zk.cluster.tmp'

fi
#if [[ -z "$ZKHOSTS" ]]
#then
#	[[ -z "$ZK_PORT_2181_TCP_ADDR" ]] && echo "ZKHOSTS should be defined or container should be linked with zookeeper container as zk" && exit 1#
#	ZKHOSTS=$ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT
#fi
sed -i 's/^ *//' hosts 
sed -e 's/\s/,/g' hosts > hosts.txt

content=$(cat hosts.txt)
ZKHOSTS=$content

echo $ZKHOSTS
$KAFKA_MANAGER_HOME/bin/kafka-manager -Dkafka-manager.zkhosts=$ZKHOSTS
