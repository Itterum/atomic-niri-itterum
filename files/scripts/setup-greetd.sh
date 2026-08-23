#!/usr/bin/bash
set -euo pipefail

systemctl disable sddm.service || true
systemctl enable greetd.service
systemctl set-default graphical.target

mkdir -p /var/cache/dms-greeter
chown greeter:greeter /var/cache/dms-greeter
chmod 2770 /var/cache/dms-greeter
