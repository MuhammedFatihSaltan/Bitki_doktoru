import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _preloadImages();
    _navigateToOnboarding();
  }

  Future<void> _preloadImages() async {
    // Önbelleğe alınacak resimler
    final imagesToPreload = [
      'https://res.cloudinary.com/ds3qhhh21/image/upload/v1764856312/icon_dgxz4k.png',
      'https://res.cloudinary.com/ds3qhhh21/image/upload/v1764857446/kay%C4%B1t_ol_ekran_e3xuqh.avif',
      'https://res.cloudinary.com/ds3qhhh21/image/upload/v1764856397/kay%C4%B1t_ol_ekran2_r0wdpv.avif',
      'https://res.cloudinary.com/ds3qhhh21/image/upload/v1764859022/onboarding1_xvs7nj.avif',
    ];

    for (final imageUrl in imagesToPreload) {
      try {
        await precacheImage(NetworkImage(imageUrl), context);
      } catch (e) {
        // Hata olursa devam et
      }
    }
  }

  Future<void> _navigateToOnboarding() async {
    // Resimlerin yüklenmesini bekle
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan resmi
          Positioned.fill(
            child: Container(
              color: const Color(0xFF2D5F3F),
              child: Image.network(
                'https://res.cloudinary.com/ds3qhhh21/image/upload/v1764888312/Ekran_g%C3%B6r%C3%BCnt%C3%BCs%C3%BC_2025-12-04_204512_romwhi.png',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(color: const Color(0xFF2D5F3F));
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: const Color(0xFF2D5F3F));
                },
              ),
            ),
          ),
          // Koyu overlay
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),
          // İçerik
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(40),
                  child: Image.network(
                    'https://res.cloudinary.com/ds3qhhh21/image/upload/v1764856312/icon_dgxz4k.png',
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2D5F3F),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Bitki Doktoru',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bitkileriniz Emin Ellerde',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 60),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
