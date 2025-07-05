# auto-start-services
K9S has some failed services, this should correct without manual intervention
```
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
```
alternative 1
```
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
```
last alternative - easier to read and case for reporting
```
#!/bin/bash

services=(docker_registry.service dnsmasq.service tang.socket)

for svc in "${services[@]}"; do
  case "$(systemctl is-failed "$svc")" in
    failed)
      echo "$svc failed. Restarting..."
      systemctl restart "$svc"

      if systemctl is-active --quiet "$svc"; then
        echo "$svc is now active."
      else
        echo "Error: $svc is still not running."
      fi
      ;;
    *)
      echo "$svc is fine."
      ;;
  esac
done
```
