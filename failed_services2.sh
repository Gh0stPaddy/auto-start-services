#!/bin/bash

for service in docker_registry.service dnsmasq.service tang.socket; do
  if systemctl is-failed --quiet "$service"; then
    echo "[$service] failed. Restarting..."
    systemctl restart "$service"

    if systemctl is-active --quiet "$service"; then
      echo "[$service] restarted successfully."
    else
      echo "[$service] failed to restart. Still not active."
    fi
  else
    echo "[$service] is okay."
  fi
done
