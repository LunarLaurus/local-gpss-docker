#!/bin/sh
# Get container's primary IP
CONTAINER_IP=$(hostname -i | awk '{print $1}')

# Write the config file
echo "{\"ip\":\"$CONTAINER_IP\",\"port\":13579}" > /app/local-gpss.json

# Run the app
exec dotnet /app/local-gpss.dll
