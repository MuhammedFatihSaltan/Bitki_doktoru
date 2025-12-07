import 'package:flutter/material.dart';
import 'faq_screen.dart';
import 'user_guide_screen.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
          'Yardım & Destek',
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
          _buildHelpItem(
            context,
            'Sıkça Sorulan Sorular',
            Icons.help_outline,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FAQScreen(),
                ),
              );
            },
          ),
          _buildHelpItem(
            context,
            'Kullanım Kılavuzu',
            Icons.menu_book_outlined,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserGuideScreen(),
                ),
              );
            },
          ),
          _buildHelpItem(
            context,
            'Bize Ulaşın',
            Icons.email_outlined,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('İletişim: bitkidoktoru@example.com'),
                  backgroundColor: Color(0xFF00C853),
                ),
              );
            },
          ),
          _buildHelpItem(
            context,
            'Geri Bildirim Gönder',
            Icons.feedback_outlined,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Geri bildirim formu yakında eklenecek!'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF00C853)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.black38,
        ),
        onTap: onTap,
      ),
    );
  }
}
