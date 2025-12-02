import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcı profili oluştur
  Future<void> createUserProfile({
    required String uid,
    required String email,
    required String fullName,
  }) async {
    try {
      print('🔥 Firestore: Profil oluşturuluyor... UID: $uid');
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'fullName': fullName,
        'avatarUrl': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('✅ Firestore: Profil başarıyla oluşturuldu!');
    } catch (e) {
      print('❌ Firestore Hatası: $e');
      throw 'Profil oluşturulamadı: $e';
    }
  }

  // Kullanıcı profilini getir
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    } catch (e) {
      throw 'Profil getirilemedi: $e';
    }
  }

  // Kullanıcı profilini güncelle
  Future<void> updateUserProfile({
    required String uid,
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      Map<String, dynamic> updates = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (fullName != null) updates['fullName'] = fullName;
      if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;

      await _firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      throw 'Profil güncellenemedi: $e';
    }
  }

  // Kullanıcı profilini sil
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      throw 'Profil silinemedi: $e';
    }
  }
}
