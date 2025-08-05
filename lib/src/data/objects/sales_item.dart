import 'package:allnimall_store/src/core/utils/number_formatter.dart';

enum SalesItemType {
  product('product'),
  service('service');

  const SalesItemType(this.value);
  final String value;

  static SalesItemType? fromString(String? value) {
    if (value == null) return null;
    return SalesItemType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => SalesItemType.product,
    );
  }
}

class SalesItem {
  final String id;
  final String saleId;
  final String productId;
  final String productName;
  final SalesItemType itemType;
  final int quantity;
  final double unitPrice;
  final double totalAmount;
  final double discountAmount;
  final double taxAmount;
  final DateTime createdAt;

  // Service-specific fields
  final DateTime? bookingDate;
  final String? bookingTime;
  final int? durationMinutes;
  final String? assignedStaffId;
  final String? assignedStaffName;
  final String? customerNotes;
  final String? bookingReference;

  SalesItem({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.productName,
    this.itemType = SalesItemType.product,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    this.discountAmount = 0,
    this.taxAmount = 0,
    required this.createdAt,
    this.bookingDate,
    this.bookingTime,
    this.durationMinutes,
    this.assignedStaffId,
    this.assignedStaffName,
    this.customerNotes,
    this.bookingReference,
  });

  factory SalesItem.fromJson(Map<String, dynamic> json) {
    return SalesItem(
      id: json['id'] ?? '',
      saleId: json['sale_id'] ?? '',
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      itemType:
          SalesItemType.fromString(json['item_type']) ?? SalesItemType.product,
      quantity: json['quantity'] ?? 1,
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      taxAmount: (json['tax_amount'] ?? 0).toDouble(),
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      // Service-specific fields
      bookingDate: json['booking_date'] != null
          ? DateTime.parse(json['booking_date'])
          : null,
      bookingTime: json['booking_time'],
      durationMinutes: json['duration_minutes'],
      assignedStaffId: json['assigned_staff_id'],
      assignedStaffName: json['assigned_staff_name'],
      customerNotes: json['customer_notes'],
      bookingReference: json['booking_reference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sale_id': saleId,
      'product_id': productId,
      'product_name': productName,
      'item_type': itemType.value,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_amount': totalAmount,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'created_at': createdAt.toIso8601String(),
      // Service-specific fields
      'booking_date': bookingDate?.toIso8601String().split('T')[0],
      'booking_time': bookingTime,
      'duration_minutes': durationMinutes,
      'assigned_staff_id': assignedStaffId,
      'assigned_staff_name': assignedStaffName,
      'customer_notes': customerNotes,
      'booking_reference': bookingReference,
    };
  }

  // Helper methods
  bool get isService => itemType == SalesItemType.service;
  bool get isProduct => itemType == SalesItemType.product;

  String get formattedUnitPrice => NumberFormatter.formatTotalPrice(unitPrice);
  String get formattedTotalAmount =>
      NumberFormatter.formatTotalPrice(totalAmount);
  String get formattedQuantity => NumberFormatter.formatQuantity(quantity);

  String get bookingInfo {
    if (!isService) return '';

    final date = bookingDate != null
        ? '${bookingDate!.day}/${bookingDate!.month}/${bookingDate!.year}'
        : '';
    final time = bookingTime ?? '';
    final staff = assignedStaffName ?? '';

    return '$date $time${staff.isNotEmpty ? ' - $staff' : ''}';
  }

  String get serviceDuration {
    if (!isService || durationMinutes == null) return '';
    return '${durationMinutes} menit';
  }
}
