import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sıkça Sorulan Sorular',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFAQItem(
            'Uygulama nasıl çalışır?',
            'Bitkinizin fotoğrafını çekin, yapay zeka modelimiz hastalığı tespit edecek ve size tedavi önerileri sunacaktır.',
          ),
          _buildFAQItem(
            'Sonuçlar ne kadar güvenilir?',
            'Uygulamamız test aşamasındadır. Sonuçları referans amaçlı kullanın ve ciddi durumlarda mutlaka bir uzmana danışın.',
          ),
          _buildFAQItem(
            'Hangi bitki türlerini destekliyorsunuz?',
            'Şu anda domates, gül, elma ve diğer yaygın bitki türlerini destekliyoruz. Sürekli olarak yeni türler ekliyoruz.',
          ),
          _buildFAQItem(
            'Fotoğraf çekerken nelere dikkat etmeliyim?',
            'Fotoğrafı iyi ışıkta, net ve hastalıklı bölgeye odaklanarak çekin. Bulanık veya karanlık fotoğraflar yanlış sonuç verebilir.',
          ),
          _buildFAQItem(
            'Teşhis geçmişim nerede saklanıyor?',
            'Tüm verileriniz güvenli Firebase sunucularında şifrelenerek saklanmaktadır.',
          ),
          _buildFAQItem(
            'Ücretsiz mi?',
            'Evet, uygulama şu anda tamamen ücretsizdir.',
          ),
          _buildFAQItem(
            'Offline çalışır mı?',
            'Hayır, hastalık tespiti için internet bağlantısı gereklidir.',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
