import 'dart:ui';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Hoş Geldiniz',
      description:
          'Bitkileri tarayın, sorunları tespit edin\nve anında bakım ipuçları alın.',
      image:
          'https://res.cloudinary.com/ds3qhhh21/image/upload/v1764860024/onboarding1_altarnatif_km02cf.jpg',
      backgroundColor: const Color(0xFFE8EDE8),
    ),
    OnboardingData(
      title: 'Her Şey Hazır!',
      description:
          'Uygulamayı kullanmaya başlamak için kaydolun veya giriş yapın.',
      image:
          'https://res.cloudinary.com/ds3qhhh21/image/upload/v1764889316/ac%C4%B1k_reng_onboarding_taslak3_xttffp.jpg',
      backgroundColor: const Color(0xFFE8EDE8),
    ),
    OnboardingData(
      title: 'Anında Hastalık Teşhisi',
      description:
          'Bitkinizin fotoğrafını çekin, yapay zeka destekli sistemimiz sağlıklar içinde hastalığı tanımlasın.',
      image:
          'https://res.cloudinary.com/ds3qhhh21/image/upload/v1764888888/onboarding_taslak2_vstbnj.avif',
      backgroundColor: const Color(0xFFE8EDE8),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan - PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),
          // Alt kısım - Butonlar (resmin üzerinde)
          Positioned(
            left: 24,
            right: 24,
            bottom: 60,
            child: Column(
              children: [
                // Devam Et butonu (transparan ve blurlu)
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            if (_currentPage < _pages.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              'Devam Et',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Indicator noktaları
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildDot(index),
                  ),
                ),
                const SizedBox(height: 20),
                // Kullanım şartları metni
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Devam ederek ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                        height: 1.4,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Kullanım Şartları sayfası
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Kullanım Şartları'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Text(
                        'Kullanım Şartları',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          height: 1.4,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      ' ve ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                        height: 1.4,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Gizlilik Politikası sayfası
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('\nGizlilik Politikası'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Text(
                        'Gizlilik Politikası',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          height: 1.4,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '\'nı kabul etmiş olursunuz',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Stack(
      children: [
        // Arka plan resmi
        Positioned.fill(child: Image.network(data.image, fit: BoxFit.cover)),
        // Hafif transparan overlay
        Positioned.fill(
          child: Container(color: Colors.black.withValues(alpha: 0.25)),
        ),
        // Yazılar altta
        Positioned(
          bottom: 240,
          left: 32,
          right: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                data.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Colors.white
            : Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String image;
  final Color backgroundColor;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
    required this.backgroundColor,
  });
}
