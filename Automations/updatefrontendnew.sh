#!/bin/bash

# --- GCP values (replace with your node if different) -----------------
INSTANCE_NAME="gke-wanderlust-wanderlust-pool-7ae4065e-439s"
ZONE="us-central1-c"
# ----------------------------------------------------------------------

# Retrieve the external IP of the chosen GCP instance
ipv4_address=$(gcloud compute instances describe "$INSTANCE_NAME" \
  --zone "$ZONE" \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

# Path to the .env file
file_to_find="../frontend/.env.docker"

# Read the entire file (single‑line env file in this case)
current_url=$(cat "$file_to_find")

# Update the .env file if the IP address has changed
if [[ "$current_url" != "VITE_API_PATH=\"http://${ipv4_address}:31100\"" ]]; then
    if [ -f "$file_to_find" ]; then
        sed -i -e "s|VITE_API_PATH.*|VITE_API_PATH=\"http://${ipv4_address}:31100\"|g" "$file_to_find"
        echo "✅ VITE_API_PATH updated to http://${ipv4_address}:31100"
    else
        echo "❌ ERROR: File not found: $file_to_find"
    fi
else
    echo "✅ No change needed. IP is already up‑to‑date."
fi
