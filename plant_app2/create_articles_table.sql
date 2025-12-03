-- Faydalı Bilgiler (Makaleler) Tablosu
CREATE TABLE articles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  category TEXT NOT NULL,
  content TEXT NOT NULL,
  icon TEXT DEFAULT 'eco',
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- İndeks
CREATE INDEX idx_articles_category ON articles(category);
CREATE INDEX idx_articles_created_at ON articles(created_at DESC);

-- Row Level Security
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Makaleler herkese açık" ON articles
  FOR SELECT USING (true);

-- Örnek Makaleler Ekle
INSERT INTO articles (title, category, content, icon) VALUES
('Gül Yapraklarında Beyaz Müdadele Edilir?', 'Bitki İçeriği',
 'Gül yapraklarında beyaz külleme, en yaygın mantar hastalıklarından biridir. Bu hastalıkla mücadele için:

1. Etkilenen yaprakları hemen temizleyin
2. Bitkilerin arasında yeterli hava sirkülasyonu sağlayın
3. Sabah saatlerinde sulama yapın
4. Kükürt bazlı fungisitler kullanın
5. Süt-su karışımı (1:9 oranında) spreyleyin

Önleme için dayanıklı gül çeşitleri seçin ve bitkileri çok sık sulamaktan kaçının.', 'eco'),

('Domateslerde Kök Çürüklüğünü Önlemenin 5 Yolu', 'Önerilen Tedbirler',
 'Domates bitkilerinde kök çürüklüğü ciddi verim kayıplarına neden olabilir. İşte önleme yöntemleri:

1. İyi Drenaj: Toprağın su tutmamasını sağlayın
2. Aşırı Sulama Yapmayın: Toprak nemini kontrol edin
3. Bitki Rotasyonu: Aynı yere 3-4 yıl domates ekmeyin
4. Sağlıklı Fide: Sertifikalı fideler kullanın
5. Toprak pH: 6.0-6.8 arasında tutun

Erken teşhis için bitkileri düzenli kontrol edin.', 'lightbulb_outline'),

('Meyve Ağaçlarında Budama Zamanı ve Teknikleri', 'Bitki İçeriği',
 'Doğru budama, meyve ağaçlarının sağlıklı büyümesi için kritiktir:

Budama Zamanı:
• Kış Budaması: Ocak-Şubat (ağaç uykudayken)
• Yaz Budaması: Haziran-Temmuz (hafif budama)

Temel Teknikler:
1. Keskin ve temiz aletler kullanın
2. Hasta ve kuru dalları kesin
3. İçe doğru büyüyen dalları temizleyin
4. Ağacın merkezini açık tutun
5. Kesim yerlerini macunla kapatın

Her ağaç türünün kendine özgü budama ihtiyacı vardır.', 'content_cut'),

('Organik Gübre Nasıl Hazırlanır?', 'Önerilen Tedbirler',
 'Evde organik gübre hazırlamak hem ekonomik hem de çevre dostudur:

Kompost Yapımı:
1. Yeşil Atıklar: Sebze-meyve artıkları, çim kırpıntıları
2. Kahverengi Atıklar: Kuru yapraklar, odun talaşı
3. Karıştırma: Haftada bir karıştırın
4. Nem: Nemli ama ıslak değil
5. Havalandırma: Oksijen gereklidir

2-3 ayda kullanıma hazır kompost elde edersiniz. Bitki çayı da hazırlayabilirsiniz.', 'compost'),

('Zararlılardan Doğal Yollarla Korunma', 'Bitki İçeriği',
 'Kimyasal kullanmadan zararlılarla mücadele mümkündür:

Doğal Yöntemler:
1. Uğur Böceği: Yaprak bitlerini yer
2. Sarımsak Spreyi: Böcekleri uzaklaştırır
3. Nane ve Fesleğen: Doğal kovucu
4. Sabunlu Su: Yumuşak gövdeli böceklere karşı
5. Tuzaklar: Sarı yapışkan tuzaklar

Biyolojik mücadele en güvenli yöntemdir.', 'bug_report'),

('Sera Kurulumu ve Yönetimi', 'Önerilen Tedbirler',
 'Başarılı sera yönetimi için dikkat edilmesi gerekenler:

Sera Kurulumu:
• Güneş alan bir yer seçin
• İyi havalandırma sistemi
• Sıcaklık kontrolü
• Sulama sistemi
• Gölgeleme imkanı

Yönetim:
1. Sıcaklık: 18-25°C arası ideal
2. Nem: %60-70 arası
3. Havalandırma: Günde 2-3 kez
4. Sulama: Düzenli ve kontrollü
5. Temizlik: Hastalık önleme için önemli

Sera, yıl boyu üretim imkanı sağlar.', 'home'),

('Bitki Hastalıklarını Erken Teşhis Etme', 'Bitki İçeriği',
 'Erken teşhis, başarılı tedavinin anahtarıdır:

Kontrol Listesi:
1. Yaprak Rengi: Sararma, lekeler
2. Yaprak Şekli: Kıvrılma, deformasyon
3. Gövde: Yaralar, çatlaklar
4. Kök: Çürüme, renk değişimi
5. Büyüme: Gerileme, bodurlaşma

Haftalık Kontrol:
• Sabah saatlerinde inceleyin
• Yaprak altlarını kontrol edin
• Fotoğraf çekerek karşılaştırın
• Şüpheli durumları kaydedin

Erken müdahale hastalığın yayılmasını önler.', 'medical_services'),

('Sulama Sistemleri ve Su Tasarrufu', 'Önerilen Tedbirler',
 'Doğru sulama, su tasarrufu ve bitki sağlığı için önemlidir:

Sulama Yöntemleri:
1. Damla Sulama: En verimli yöntem
2. Yağmurlama: Geniş alanlar için
3. Salma Sulama: Geleneksel yöntem
4. Mikro Spreyleme: Sera için ideal

Su Tasarrufu İpuçları:
• Sabah erken saatlerde sulayın
• Mulç kullanın (buharlaşmayı azaltır)
• Yağmur suyu toplayın
• Toprak nemini kontrol edin
• Aşırı sulama yapmayın

Doğru sulama %50 su tasarrufu sağlar.', 'water_drop'),

('Fidan Dikimi ve İlk Bakım', 'Bitki İçeriği',
 'Yeni fidan dikiminde başarı için önemli adımlar:

Dikim Öncesi:
1. Doğru zaman: İlkbahar veya sonbahar
2. Yer seçimi: Güneş ve toprak uygunluğu
3. Çukur hazırlığı: Kök topunun 2 katı
4. Toprak hazırlığı: Kompost ekleyin

Dikim Sırası:
• Fidanı çukura yerleştirin
• Kök boğazı toprak seviyesinde
• Toprağı sıkıştırın
• Bol su verin
• Destek kazığı kullanın

İlk Yıl Bakımı:
• Düzenli sulama
• Yabani ot kontrolü
• Hafif gübreleme
• Zararlı kontrolü

İlk yıl kritik dönemdir.', 'park'),

('Organik Tarımda Sertifikasyon Süreci', 'Önerilen Tedbirler',
 'Organik tarım sertifikası almak için gereken adımlar:

Gereksinimler:
1. 3 Yıl Geçiş Dönemi: Kimyasal kullanmadan
2. Kayıt Tutma: Tüm işlemleri kaydedin
3. Toprak Analizi: Düzenli testler
4. Tohum: Organik veya sertifikasız
5. Gübre: Sadece organik

Başvuru Süreci:
• Sertifikasyon kuruluşuna başvurun
• Denetim için hazırlık yapın
• Belgeleri tamamlayın
• Yıllık denetimler

Organik ürünler daha yüksek fiyata satılır.', 'verified');
