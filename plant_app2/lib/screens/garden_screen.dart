import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'plant_detail_screen.dart';
import 'add_plant_photo_screen.dart';
import '../services/plant_service.dart';
import '../models/plant_model.dart';

class GardenScreen extends StatefulWidget {
  const GardenScreen({super.key});

  @override
  State<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {
  String _selectedFilter = 'Tümü';
  final _plantService = PlantService();

  List<PlantModel> _filterPlants(List<PlantModel> plants) {
    if (_selectedFilter == 'Tümü') {
      return plants;
    } else if (_selectedFilter == 'Sağlıklı') {
      return plants.where((p) => p.healthStatus == 'healthy').toList();
    } else {
      return plants.where((p) => p.healthStatus != 'healthy').toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Lütfen giriş yapın')));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPlantPhotoScreen(),
              ),
            );
          },
          backgroundColor: const Color(0xFF00C853),
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
      body: StreamBuilder<List<PlantModel>>(
        stream: _plantService.getUserPlantsStream(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF00C853)),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          final plants = snapshot.data ?? [];
          final filteredPlants = _filterPlants(plants);

          if (filteredPlants.isEmpty) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 60, 20, 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Bahçem',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildFilterChip('Tümü'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Sağlıklı'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Bakım Gerekli'),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.spa_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedFilter == 'Tümü'
                              ? 'Henüz bitki eklemediniz'
                              : 'Bu filtrede bitki bulunamadı',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 60, 20, 16),
                      child: Text(
                        'Bahçem',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          _buildFilterChip('Tümü'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Sağlıklı'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Bakım Gerekli'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _buildPlantCard(filteredPlants[index]);
                }, childCount: filteredPlants.length),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00C853) : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  Future<void> _deletePlant(PlantModel plant) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bitkiyi Sil'),
        content: Text(
          '${plant.name} bitkisini silmek istediğinize emin misiniz?',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _plantService.deletePlant(plant.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bitki başarıyla silindi'),
              backgroundColor: Color(0xFF00C853),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Widget _buildPlantCard(PlantModel plant) {
    return Dismissible(
      key: Key(plant.id),
      direction: DismissDirection.endToStart,
      movementDuration: const Duration(milliseconds: 200),
      confirmDismiss: (direction) async {
        await _deletePlant(plant);
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantDetailScreen(
                name: plant.name,
                type: plant.type ?? 'Bilinmeyen',
                image: plant.imageUrl,
                addedDate:
                    '${plant.addedDate.day}.${plant.addedDate.month}.${plant.addedDate.year}',
                healthStatus: plant.getStatusText(),
                wateringDate: plant.lastWatered != null
                    ? '${plant.lastWatered!.day}.${plant.lastWatered!.month}.${plant.lastWatered!.year}'
                    : 'Henüz sulanmadı',
                fertilizingDate: plant.lastFertilized != null
                    ? '${plant.lastFertilized!.day}.${plant.lastFertilized!.month}.${plant.lastFertilized!.year}'
                    : 'Henüz gübrelenmedi',
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F8F0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              // Bitki resmi
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    plant.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.local_florist,
                        size: 40,
                        color: Colors.black26,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Bitki bilgileri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      plant.getStatusText(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: plant.getStatusColor(),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plant.getUpdateTime(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
              // Ok ikonu
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
