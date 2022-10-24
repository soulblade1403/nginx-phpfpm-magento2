#!/bin/bash
set -aeuo pipefail

rm -f docker-compose.yml; envsubst < "template.yml" > "docker-compose.yml";

echo "Start Containers"
docker-compose up -d db phpmyadmin redis
touch checkHealth.txt
while [[ $(cat checkHealth.txt) != "healthy" ]]; do
  echo $(docker inspect --format='{{json .State.Health}}' ${PROJECT}-mysql | jq -r '.Status') > checkHealth.txt
  sleep 2
  echo -n "."
done
sleep 30; docker-compose up -d

echo "Check container start"
docker ps -a

echo "Setup magento 2 project into docker"
if [ ! -f ./src/app/etc/env.php ]; then
  docker exec -i $PROJECT-php bash -c "y | mage-setup"
else
  docker exec -i $PROJECT-php bash -c "y | mage-upgrade"
fi

echo "The setup script has completed execution."
echo "
===================== 🚀 Done 🚀 ===================
      Created by Soulblade
      Access your new links:
      🌎 Web server: http://${VHOST}/
      ⚙️ PHPMyAdmin: http://$(hostname  -I | cut -f1 -d' '):${PHPMYADMIN_PORT}
===================== 🚀 Done 🚀 ==================="
