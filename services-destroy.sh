#!/usr/bin/env bash
set -aeuo pipefail

# stop and remove container
docker-compose down -v --rmi local

echo "===================== 🚀 BYE 🚀 ==================="
