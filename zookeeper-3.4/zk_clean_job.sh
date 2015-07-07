#!/usr/bin/env bash

ADDED="$(crontab -l | grep zkCleanup.sh | wc -l)"

if [ "$ADDED" != "0" ]; then
	exit;
fi

# workaround for zkCleanup.sh. We need cleanup only snapshots /var/lib/zookeper
sed -i '/ZOODATALOGDIR/ s/^/#/' /opt/zookeeper/bin/zkCleanup.sh
# Daily cleanup. After cleanup will remain only 3 last snapshots
crontab -l | { cat; echo "0	0	*	*	*	/opt/zookeeper/bin/zkCleanup.sh -n 3"; echo ; } | crontab -

/usr/sbin/crond&
