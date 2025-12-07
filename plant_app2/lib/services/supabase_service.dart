import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final _supabase = Supabase.instance.client;

  // Hastalıkları getir
  Future<List<Map<String, dynamic>>> getDiseases({String? category}) async {
    try {
      var query = _supabase.from('diseases').select();

      if (category != null && category != 'Tümü') {
        query = query.eq('type', category);
      }

      final response = await query.order('name');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Hastalıkları getirirken hata: $e');
      return [];
    }
  }

  // Tek hastalık detayı getir
  Future<Map<String, dynamic>?> getDiseaseById(String id) async {
    try {
      final response = await _supabase
          .from('diseases')
          .select()
          .eq('id', id)
          .single();
      return response;
    } catch (e) {
      print('Hastalık detayı getirirken hata: $e');
      return null;
    }
  }

  // Hastalık ara
  Future<List<Map<String, dynamic>>> searchDiseases(String query) async {
    try {
      final response = await _supabase
          .from('diseases')
          .select()
          .ilike('name', '%$query%')
          .order('name');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Hastalık ararken hata: $e');
      return [];
    }
  }

  // Kullanıcının teşhislerini getir
  Future<List<Map<String, dynamic>>> getUserDiagnoses(String userId) async {
    try {
      final response = await _supabase
          .from('diagnoses')
          .select('*, diseases(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(10);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Teşhisleri getirirken hata: $e');
      return [];
    }
  }

  // Yeni teşhis ekle
  Future<bool> addDiagnosis({
    required String userId,
    required String diseaseId,
    required String imageUrl,
    double? confidence,
  }) async {
    try {
      await _supabase.from('diagnoses').insert({
        'user_id': userId,
        'disease_id': diseaseId,
        'image_url': imageUrl,
        'confidence': confidence ?? 0.0,
      });
      return true;
    } catch (e) {
      print('Teşhis eklerken hata: $e');
      return false;
    }
  }

  // Favorilere ekle
  Future<bool> addToFavorites(String userId, String diseaseId) async {
    try {
      await _supabase.from('favorites').insert({
        'user_id': userId,
        'disease_id': diseaseId,
      });
      return true;
    } catch (e) {
      print('Favorilere eklerken hata: $e');
      return false;
    }
  }

  // Favorilerden çıkar
  Future<bool> removeFromFavorites(String userId, String diseaseId) async {
    try {
      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('disease_id', diseaseId);
      return true;
    } catch (e) {
      print('Favorilerden çıkarırken hata: $e');
      return false;
    }
  }

  // Favori mi kontrol et
  Future<bool> isFavorite(String userId, String diseaseId) async {
    try {
      final response = await _supabase
          .from('favorites')
          .select()
          .eq('user_id', userId)
          .eq('disease_id', diseaseId)
          .maybeSingle();
      return response != null;
    } catch (e) {
      print('Favori kontrolü hatası: $e');
      return false;
    }
  }

  // Kullanıcının favorilerini getir
  Future<List<Map<String, dynamic>>> getUserFavorites(String userId) async {
    try {
      final response = await _supabase
          .from('favorites')
          .select('*, diseases(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Favorileri getirirken hata: $e');
      return [];
    }
  }

  // Resim yükle (Storage)
  Future<String?> uploadImage(String filePath, String fileName) async {
    try {
      await _supabase.storage
          .from('plant-images')
          .upload('diagnoses/$fileName', File(filePath));

      final url = _supabase.storage
          .from('plant-images')
          .getPublicUrl('diagnoses/$fileName');

      return url;
    } catch (e) {
      print('Resim yüklerken hata: $e');
      return null;
    }
  }

  // Makaleleri getir
  Future<List<Map<String, dynamic>>> getArticles({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('articles')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Makaleleri getirirken hata: $e');
      return [];
    }
  }

  // Kategoriye göre makaleleri getir
  Future<List<Map<String, dynamic>>> getArticlesByCategory(
      String category) async {
    try {
      final response = await _supabase
          .from('articles')
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Makaleleri getirirken hata: $e');
      return [];
    }
  }
}
