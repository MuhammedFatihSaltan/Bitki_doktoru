class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    required this.createdAt,
    this.updatedAt,
  });

  // Firestore'dan veri çek
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      avatarUrl: map['avatarUrl'],
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  // Firestore'a veri gönder
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
