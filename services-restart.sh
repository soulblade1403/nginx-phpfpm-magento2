#!/bin/bash
set -aeuo pipefail

cd src/ && git fetch && git pull && cd ../

docker container restart ${PROJECT}-php

docker exec -i ${PROJECT}-php bash -c "y | mage-upgrade"

echo "The upgrade script has completed execution."
echo "===================== 🚀 Done 🚀 ==================="
