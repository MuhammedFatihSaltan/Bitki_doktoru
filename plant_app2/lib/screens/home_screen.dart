import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:firebase_auth/firebase_auth.dart';
import 'camera_screen.dart';
import 'diseases_screen.dart';
import 'profile_screen.dart';
import 'garden_screen.dart';
import 'article_detail_screen.dart';
import 'ai_assistant_screen.dart';
import '../services/firestore_service.dart';
import '../services/supabase_service.dart';
import '../services/plant_service.dart';
import '../models/plant_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isNavBarVisible = true;
  ScrollController? _scrollController;

  final List<Widget> _screens = [
    const MainHomeScreen(), // 0: Ana Sayfa
    const DiseasesScreen(), // 1: Hastalıklar
    const GardenScreen(), // 2: Bahçem
    const ProfileScreen(), // 3: Profil
  ];

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = this.context;
      if (mounted) {
        try {
          _scrollController = PrimaryScrollController.of(context);
          _scrollController?.addListener(_onScroll);
        } catch (e) {
          // Scroll controller bulunamadı
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController == null) return;

    if (_scrollController!.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isNavBarVisible) {
        setState(() => _isNavBarVisible = false);
      }
    } else if (_scrollController!.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isNavBarVisible) {
        setState(() => _isNavBarVisible = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _isNavBarVisible ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _isNavBarVisible ? 1.0 : 0.0,
          child: Container(
            margin: const EdgeInsets.all(16),
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.home_outlined, Icons.home, 0),
                    _buildNavItem(Icons.grid_view_outlined, Icons.grid_view, 1),
                    _buildCameraButton(),
                    _buildNavItem(Icons.spa_outlined, Icons.spa, 2),
                    _buildNavItem(Icons.person_outline, Icons.person, 3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CameraScreen()),
        );
      },
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF00C853),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00C853).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 26),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData activeIcon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? const Color(0xFF00C853) : Colors.grey,
              size: 28,
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFF00C853),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final _firestoreService = FirestoreService();
  final _supabaseService = SupabaseService();
  final _plantService = PlantService();
  String _userName = 'Kullanıcı';
  List<Map<String, dynamic>> articles = [];
  List<PlantModel> userPlants = [];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadArticles();
    _loadUserPlants();
  }

  Future<void> _loadUserPlants() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final plants = await _plantService.getUserPlants(user.uid);
        if (mounted) {
          setState(() {
            userPlants = plants.take(3).toList(); // İlk 3 bitki
          });
        }
      } catch (e) {
        print('❌ Bitkiler yüklenirken hata: $e');
      }
    }
  }

  Future<void> _loadArticles() async {
    final allArticles = await _supabaseService.getArticles(limit: 10);
    if (mounted) {
      // Günlük seed ile rastgele 2 makale seç
      final today = DateTime.now();
      final seed = today.year * 10000 + today.month * 100 + today.day;
      allArticles.shuffle(Random(seed));

      setState(() {
        articles = allArticles.take(2).toList();
      });
    }
  }

  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    print('👤 Current User: ${user?.uid}');
    if (user != null) {
      try {
        final userProfile = await _firestoreService.getUserProfile(user.uid);
        print('📝 User Profile: ${userProfile?.fullName}');
        if (mounted && userProfile != null) {
          setState(() {
            _userName = userProfile.fullName;
          });
        }
      } catch (e) {
        print('❌ Hata: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00C853),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Merhaba, $_userName!',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Hava Durumu ve Sulama Kartları
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.wb_sunny,
                            color: Color(0xFFFFA726),
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '24°C',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Parçalı Bulutlu',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Bahçem sayfasına git (index 2)
                        final homeState = context
                            .findAncestorStateOfType<_HomeScreenState>();
                        homeState?.setState(() {
                          homeState._selectedIndex = 2;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.water_drop,
                              color: Color(0xFF42A5F5),
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Sulama',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Zamanı',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CameraScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.camera_alt, size: 24),
                label: const Text(
                  'Hızlı Teşhis',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 65),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Yapay Zeka Asistanı',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sorularınızı anında yanıtlayın.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AIAssistantScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5F5F5),
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Sohbete Başla',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          'https://res.cloudinary.com/ds3qhhh21/image/upload/v1764893778/robot_icon_deneme_gtgcx5.avif',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.smart_toy_outlined,
                              size: 60,
                              color: Color(0xFF00C853),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Bahçem Bölümü
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bahçem',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Bahçem sayfasına git (index 2)
                      final homeState = context
                          .findAncestorStateOfType<_HomeScreenState>();
                      homeState?.setState(() {
                        homeState._selectedIndex = 2;
                      });
                    },
                    child: const Text(
                      'Tümünü Gör',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF00C853),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              userPlants.isEmpty
                  ? Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.spa_outlined,
                            size: 60,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Henüz bitki eklemediniz',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        itemCount: userPlants.length,
                        itemBuilder: (context, index) {
                          final plant = userPlants[index];
                          return _buildGardenPlantCard(
                            plant.name,
                            plant.getStatusText(),
                            plant.getStatusColor(),
                            plant.imageUrl,
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Son Teşhisleriniz',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Tümünü Gör',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF00C853),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDiagnosisItem('Domates - Yaprak Küfü', '2 gün önce', ''),
              const SizedBox(height: 12),
              _buildDiagnosisItem('Gül - Kara Leke', '5 gün önce', ''),
              const SizedBox(height: 24),
              const Text(
                'Faydalı Bilgiler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ...articles.map((article) {
                String displayCategory = article['category'] ?? 'Genel';
                if (displayCategory == 'Bitki İçeriği') {
                  displayCategory = 'Bakım İpuçları';
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildInfoCard(
                    displayCategory,
                    article['title'] ?? '',
                    _getIconData(article['icon'] ?? 'eco'),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailScreen(
                            title: article['title'] ?? '',
                            category: displayCategory,
                            content: article['content'] ?? '',
                            icon: article['icon'] ?? 'eco',
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              if (articles.isEmpty)
                _buildInfoCard(
                  'Bitki Bakımı',
                  'Makaleler yükleniyor...',
                  Icons.eco,
                  () {},
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'lightbulb_outline':
        return Icons.lightbulb_outline;
      case 'content_cut':
        return Icons.content_cut;
      case 'compost':
        return Icons.recycling;
      case 'bug_report':
        return Icons.bug_report;
      case 'home':
        return Icons.home_outlined;
      case 'medical_services':
        return Icons.medical_services;
      case 'water_drop':
        return Icons.water_drop;
      case 'park':
        return Icons.park;
      case 'verified':
        return Icons.verified;
      default:
        return Icons.eco;
    }
  }

  Widget _buildGardenPlantCard(
    String name,
    String status,
    Color statusColor,
    String imageUrl,
  ) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.local_florist,
                    size: 40,
                    color: Colors.black26,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String category,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF00C853), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF00C853),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildDiagnosisItem(String title, String date, String imageUrl) {
  return Container(
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
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.local_florist,
                        size: 30,
                        color: Colors.black26,
                      );
                    },
                  ),
                )
              : const Icon(
                  Icons.local_florist,
                  size: 30,
                  color: Colors.black26,
                ),
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
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF00C853),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
      ],
    ),
  );
}
