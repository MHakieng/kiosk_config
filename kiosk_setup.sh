#!/bin/bash
# Raspberry Pi Kiosk Kurulum Scripti
# Her kiosk için KIOSK_ID ve KIOSK_URL değerlerini değiştirin

# YAPILANDIRMA
KIOSK_ID="KIOSK-001"
KIOSK_URL="http://192.168.1.46:3000"

echo "Kiosk kurulumu başlıyor..."
echo "Kiosk ID: $KIOSK_ID"
echo "URL: $KIOSK_URL"

# Gerekli paketleri kur
sudo apt-get update
sudo apt-get install -y chromium-browser unclutter

# Kiosk başlatma scripti oluştur
cat > /home/pi/kiosk.sh << EOF
#!/bin/bash
# Ekran koruyucuyu kapat
xset s off
xset s noblank
xset -dpms

# Mouse imlecini gizle
unclutter -idle 0.1 -root &

# Chromium kiosk modunda aç
chromium-browser --kiosk --noerrdialogs --disable-infobars --disable-pinch --overscroll-history-navigation=0 --use-fake-ui-for-media-stream "${KIOSK_URL}?kiosk_id=${KIOSK_ID}"
EOF

chmod +x /home/pi/kiosk.sh

# Autostart ayarla
mkdir -p /home/pi/.config/lxsession/LXDE-pi
cat > /home/pi/.config/lxsession/LXDE-pi/autostart << EOF
@xset s off
@xset -dpms
@xset s noblank
@unclutter -idle 0.1 -root
@/home/pi/kiosk.sh
EOF

# Mikrofon izinlerini otomatik ver
sudo mkdir -p /etc/chromium/policies/managed
sudo tee /etc/chromium/policies/managed/policy.json > /dev/null << EOF
{
    "AudioCaptureAllowed": true,
    "AudioCaptureAllowedUrls": ["*"],
    "DefaultMediaStreamSetting": 1
}
EOF

echo ""
echo "Kurulum tamamlandı!"
echo "URL: ${KIOSK_URL}?kiosk_id=${KIOSK_ID}"
echo ""
echo "Sistemi yeniden başlatın: sudo reboot"
