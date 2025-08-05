import 'package:flutter/foundation.dart';

class BookingSlot {
  final String id;
  final String storeId;
  final String serviceProductId;
  final DateTime slotDate;
  final String slotTime;
  final int slotDurationMinutes;
  final int maxCapacity;
  final int currentBookings;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BookingSlot({
    required this.id,
    required this.storeId,
    required this.serviceProductId,
    required this.slotDate,
    required this.slotTime,
    required this.slotDurationMinutes,
    required this.maxCapacity,
    required this.currentBookings,
    required this.isAvailable,
    required this.createdAt,
    this.updatedAt,
  });

  factory BookingSlot.fromJson(Map<String, dynamic> json) {
    return BookingSlot(
      id: json['id'] ?? '',
      storeId: json['store_id'] ?? '',
      serviceProductId: json['service_product_id'] ?? '',
      slotDate: json['slot_date'] != null 
          ? DateTime.parse(json['slot_date'])
          : DateTime.now(),
      slotTime: json['slot_time'] ?? '',
      slotDurationMinutes: json['slot_duration_minutes'] ?? 0,
      maxCapacity: json['max_capacity'] ?? 1,
      currentBookings: json['current_bookings'] ?? 0,
      isAvailable: json['is_available'] ?? true,
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
      'store_id': storeId,
      'service_product_id': serviceProductId,
      'slot_date': slotDate.toIso8601String().split('T')[0],
      'slot_time': slotTime,
      'slot_duration_minutes': slotDurationMinutes,
      'max_capacity': maxCapacity,
      'current_bookings': currentBookings,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Helper methods
  bool get isFullyBooked => currentBookings >= maxCapacity;
  bool get hasAvailableSlots => currentBookings < maxCapacity;
  int get availableSlots => maxCapacity - currentBookings;

  String get formattedTime {
    // Convert time string to readable format
    // Assuming slotTime is in format "HH:MM"
    return slotTime;
  }

  String get formattedDuration {
    final hours = slotDurationMinutes ~/ 60;
    final minutes = slotDurationMinutes % 60;
    if (hours > 0) {
      return '${hours}j ${minutes}m';
    }
    return '${minutes}m';
  }

  String get availabilityStatus {
    if (!isAvailable) return 'Tidak Tersedia';
    if (isFullyBooked) return 'Penuh';
    return 'Tersedia';
  }

  bool get canBook => isAvailable && hasAvailableSlots;
} 