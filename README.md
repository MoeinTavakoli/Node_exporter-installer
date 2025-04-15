# Node Exporter Installer

This repository contains a Bash script that automates the installation and setup of [Prometheus Node Exporter](https://github.com/prometheus/node_exporter) as a `systemd` service on Linux.

## 📦 Features

- Downloads and installs a specific version of Node Exporter
- Creates a dedicated system user and group for running the service
- Sets proper permissions and directories
- Configures and enables Node Exporter as a systemd service
- Displays progress at each step

---

## ⚙️ Prerequisites

- Linux system with `systemd`
- `wget`, `tar`, and `systemctl` installed
- Root or `sudo` privileges

---

## 🚀 Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/MoeinTavakoli/Node_exporter-installer.git
   cd Node_exporter-installer
   ```

2. Make the installer script executable:

   ```bash
   chmod +x installer.sh
   ```

3. Run the script:

   ```bash
   ./installer.sh
   ```

4. Verify the Node Exporter service:

   ```bash
   systemctl status node_exporter
   ```

---

## 📁 Files

- `installer.sh` – The main installation script
- `node_exporter.service` – A systemd service unit file for Node Exporter

---

## 🛠️ Example Systemd Service File

```ini
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/bin/node_exporter

[Install]
WantedBy=default.target
```

---

## 🔧 Customization

To install a different version of Node Exporter, edit the `NODE_EXPORTER_VERSION` variables in `installer.sh`.

---

