#! /bin/bash

# Creating an user 
# - without a home directory
# - specifying new users login shell as /bin/false
# - created as system account
sudo useradd -M -r -s /bin/false node_exporter

# Download and extract node exporter binary
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
tar xvfz node_exporter-0.18.1.linux-amd64.tar.gz

# Copy of the node exporter binary to the appropriate location
sudo cp node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Creating and enabling a systemd service
sudo cat > /etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter


# Verify that metrics are being exposed
# curl localhost:9100/metrics

