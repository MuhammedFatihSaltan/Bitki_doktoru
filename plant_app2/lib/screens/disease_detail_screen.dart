import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/supabase_service.dart';

class DiseaseDetailScreen extends StatefulWidget {
  final String diseaseId;
  final String diseaseName;
  final String category;
  final String imageUrl;

  const DiseaseDetailScreen({
    super.key,
    required this.diseaseId,
    required this.diseaseName,
    required this.category,
    required this.imageUrl,
  });

  @override
  State<DiseaseDetailScreen> createState() => _DiseaseDetailScreenState();
}

class _DiseaseDetailScreenState extends State<DiseaseDetailScreen> {
  final _supabaseService = SupabaseService();
  bool _isDescriptionExpanded = true;
  bool _isSymptomsExpanded = false;
  bool _isTreatmentExpanded = false;
  bool _isPreventionExpanded = false;
  bool _isFavorite = false;
  bool _isLoading = true;
  
  Map<String, dynamic>? diseaseData;

  @override
  void initState() {
    super.initState();
    _loadDiseaseDetails();
    _checkFavorite();
  }

  Future<void> _loadDiseaseDetails() async {
    final data = await _supabaseService.getDiseaseById(widget.diseaseId);
    setState(() {
      diseaseData = data;
      _isLoading = false;
    });
  }

  Future<void> _checkFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final isFav = await _supabaseService.isFavorite(user.uid, widget.diseaseId);
      setState(() => _isFavorite = isFav);
    }
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen giriş yapın')),
      );
      return;
    }

    if (_isFavorite) {
      await _supabaseService.removeFromFavorites(user.uid, widget.diseaseId);
    } else {
      await _supabaseService.addToFavorites(user.uid, widget.diseaseId);
    }
    
    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00C853)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Hastalık Detayları',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.bookmark : Icons.bookmark_outline,
              color: _isFavorite ? const Color(0xFF00C853) : Colors.black,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: widget.imageUrl.isNotEmpty
                  ? Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.local_florist,
                            size: 80,
                            color: Colors.black26,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(
                        Icons.local_florist,
                        size: 80,
                        color: Colors.black26,
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.diseaseName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildExpandableSection(
                    'Açıklama',
                    _isDescriptionExpanded,
                    () {
                      setState(() {
                        _isDescriptionExpanded = !_isDescriptionExpanded;
                      });
                    },
                    diseaseData?['description'] ?? 'Açıklama bulunamadı',
                  ),
                  const SizedBox(height: 12),
                  _buildExpandableSection(
                    'Belirtiler',
                    _isSymptomsExpanded,
                    () {
                      setState(() {
                        _isSymptomsExpanded = !_isSymptomsExpanded;
                      });
                    },
                    diseaseData?['symptoms'] ?? 'Belirtiler bulunamadı',
                  ),
                  const SizedBox(height: 12),
                  _buildExpandableSection(
                    'Tedavi Yöntemleri',
                    _isTreatmentExpanded,
                    () {
                      setState(() {
                        _isTreatmentExpanded = !_isTreatmentExpanded;
                      });
                    },
                    diseaseData?['treatment'] ?? 'Tedavi bilgisi bulunamadı',
                  ),
                  const SizedBox(height: 12),
                  _buildExpandableSection(
                    'Önleyici Tedbirler',
                    _isPreventionExpanded,
                    () {
                      setState(() {
                        _isPreventionExpanded = !_isPreventionExpanded;
                      });
                    },
                    diseaseData?['prevention'] ?? 'Önleyici tedbirler bulunamadı',
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Yapay Zeka Asistanına Sor',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Bitki bakımıyla ilgili anında yardım alın.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('AI Asistan yakında aktif olacak!'),
                                      backgroundColor: Color(0xFF00C853),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.arrow_forward, size: 16),
                                label: const Text(
                                  'Sohbeti Başlat',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00C853),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.smart_toy_outlined,
                            size: 60,
                            color: Color(0xFF00C853),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection(
    String title,
    bool isExpanded,
    VoidCallback onTap,
    String content,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00C853),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.6,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
