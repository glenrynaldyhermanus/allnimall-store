import 'package:flutter/foundation.dart';

class Category {
  final String id;
  final String name;
  final String? pictureUrl;
  final String storeId;
  final String? petCategoryId;
  final String? parentCategoryId;
  final String type; // 'item' atau 'service'
  final DateTime createdAt;
  final DateTime? updatedAt;

  Category({
    required this.id,
    required this.name,
    this.pictureUrl,
    required this.storeId,
    this.petCategoryId,
    this.parentCategoryId,
    this.type = 'item',
    required this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      pictureUrl: json['picture_url'],
      storeId: json['store_id'] ?? '',
      petCategoryId: json['pet_category_id'],
      parentCategoryId: json['parent_category_id'],
      type: json['type'] ?? 'item',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'picture_url': pictureUrl,
      'store_id': storeId,
      'pet_category_id': petCategoryId,
      'parent_category_id': parentCategoryId,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Helper methods for type distinction
  bool get isItem => type == 'item';
  bool get isService => type == 'service';
  
  String get displayType {
    switch (type) {
      case 'service':
        return 'Jasa';
      case 'item':
      default:
        return 'Produk';
    }
  }
} 