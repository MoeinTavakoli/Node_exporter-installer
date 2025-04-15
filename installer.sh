#!/bin/bash
set -e

GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Source : https://patorjk.com/software/taag/#p=display&v=1&f=ANSI%20Shadow&t=Node-exporter%20Installer
echo -e "\n${GREEN}
███╗   ██╗ ██████╗ ██████╗ ███████╗    ███████╗██╗  ██╗██████╗  ██████╗ ██████╗ ████████╗███████╗██████╗     ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ 
████╗  ██║██╔═══██╗██╔══██╗██╔════╝    ██╔════╝╚██╗██╔╝██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝██╔════╝██╔══██╗    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
██╔██╗ ██║██║   ██║██║  ██║█████╗█████╗█████╗   ╚███╔╝ ██████╔╝██║   ██║██████╔╝   ██║   █████╗  ██████╔╝    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
██║╚██╗██║██║   ██║██║  ██║██╔══╝╚════╝██╔══╝   ██╔██╗ ██╔═══╝ ██║   ██║██╔══██╗   ██║   ██╔══╝  ██╔══██╗    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
██║ ╚████║╚██████╔╝██████╔╝███████╗    ███████╗██╔╝ ██╗██║     ╚██████╔╝██║  ██║   ██║   ███████╗██║  ██║    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝    ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝${NC}\n"

# --------------------------------------
# Configuration Vars
# --------------------------------------
export NODE_EXPORTER_VERSION="1.9.1"
export NODE_EXPORTER_URL="https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"

echo "==> Starting Node Exporter installation script"
echo "==> Node Exporter version set to: ${NODE_EXPORTER_VERSION}"
echo "==> Download URL: ${NODE_EXPORTER_URL}"

# --------------------------------------
# Download Node Exporter
# --------------------------------------
echo "==> Downloading Node Exporter archive..."
wget "$NODE_EXPORTER_URL"

# --------------------------------------
# User management
# --------------------------------------
echo "==> Creating node_exporter group and user (if not already exists)..."
sudo groupadd -f node_exporter
sudo id -u node_exporter &>/dev/null || sudo useradd -g node_exporter --no-create-home --shell /bin/false node_exporter

# --------------------------------------
# Extract and move files
# --------------------------------------
echo "==> Extracting Node Exporter archive..."
tar -xvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

echo "==> Renaming extracted folder..."
mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64 node_exporter-files

# --------------------------------------
# Binary installation
# --------------------------------------
echo "==> Copying binary to /usr/bin and setting permissions..."
sudo cp node_exporter-files/node_exporter /usr/bin/
sudo chown node_exporter:node_exporter /usr/bin/node_exporter

# --------------------------------------
# Service setup
# --------------------------------------
echo "==> Copying systemd service file..."
sudo cp node_exporter.service /usr/lib/systemd/system/node_exporter.service
sudo chmod 664 /usr/lib/systemd/system/node_exporter.service

# --------------------------------------
# Systemd service management
# --------------------------------------
echo "==> Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "==> Starting node_exporter service..."
sudo systemctl start node_exporter

echo "==> Checking node_exporter service status..."
sudo systemctl status node_exporter

echo "==> Enabling node_exporter service on boot..."
sudo systemctl enable node_exporter.service

echo "==> Node Exporter installation and setup completed successfully!"
