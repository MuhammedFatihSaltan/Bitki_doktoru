import 'package:flutter/material.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

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
          'Kullanım Kılavuzu',
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
          _buildGuideSection(
            '1. Kayıt Olun',
            'Uygulamayı kullanmak için önce bir hesap oluşturun. Email ve şifrenizi girerek hızlıca kayıt olabilirsiniz.',
            Icons.person_add,
          ),
          _buildGuideSection(
            '2. Fotoğraf Çekin',
            'Ana sayfadaki "Yeni Teşhis Başlat" butonuna tıklayın. Bitkinizin hastalıklı bölgesinin net bir fotoğrafını çekin.',
            Icons.camera_alt,
          ),
          _buildGuideSection(
            '3. Sonuçları İnceleyin',
            'Yapay zeka modelimiz fotoğrafı analiz edecek ve hastalık teşhisi koyacaktır. Sonuç ekranında hastalık bilgisi ve tedavi önerilerini göreceksiniz.',
            Icons.analytics,
          ),
          _buildGuideSection(
            '4. Tedavi Uygulayın',
            'Önerilen tedavi yöntemlerini uygulayın. Ciddi durumlarda mutlaka bir uzmana danışın.',
            Icons.healing,
          ),
          _buildGuideSection(
            '5. Geçmişinizi Takip Edin',
            'Profil > Teşhis Geçmişim bölümünden eski teşhislerinizi görüntüleyebilirsiniz.',
            Icons.history,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Color(0xFF00C853)),
                    SizedBox(width: 8),
                    Text(
                      'İpuçları',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00C853),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  '• Fotoğrafı iyi ışıkta çekin\n• Hastalıklı bölgeye odaklanın\n• Bulanık fotoğraflardan kaçının\n• Birden fazla açıdan fotoğraf çekin',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideSection(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF00C853)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
