import 'package:flutter/material.dart';

class PlantModel {
  final String id;
  final String userId;
  final String name;
  final String? type;
  final String imageUrl;
  final DateTime addedDate;
  final String? notes;
  final String? wateringSchedule;
  final String? fertilizingSchedule;
  final String healthStatus;
  final DateTime? lastWatered;
  final DateTime? lastFertilized;
  final DateTime createdAt;
  final DateTime updatedAt;

  PlantModel({
    required this.id,
    required this.userId,
    required this.name,
    this.type,
    required this.imageUrl,
    required this.addedDate,
    this.notes,
    this.wateringSchedule,
    this.fertilizingSchedule,
    this.healthStatus = 'healthy',
    this.lastWatered,
    this.lastFertilized,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String?,
      imageUrl: json['image_url'] as String,
      addedDate: DateTime.parse(json['added_date'] as String),
      notes: json['notes'] as String?,
      wateringSchedule: json['watering_schedule'] as String?,
      fertilizingSchedule: json['fertilizing_schedule'] as String?,
      healthStatus: json['health_status'] as String? ?? 'healthy',
      lastWatered: json['last_watered'] != null
          ? DateTime.parse(json['last_watered'] as String)
          : null,
      lastFertilized: json['last_fertilized'] != null
          ? DateTime.parse(json['last_fertilized'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'type': type,
      'image_url': imageUrl,
      'added_date': addedDate.toIso8601String().split('T')[0],
      'notes': notes,
      'watering_schedule': wateringSchedule,
      'fertilizing_schedule': fertilizingSchedule,
      'health_status': healthStatus,
      'last_watered': lastWatered?.toIso8601String().split('T')[0],
      'last_fertilized': lastFertilized?.toIso8601String().split('T')[0],
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String getStatusText() {
    if (healthStatus == 'disease') return 'Hastalıklı';
    if (healthStatus == 'water') return 'Sulama Gerekli';
    if (healthStatus == 'fertilize') return 'Gübreleme Gerekli';
    return 'Sağlıklı';
  }

  Color getStatusColor() {
    if (healthStatus == 'disease') return const Color(0xFFE53935);
    if (healthStatus == 'water') return const Color(0xFFFFA726);
    if (healthStatus == 'fertilize') return const Color(0xFFFFA726);
    return const Color(0xFF00C853);
  }

  String getUpdateTime() {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Güncellendi: ${difference.inMinutes} dakika önce';
      }
      return 'Güncellendi: ${difference.inHours} saat önce';
    } else if (difference.inDays == 1) {
      return 'Güncellendi: dün';
    } else {
      return 'Güncellendi: ${difference.inDays} gün önce';
    }
  }
}
