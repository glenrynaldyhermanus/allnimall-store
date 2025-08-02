import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String name;
  final String? code;
  final String? barcode;
  final double purchasePrice;
  final double price; // selling price
  final int stock;
  final int minStock;
  final int? maxStock;
  final String? unit;
  final int weightGrams;
  final int discountType;
  final double discountValue;
  final String? description;
  final String? ingredients;
  final String? usageInstructions;
  final String? ageRecommendation;
  final String? petSizeRecommendation;
  final String? imageUrl;
  final bool isActive;
  final bool isPrescriptionRequired;
  final int? shelfLifeDays;
  final String? storageInstructions;
  final String? categoryId;
  final String storeId;
  final DateTime? expiredDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? categoryName;

  Product({
    required this.id,
    required this.name,
    this.code,
    this.barcode,
    required this.purchasePrice,
    required this.price,
    required this.stock,
    required this.minStock,
    this.maxStock,
    this.unit,
    required this.weightGrams,
    required this.discountType,
    required this.discountValue,
    this.description,
    this.ingredients,
    this.usageInstructions,
    this.ageRecommendation,
    this.petSizeRecommendation,
    this.imageUrl,
    required this.isActive,
    this.isPrescriptionRequired = false,
    this.shelfLifeDays,
    this.storageInstructions,
    this.categoryId,
    required this.storeId,
    this.expiredDate,
    required this.createdAt,
    this.updatedAt,
    this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    debugPrint('🔍 Debug - Product.fromJson called with: $json');

    try {
      // Handle categories which might be null or have different structure
      String? categoryName;
      if (json['categories'] != null) {
        if (json['categories'] is Map<String, dynamic>) {
          categoryName = json['categories']['name'];
        } else if (json['categories'] is String) {
          categoryName = json['categories'];
        }
      }

      debugPrint('🔍 Debug - Category name extracted: $categoryName');

      return Product(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        code: json['code'],
        barcode: json['barcode'],
        purchasePrice: (json['purchase_price'] ?? 0).toDouble(),
        price: (json['price'] ?? 0).toDouble(),
        stock: json['stock'] ?? 0,
        minStock: json['min_stock'] ?? 0,
        maxStock: json['max_stock'],
        unit: json['unit'] ?? 'pcs',
        weightGrams: json['weight_grams'] ?? 0,
        discountType: json['discount_type'] ?? 1,
        discountValue: (json['discount_value'] ?? 0).toDouble(),
        description: json['description'],
        ingredients: json['ingredients'],
        usageInstructions: json['usage_instructions'],
        ageRecommendation: json['age_recommendation'],
        petSizeRecommendation: json['pet_size_recommendation'],
        imageUrl: json['picture_url'],
        isActive: json['is_active'] ?? true,
        isPrescriptionRequired: json['is_prescription_required'] ?? false,
        shelfLifeDays: json['shelf_life_days'],
        storageInstructions: json['storage_instructions'],
        categoryId: json['category_id'],
        storeId: json['store_id'] ?? '',
        expiredDate: json['expired_date'] != null
            ? DateTime.parse(json['expired_date'])
            : null,
        createdAt: DateTime.parse(
            json['created_at'] ?? DateTime.now().toIso8601String()),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
        categoryName: categoryName,
      );
    } catch (e) {
      debugPrint('❌ Debug - Error in Product.fromJson: $e');
      debugPrint('🔍 Debug - Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'barcode': barcode,
      'purchase_price': purchasePrice,
      'price': price,
      'stock': stock,
      'min_stock': minStock,
      'max_stock': maxStock,
      'unit': unit,
      'weight_grams': weightGrams,
      'discount_type': discountType,
      'discount_value': discountValue,
      'description': description,
      'ingredients': ingredients,
      'usage_instructions': usageInstructions,
      'age_recommendation': ageRecommendation,
      'pet_size_recommendation': petSizeRecommendation,
      'picture_url': imageUrl,
      'is_active': isActive,
      'is_prescription_required': isPrescriptionRequired,
      'shelf_life_days': shelfLifeDays,
      'storage_instructions': storageInstructions,
      'category_id': categoryId,
      'store_id': storeId,
      'expired_date': expiredDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'category_name': categoryName,
    };
  }
}
