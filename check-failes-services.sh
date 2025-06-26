#!/bin/bash

# List of services to monitor
SERVICES=(
  docker_registry.service
  dnsmasq.service
  >> [check service name]<<
)

# Loop through each service
for SERVICE in "${SERVICES[@]}"; do
  STATUS=$(systemctl is-failed "$SERVICE")

  if [ "$STATUS" == "failed" ]; then
    echo "[$(date)] Service $SERVICE is FAILED. Attempting restart..."
    systemctl restart "$SERVICE"

    if [ $? -eq 0 ]; then
      echo "[$(date)] Successfully restarted $SERVICE."
    else
      echo "[$(date)] ERROR: Failed to restart $SERVICE!"
    fi
  else
    echo "[$(date)] Service $SERVICE is OK. Status: $STATUS"
  fi
done
