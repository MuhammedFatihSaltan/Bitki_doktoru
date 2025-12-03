-- Daha fazla hastalık ekle
INSERT INTO diseases (name, category, type, description, symptoms, treatment, prevention) VALUES

-- SEBZE HASTALIKLARI
('Patates Yanıklığı', 'Mantar / Patates', 'Sebze',
 'Patates bitkilerinde yaprak ve yumrularda yanık oluşturan ciddi bir hastalık.',
 '• Yapraklarda kahverengi lekeler
• Yaprak kenarlarında kuruma
• Yumrularda çürüme
• Gövdede siyah lekeler',
 '• Bakır bazlı fungisitler
• Etkilenen bitkileri temizleyin
• Havalandırmayı artırın
• Koruyucu ilaçlama',
 '• Dayanıklı çeşitler kullanın
• Bitki rotasyonu yapın
• Aşırı sulama yapmayın
• Temiz tohum kullanın'),

('Hıyar Mildiyösü', 'Mantar / Hıyar', 'Sebze',
 'Hıyar bitkilerinde yapraklarda sarı lekeler ve beyaz küf oluşturan hastalık.',
 '• Yapraklarda sarı lekeler
• Yaprak altında beyaz küf
• Erken yaprak dökümü
• Meyve kalitesinde düşüş',
 '• Fungisit spreyi
• Havalandırmayı artırın
• Etkilenen yaprakları temizleyin
• Düzenli ilaçlama',
 '• Dayanıklı çeşitler seçin
• Bitki aralıklarını geniş tutun
• Sabah sulama yapın
• İyi drenaj sağlayın'),

('Patlıcan Solgunluğu', 'Mantar / Patlıcan', 'Sebze',
 'Patlıcan bitkilerinde damar sistemini tıkayan mantar hastalığı.',
 '• Yapraklarda sararma
• Bitki solgunluğu
• Gövdede kahverengileşme
• Meyve düşmesi',
 '• Etkilenen bitkileri söküp yakın
• Toprak dezenfeksiyonu
• Dayanıklı çeşit kullanın
• Bitki rotasyonu',
 '• Sertifikalı fide kullanın
• 4-5 yıl rotasyon yapın
• Toprak pH'ını ayarlayın
• Aşırı azot gübrelemeden kaçının'),

('Kabak Külleme', 'Mantar / Kabak', 'Sebze',
 'Kabak bitkilerinde yapraklarda beyaz pudra görünümü oluşturan hastalık.',
 '• Yapraklarda beyaz pudra
• Yaprak deformasyonu
• Fotosentez azalması
• Verim kaybı',
 '• Kükürt spreyi
• Süt-su karışımı (1:9)
• Fungisit uygulama
• Etkilenen yaprakları temizleme',
 '• Dayanıklı çeşitler
• İyi havalandırma
• Yaprakları kuru tutun
• Düzenli kontrol'),

('Soğan Küf Hastalığı', 'Mantar / Soğan', 'Sebze',
 'Soğan bitkilerinde yaprak ve soğanlarda küf oluşturan hastalık.',
 '• Yapraklarda gri lekeler
• Soğanlarda yumuşama
• Kötü koku
• Depolama kayıpları',
 '• Etkilenen soğanları ayıklayın
• Depoyu havalandırın
• Fungisit uygulama
• Düşük sıcaklıkta depolama',
 '• Sağlıklı tohum kullanın
• İyi kurutma yapın
• Uygun depolama koşulları
• Bitki rotasyonu'),

-- MEYVE HASTALIKLARI
('Şeftali Yaprak Kıvırcıklığı', 'Mantar / Şeftali', 'Meyve',
 'Şeftali ağaçlarında yaprakların kıvırılmasına neden olan mantar hastalığı.',
 '• Yapraklarda kıvrılma
• Kırmızı-mor renklenme
• Yaprak kalınlaşması
• Erken yaprak dökümü',
 '• Bakır bazlı fungisitler
• Kış ilaçlaması
• Etkilenen yaprakları temizleyin
• Bahar ilaçlaması',
 '• Dayanıklı çeşitler
• Kış uykusunda ilaçlama
• Düzenli budama
• İyi havalandırma'),

('Üzüm Mildiyösü', 'Mantar / Üzüm', 'Meyve',
 'Üzüm bağlarında yaprak, sürgün ve salkımlarda zarar yapan hastalık.',
 '• Yapraklarda yağ lekesi
• Yaprak altında beyaz küf
• Salkımlarda çürüme
• Verim kaybı',
 '• Bakır bazlı fungisitler
• Sistemik ilaçlar
• Koruyucu spreyleme
• Etkilenen kısımları temizleme',
 '• Dayanıklı çeşitler
• Bağ havalandırması
• Düzenli ilaçlama
• Temiz bağ tutma'),

('Kiraz Yaprak Lekesi', 'Mantar / Kiraz', 'Meyve',
 'Kiraz ağaçlarında yapraklarda mor-kahverengi lekeler oluşturan hastalık.',
 '• Yapraklarda mor lekeler
• Leke ortasında delik
• Erken yaprak dökümü
• Zayıf meyve kalitesi',
 '• Fungisit spreyi
• Düşen yaprakları toplayın
• Bahar ilaçlaması
• Koruyucu tedbirler',
 '• Dayanıklı çeşitler
• Düzenli budama
• İyi drenaj
• Temiz bahçe'),

('Armut Ateş Yanıklığı', 'Bakteriyel / Armut', 'Meyve',
 'Armut ağaçlarında dalların yanmış gibi görünmesine neden olan bakteriyel hastalık.',
 '• Dalların siyahlaşması
• Çiçek ve meyve yanıklığı
• Sürgün ölümü
• Ağaç zayıflaması',
 '• Etkilenen dalları kesin
• Bakır spreyi
• Antibiyotik uygulama
• Steril aletler kullanın',
 '• Dayanıklı çeşitler
• Aşırı azot gübrelemeden kaçının
• Düzenli kontrol
• Temiz budama'),

('Kayısı Monilya', 'Mantar / Kayısı', 'Meyve',
 'Kayısı ağaçlarında meyve çürümesine neden olan mantar hastalığı.',
 '• Meyvelerde kahverengi çürüme
• Meyve üzerinde gri küf
• Mumyalaşmış meyveler
• Çiçek yanıklığı',
 '• Fungisit spreyi
• Mumya meyveleri toplayın
• Çiçeklenme öncesi ilaçlama
• Hasat sonrası ilaçlama',
 '• Dayanıklı çeşitler
• İyi havalandırma
• Düzenli budama
• Temiz bahçe'),

-- MANTAR HASTALIKLARI
('Paslanma Hastalığı', 'Mantar / Çeşitli', 'Mantar',
 'Birçok bitkide yapraklarda pas rengi lekeler oluşturan hastalık.',
 '• Yapraklarda turuncu-kahverengi lekeler
• Yaprak altında sporlar
• Erken yaprak dökümü
• Büyüme geriliği',
 '• Fungisit spreyi
• Etkilenen yaprakları temizleyin
• Kükürt uygulama
• Koruyucu ilaçlama',
 '• Dayanıklı çeşitler
• İyi havalandırma
• Yaprakları kuru tutun
• Bitki rotasyonu'),

('Antraknoz', 'Mantar / Çeşitli', 'Mantar',
 'Meyve ve sebzelerde çökük kahverengi lekeler oluşturan hastalık.',
 '• Meyvelerde çökük lekeler
• Yapraklarda kahverengi lekeler
• Gövdede yaralar
• Meyve çürümesi',
 '• Fungisit uygulama
• Etkilenen kısımları temizleyin
• Koruyucu spreyleme
• Hasat sonrası işlem',
 '• Sertifikalı tohum
• Bitki rotasyonu
• İyi drenaj
• Temiz tarla'),

('Kök Çürüklüğü', 'Mantar / Çeşitli', 'Mantar',
 'Bitkilerin kök sisteminde çürümeye neden olan toprak kökenli hastalık.',
 '• Bitki solgunluğu
• Yapraklarda sararma
• Köklerde çürüme
• Bitki ölümü',
 '• Toprak dezenfeksiyonu
• Drenajı iyileştirin
• Fungisit uygulama
• Etkilenen bitkileri söküp yakın',
 '• İyi drenaj sağlayın
• Aşırı sulama yapmayın
• Sağlıklı fide kullanın
• Toprak pH'ını ayarlayın'),

-- BAKTERİYEL HASTALIKLARI
('Domates Bakteriyel Kanser', 'Bakteriyel / Domates', 'Bakteri',
 'Domates bitkilerinde damar sistemini etkileyen bakteriyel hastalık.',
 '• Yapraklarda solgunluk
• Gövdede kahverengi çizgiler
• Meyvelerde beyaz lekeler
• Bitki ölümü',
 '• Etkilenen bitkileri söküp yakın
• Bakır spreyi
• Toprağı dezenfekte edin
• Steril aletler kullanın',
 '• Sertifikalı tohum kullanın
• Bitki rotasyonu (3-4 yıl)
• Aşırı nem yapmayın
• Temiz ekipman'),

('Fasulye Bakteriyel Yanıklığı', 'Bakteriyel / Fasulye', 'Bakteri',
 'Fasulye bitkilerinde yaprak ve baklalarda yanık oluşturan hastalık.',
 '• Yapraklarda kahverengi lekeler
• Baklalarda çökük yaralar
• Yaprak kenarlarında kuruma
• Verim kaybı',
 '• Bakır bazlı bakterisitler
• Etkilenen bitkileri temizleyin
• Havalandırma sağlayın
• Koruyucu spreyleme',
 '• Sertifikalı tohum
• Bitki rotasyonu
• Kuru havada çalışın
• Temiz ekipman'),

('Lahana Kara Çürüklük', 'Bakteriyel / Lahana', 'Bakteri',
 'Lahana türü sebzelerde damar kararmasına neden olan bakteriyel hastalık.',
 '• Yaprak kenarlarında V şeklinde sararma
• Damar kararması
• Yaprak dökümü
• Baş oluşmama',
 '• Etkilenen bitkileri söküp yakın
• Bakır spreyi
• Bitki rotasyonu
• Tohum dezenfeksiyonu',
 '• Sertifikalı tohum kullanın
• 2-3 yıl rotasyon
• Aşırı sulama yapmayın
• Temiz tarla'),

('Havuç Yumuşak Çürüklük', 'Bakteriyel / Havuç', 'Bakteri',
 'Havuçta yumuşama ve kötü koku ile karakterize bakteriyel hastalık.',
 '• Havuçta yumuşama
• Kötü koku
• Sulu çürüme
• Depolama kayıpları',
 '• Etkilenen havuçları ayıklayın
• Depoyu havalandırın
• Düşük sıcaklıkta depolama
• Hijyenik koşullar',
 '• Hasat yaralanmalarından kaçının
• Hızlı soğutma yapın
• Uygun depolama koşulları
• Temiz ekipman'),

('Elma Ateş Yanıklığı', 'Bakteriyel / Elma', 'Bakteri',
 'Elma ağaçlarında dalların yanmış gibi görünmesine neden olan hastalık.',
 '• Dalların siyahlaşması
• Çiçek yanıklığı
• Meyve çürümesi
• Sürgün ölümü',
 '• Etkilenen dalları kesin (30 cm aşağıdan)
• Bakır spreyi
• Antibiyotik uygulama
• Steril aletler (alkol ile temizleyin)',
 '• Dayanıklı çeşitler
• Aşırı azot gübrelemeden kaçının
• Düzenli kontrol
• Temiz budama'),

('Zeytin Verem Hastalığı', 'Bakteriyel / Zeytin', 'Bakteri',
 'Zeytin ağaçlarında dal ve gövdede ur oluşturan bakteriyel hastalık.',
 '• Dal ve gövdede urlar
• Yaprak dökümü
• Zayıf büyüme
• Verim kaybı',
 '• Urları kesin ve yakın
• Bakır spreyi
• Yara yerlerini kapatın
• Steril aletler kullanın',
 '• Sağlıklı fidan kullanın
• Dondan koruyun
• Budama yaralarını kapatın
• Düzenli kontrol');
