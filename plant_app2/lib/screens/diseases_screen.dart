import 'dart:ui';
import 'package:flutter/material.dart';
import 'disease_detail_screen.dart';
import '../services/supabase_service.dart';

class DiseasesScreen extends StatefulWidget {
  const DiseasesScreen({super.key});

  @override
  State<DiseasesScreen> createState() => _DiseasesScreenState();
}

class _DiseasesScreenState extends State<DiseasesScreen> {
  final _supabaseService = SupabaseService();
  final _searchController = TextEditingController();
  final List<String> categories = [
    'Tümü',
    'Meyve',
    'Sebze',
    'Mantar',
    'Bakteri',
  ];
  int selectedCategory = 0;
  List<Map<String, dynamic>> diseases = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadDiseases();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDiseases() async {
    setState(() => isLoading = true);

    List<Map<String, dynamic>> data;

    if (searchQuery.isNotEmpty) {
      data = await _supabaseService.searchDiseases(searchQuery);
    } else {
      final category = selectedCategory == 0
          ? null
          : categories[selectedCategory];
      data = await _supabaseService.getDiseases(category: category);
    }

    setState(() {
      diseases = data;
      isLoading = false;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    _loadDiseases();
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Tümü':
        return Icons.grid_view;
      case 'Mantar':
        return Icons.eco;
      case 'Bakteri':
        return Icons.bug_report;
      default:
        return Icons.local_florist;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Resim ve arama kutusu kısmı
                Stack(
                  children: [
                    // Arka plan resmi - daha küçük
                    Container(
                      height: 260,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://res.cloudinary.com/ds3qhhh21/image/upload/v1764890242/bitki_hastal%C4%B1k_ekran_taslak_ljmyiu.avif',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      height: 260,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                    ),
                    // İçerik
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Bitki Hastalık Kataloğu',
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 50),
                          // Arama kutusu - transparan ve blurlu
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: _onSearchChanged,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Hastalık veya bitki adı ara...',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontSize: 15,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      size: 22,
                                    ),
                                    suffixIcon: searchQuery.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              _searchController.clear();
                                              _onSearchChanged('');
                                            },
                                          )
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Kategori filtreleri - beyaz arka planda
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: List.generate(categories.length, (index) {
                        final isSelected = selectedCategory == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = index;
                              });
                              _loadDiseases();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF2D5F3F)
                                    : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getCategoryIcon(categories[index]),
                                    size: 16,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF2D5F3F),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    categories[index],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF2D5F3F),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: CircularProgressIndicator(color: Color(0xFF00C853)),
                ),
              ),
            )
          else if (diseases.isEmpty)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Text(
                    'Hastalık bulunamadı',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final disease = diseases[index];
                  return _buildDiseaseCard(
                    disease['id'] ?? '',
                    disease['name'] ?? '',
                    disease['category'] ?? '',
                    disease['image_url'] ?? '',
                  );
                }, childCount: diseases.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard(
    String id,
    String title,
    String category,
    String imageUrl,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiseaseDetailScreen(
              diseaseId: id,
              diseaseName: title,
              category: category,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.local_florist,
                              size: 60,
                              color: Colors.black26,
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.local_florist,
                        size: 60,
                        color: Colors.black26,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    category,
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
