changes
1. Değişiklik: Kiosk ID artık URL parametresinden okunuyor (?kiosk_id=XXX)

index.html'de eklenen script:

const urlParams = new URLSearchParams(window.location.search);
const kioskId = urlParams.get('kiosk_id');
if (kioskId) {
    localStorage.setItem('kiosk_id', kioskId);
    document.querySelectorAll('a').forEach(link => {
        const url = new URL(link.href, window.location.origin);
        url.searchParams.set('kiosk_id', kioskId);
        link.href = url.toString();
    });
}



2. Değişiklik: findOrCreate kullanarak, gelen kiosk_id veritabanında yoksa otomatik oluşturuluyor.

const [kiosk, created] = await Kiosk.findOrCreate({
    where: { kiosk_id: data.kiosk_id },
    defaults: {
        kiosk_id: data.kiosk_id,
        domain_label: 'Auto-created',
        kiosk_status_id: 1
    }
});

Dosya: 
kiosk/ingest/controllers.js