#!/bin/sh
#
# Safe IPv6 disable script for Proxmox LXC
# Only uses sysctl (recommended approach)
#

CONF_FILE="/etc/sysctl.d/99-disable-ipv6.conf"

echo "[+] Creating IPv6 disable sysctl config..."

cat <<EOF > "$CONF_FILE"
# Disable IPv6 inside LXC
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
EOF

echo "[+] Applying sysctl settings..."
sysctl --system >/dev/null 2>&1

echo "[+] Verifying IPv6 status..."

if ip -6 route 2>/dev/null | grep -q default; then
    echo "[!] IPv6 route still present (check Proxmox config)"
else
    echo "[✓] No IPv6 default route detected"
fi

if curl -6 -m 3 https://ifconfig.me >/dev/null 2>&1; then
    echo "[!] IPv6 connectivity still works"
else
    echo "[✓] IPv6 connectivity disabled"
fi

echo "[✓] Done. Reboot container recommended."
