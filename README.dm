How to use:

sudo apt update && sudo apt upgrade -y
sudo apt install wget jq nano -y

printf "[Unit]
Description=Auto-updater
After=network.target

[Service]
type=forking
User=root
Environment=HOME=/root
WorkingDirectory=/root
ExecStartPre=/usr/bin/wget -qO /root/.zeitgeist/tools.sh https://raw.githubusercontent.com/letsnode/zeitgeist/main/tools.sh
ExecStartPre=/usr/bin/chmod +x /root/.zeitgeist/tools.sh
ExecStart=/root/.zeitgeist/tools.sh -u
Restart=always
RestartSec=1m

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/zeitgeistu.service
systemctl daemon-reload
systemctl enable zeitgeistu
systemctl restart zeitgeistu
