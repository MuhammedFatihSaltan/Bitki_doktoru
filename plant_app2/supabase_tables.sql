-- Bitki Hastalıkları Tablosu
CREATE TABLE diseases (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  type TEXT NOT NULL,
  description TEXT,
  symptoms TEXT,
  treatment TEXT,
  prevention TEXT,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Teşhisler Tablosu
CREATE TABLE diagnoses (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id TEXT NOT NULL,
  disease_id UUID REFERENCES diseases(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  confidence DECIMAL(5,2) DEFAULT 0.0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Favoriler Tablosu
CREATE TABLE favorites (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id TEXT NOT NULL,
  disease_id UUID REFERENCES diseases(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, disease_id)
);

-- İndeksler
CREATE INDEX idx_diagnoses_user_id ON diagnoses(user_id);
CREATE INDEX idx_diagnoses_created_at ON diagnoses(created_at DESC);
CREATE INDEX idx_favorites_user_id ON favorites(user_id);
CREATE INDEX idx_diseases_type ON diseases(type);
CREATE INDEX idx_diseases_name ON diseases(name);

-- Row Level Security (RLS) Politikaları
ALTER TABLE diseases ENABLE ROW LEVEL SECURITY;
ALTER TABLE diagnoses ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

-- Herkes hastalıkları okuyabilir
CREATE POLICY "Hastalıklar herkese açık" ON diseases
  FOR SELECT USING (true);

-- Kullanıcılar sadece kendi teşhislerini görebilir
CREATE POLICY "Kullanıcılar kendi teşhislerini görebilir" ON diagnoses
  FOR SELECT USING (true);

CREATE POLICY "Kullanıcılar teşhis ekleyebilir" ON diagnoses
  FOR INSERT WITH CHECK (true);

-- Kullanıcılar sadece kendi favorilerini yönetebilir
CREATE POLICY "Kullanıcılar kendi favorilerini görebilir" ON favorites
  FOR SELECT USING (true);

CREATE POLICY "Kullanıcılar favori ekleyebilir" ON favorites
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Kullanıcılar favori silebilir" ON favorites
  FOR DELETE USING (true);

-- Örnek Hastalık Verileri
INSERT INTO diseases (name, category, type, description, symptoms, treatment, prevention) VALUES
('Domates Mildiyösü', 'Mantar / Domates', 'Sebze', 
 'Domates mildiyösü, Phytophthora infestans mantarının neden olduğu ciddi bir hastalıktır.',
 '• Yapraklarda kahverengi lekeler\n• Yaprak kenarlarında sararma\n• Meyvelerde çürüme\n• Gövdede kahverengi çizgiler',
 '• Bakır bazlı fungisitler kullanın\n• Etkilenen yaprakları temizleyin\n• Havalandırmayı artırın\n• Düzenli ilaçlama yapın',
 '• Dayanıklı çeşitler seçin\n• Bitki aralıklarını geniş tutun\n• Aşırı sulama yapmayın\n• Yaprakları kuru tutun'),

('Elma Kara Lekesi', 'Mantar / Elma', 'Meyve',
 'Elma ağaçlarında yaprak ve meyvelerde kara lekeler oluşturan mantar hastalığı.',
 '• Yapraklarda siyah lekeler\n• Erken yaprak dökümü\n• Meyvelerde çatlaklar\n• Deformasyonlar',
 '• Mantar ilaçları uygulayın\n• Düşen yaprakları toplayın\n• Budama yapın\n• Koruyucu spreyleme',
 '• Dayanıklı çeşitler kullanın\n• İyi havalandırma sağlayın\n• Düzenli budama yapın\n• Temiz bahçe tutun'),

('Gül Pası', 'Mantar / Gül', 'Mantar',
 'Gül yapraklarında turuncu-sarı lekeler oluşturan mantar hastalığı.',
 '• Yaprak altında turuncu sporlar\n• Yaprak üstünde sarı lekeler\n• Erken yaprak dökümü\n• Zayıf büyüme',
 '• Fungisit spreyi\n• Etkilenen yaprakları temizleyin\n• Havalandırmayı artırın\n• Kükürt bazlı ilaçlar',
 '• Dayanıklı çeşitler seçin\n• Yaprakları kuru tutun\n• Düzenli gübreleme\n• İyi drenaj sağlayın'),

('Biber Bakteriyel Lekesi', 'Bakteriyel / Biber', 'Bakteri',
 'Biber bitkilerinde bakteriyel enfeksiyon nedeniyle oluşan lekeler.',
 '• Yapraklarda kahverengi lekeler\n• Meyvelerde çürüme\n• Yaprak kenarlarında kuruma\n• Gövde çürümesi',
 '• Bakır bazlı bakterisitler\n• Etkilenen kısımları kesin\n• Havalandırma sağlayın\n• Steril aletler kullanın',
 '• Sertifikalı tohum kullanın\n• Bitki rotasyonu yapın\n• Aşırı nem yapmayın\n• Temiz ekipman kullanın'),

('Külleme', 'Mantar / Çeşitli', 'Mantar',
 'Birçok bitkide görülen beyaz pudra görünümlü mantar hastalığı.',
 '• Yapraklarda beyaz pudra\n• Yaprak deformasyonu\n• Büyüme geriliği\n• Erken yaprak dökümü',
 '• Kükürt spreyi\n• Süt-su karışımı\n• Fungisit uygulama\n• Etkilenen kısımları temizleme',
 '• İyi havalandırma\n• Aşırı azot gübrelemeden kaçının\n• Dayanıklı çeşitler\n• Düzenli kontrol'),

('Mısır Yaprak Yanıklığı', 'Mantar / Mısır', 'Sebze',
 'Mısır bitkilerinde yapraklarda yanık görünümü oluşturan hastalık.',
 '• Yapraklarda kahverengi çizgiler\n• Yaprak kenarlarında kuruma\n• Erken olgunlaşma\n• Verim kaybı',
 '• Fungisit uygulama\n• Etkilenen yaprakları temizleme\n• Bitki beslenmesi\n• Düzenli sulama',
 '• Dayanıklı hibrit çeşitler\n• Bitki rotasyonu\n• Dengeli gübreleme\n• Temiz tarla');

-- Storage bucket oluştur (Supabase Dashboard'dan yapılmalı)
-- Bucket adı: plant-images
-- Public: true
