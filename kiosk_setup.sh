#!/bin/bash
# RASPBERRY PI KIOSK KURULUM (FIXED + AUTOBOOT)

KIOSK_ID="KIOSK-001"
KIOSK_URL="http://192.168.1.46:3000"

# Aktif kullanıcıyı bul
USER_NAME=$(logname)
HOME_DIR="/home/$USER_NAME"

echo "Kullanıcı: $USER_NAME"
echo "Home: $HOME_DIR"

# Paketleri kur
sudo apt-get update
sudo apt-get install -y chromium unclutter x11-xserver-utils

# Kiosk scripti oluştur
cat > $HOME_DIR/kiosk.sh << EOF
#!/bin/bash
export DISPLAY=:0

xset s off
xset s noblank
xset -dpms

unclutter -idle 0.1 -root &

chromium --kiosk --noerrdialogs --disable-infobars \
--disable-pinch --overscroll-history-navigation=0 \
--use-fake-ui-for-media-stream "${KIOSK_URL}?kiosk_id=${KIOSK_ID}"
EOF

chmod +x $HOME_DIR/kiosk.sh

# SYSTEMD SERVICE (en sağlam yöntem)
sudo tee /etc/systemd/system/kiosk.service > /dev/null << EOF
[Unit]
Description=Chromium Kiosk Mode
After=graphical.target network-online.target

[Service]
User=$USER_NAME
Environment=DISPLAY=:0
ExecStart=$HOME_DIR/kiosk.sh
Restart=always
RestartSec=5

[Install]
WantedBy=graphical.target
EOF

# Servisi aktif et
sudo systemctl daemon-reload
sudo systemctl enable kiosk.service

echo "======================================"
echo "Kiosk kurulum tamamlandı"
echo "Simdi reboot at:"
echo "sudo reboot"
echo "======================================"
