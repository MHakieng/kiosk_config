#!/bin/bash
# RASPBERRY PI KIOSK KURULUM
# Kullanım: chmod +x kiosk_setup.sh && sudo ./kiosk_setup.sh

KIOSK_ID="KIOSK-001"
KIOSK_URL="http://192.168.1.46:3000"

# Paketleri kur
apt-get update
apt-get install -y chromium unclutter

# Kiosk scripti
cat > /home/pi/kiosk.sh << EOF
#!/bin/bash
xset s off
xset s noblank
xset -dpms
unclutter -idle 0.1 -root &
chromium --kiosk --noerrdialogs --disable-infobars --disable-pinch --overscroll-history-navigation=0 --use-fake-ui-for-media-stream "${KIOSK_URL}?kiosk_id=${KIOSK_ID}"
EOF
chmod +x /home/pi/kiosk.sh

# Autostart
mkdir -p /home/pi/.config/lxsession/LXDE-pi
cat > /home/pi/.config/lxsession/LXDE-pi/autostart << EOF
@xset s off
@xset -dpms
@xset s noblank
@unclutter -idle 0.1 -root
@/home/pi/kiosk.sh
EOF

# Mikrofon izni
mkdir -p /etc/chromium/policies/managed
cat > /etc/chromium/policies/managed/policy.json << EOF
{"AudioCaptureAllowed":true,"AudioCaptureAllowedUrls":["*"],"DefaultMediaStreamSetting":1}
EOF

echo "Kurulum tamam. Reboot at: sudo reboot"
