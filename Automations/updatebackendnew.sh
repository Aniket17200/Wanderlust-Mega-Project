#!/bin/bash

# Set the GCP instance name and zone
INSTANCE_NAME="gke-wanderlust-wanderlust-pool-7ae4065e-439s"
ZONE="us-central1-c"

# Retrieve the public IP address of the specified GCP instance
ipv4_address=$(gcloud compute instances describe "$INSTANCE_NAME" \
  --zone "$ZONE" \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

# Path to the .env file
file_to_find="../backend/.env.docker"

# Check the current FRONTEND_URL in the .env file
current_url=$(sed -n "4p" "$file_to_find")

# Update the .env file if the IP address has changed
if [[ "$current_url" != "FRONTEND_URL=\"http://${ipv4_address}:5173\"" ]]; then
    if [ -f "$file_to_find" ]; then
        sed -i -e "s|FRONTEND_URL.*|FRONTEND_URL=\"http://${ipv4_address}:5173\"|g" "$file_to_find"
        echo "✅ FRONTEND_URL updated to http://${ipv4_address}:5173"
    else
        echo "❌ ERROR: File not found at $file_to_find"
    fi
else
    echo "✅ No change needed. IP is already up-to-date."
fi
