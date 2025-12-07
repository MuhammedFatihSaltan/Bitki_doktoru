import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/plant_model.dart';

class PlantService {
  final _supabase = Supabase.instance.client;
  
  // Cloudinary credentials
  static const String cloudinaryCloudName = 'ds3qhhh21';
  static const String cloudinaryUploadPreset = 'plant_app_uploads';

  // Cloudinary'ye resim yükle
  Future<String> uploadImageToCloudinary(String imagePath) async {
    try {
      print('🔄 Cloudinary\'ye yükleniyor...');
      print('📁 Dosya: $imagePath');
      print('☁️ Cloud Name: $cloudinaryCloudName');
      print('🔑 Preset: $cloudinaryUploadPreset');

      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = cloudinaryUploadPreset;
      request.fields['folder'] = 'user_plants';
      
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonResponse = json.decode(responseString);

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response: $responseString');

      if (response.statusCode == 200) {
        print('✅ Resim başarıyla yüklendi!');
        return jsonResponse['secure_url'] as String;
      } else {
        final errorMsg = jsonResponse['error']?['message'] ?? 'Bilinmeyen hata';
        print('❌ Hata: $errorMsg');
        throw Exception('Resim yüklenemedi: $errorMsg');
      }
    } catch (e) {
      print('❌ Exception: $e');
      throw Exception('Resim yükleme hatası: $e');
    }
  }

  // Yeni bitki ekle
  Future<PlantModel> addPlant({
    required String userId,
    required String name,
    String? type,
    required String imagePath,
    required DateTime addedDate,
    String? notes,
  }) async {
    try {
      // 1. Resmi Cloudinary'ye yükle
      final imageUrl = await uploadImageToCloudinary(imagePath);

      // 2. Supabase'e kaydet
      final data = {
        'user_id': userId,
        'name': name,
        'type': type,
        'image_url': imageUrl,
        'added_date': addedDate.toIso8601String().split('T')[0],
        'notes': notes,
        'health_status': 'healthy',
      };

      final response = await _supabase
          .from('user_plants')
          .insert(data)
          .select()
          .single();

      return PlantModel.fromJson(response);
    } catch (e) {
      throw Exception('Bitki eklenirken hata oluştu: $e');
    }
  }

  // Kullanıcının bitkilerini getir
  Future<List<PlantModel>> getUserPlants(String userId) async {
    try {
      final response = await _supabase
          .from('user_plants')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => PlantModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Bitkiler yüklenirken hata oluştu: $e');
    }
  }

  // Bitki güncelle
  Future<PlantModel> updatePlant({
    required String plantId,
    String? name,
    String? type,
    String? notes,
    String? healthStatus,
    DateTime? lastWatered,
    DateTime? lastFertilized,
  }) async {
    try {
      final data = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) data['name'] = name;
      if (type != null) data['type'] = type;
      if (notes != null) data['notes'] = notes;
      if (healthStatus != null) data['health_status'] = healthStatus;
      if (lastWatered != null) {
        data['last_watered'] = lastWatered.toIso8601String().split('T')[0];
      }
      if (lastFertilized != null) {
        data['last_fertilized'] = lastFertilized.toIso8601String().split('T')[0];
      }

      final response = await _supabase
          .from('user_plants')
          .update(data)
          .eq('id', plantId)
          .select()
          .single();

      return PlantModel.fromJson(response);
    } catch (e) {
      throw Exception('Bitki güncellenirken hata oluştu: $e');
    }
  }

  // Bitki sil
  Future<void> deletePlant(String plantId) async {
    try {
      await _supabase.from('user_plants').delete().eq('id', plantId);
    } catch (e) {
      throw Exception('Bitki silinirken hata oluştu: $e');
    }
  }

  // Sulama işlemi
  Future<PlantModel> waterPlant(String plantId) async {
    return updatePlant(
      plantId: plantId,
      lastWatered: DateTime.now(),
      healthStatus: 'healthy',
    );
  }

  // Gübreleme işlemi
  Future<PlantModel> fertilizePlant(String plantId) async {
    return updatePlant(
      plantId: plantId,
      lastFertilized: DateTime.now(),
    );
  }

  // Stream ile gerçek zamanlı dinleme
  Stream<List<PlantModel>> getUserPlantsStream(String userId) {
    return _supabase
        .from('user_plants')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => PlantModel.fromJson(json)).toList());
  }
}
