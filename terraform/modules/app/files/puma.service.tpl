[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple
User=appuser
Environment=DATABASE_URL=${db_url}
WorkingDirectory=/home/appuser/reddit
ExecStart=/bin/bash -lc 'puma'
Restart=always
ExecReload=/bin/kill -USR2 $MAINPID
PIDFile=/var/run/puma.pid

[Install]
WantedBy=multi-user.target
