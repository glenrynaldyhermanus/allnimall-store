import 'package:flutter/foundation.dart';

enum BookingSource {
  merchantOnlineStore('merchant_online_store'),
  allnimallApp('allnimall_app'),
  offlineStore('offline_store');

  const BookingSource(this.value);
  final String value;

  static BookingSource? fromString(String? value) {
    if (value == null) return null;
    return BookingSource.values.firstWhere(
      (source) => source.value == value,
      orElse: () => BookingSource.merchantOnlineStore,
    );
  }
}

enum BookingStatus {
  pending('pending'),
  confirmed('confirmed'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled'),
  noShow('no_show');

  const BookingStatus(this.value);
  final String value;

  static BookingStatus? fromString(String? value) {
    if (value == null) return null;
    return BookingStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => BookingStatus.pending,
    );
  }

  String get statusLabel {
    switch (this) {
      case BookingStatus.pending:
        return 'Menunggu Konfirmasi';
      case BookingStatus.confirmed:
        return 'Dikonfirmasi';
      case BookingStatus.inProgress:
        return 'Sedang Berlangsung';
      case BookingStatus.completed:
        return 'Selesai';
      case BookingStatus.cancelled:
        return 'Dibatalkan';
      case BookingStatus.noShow:
        return 'Tidak Hadir';
    }
  }
}

enum PaymentStatus {
  pending('pending'),
  paid('paid'),
  refunded('refunded');

  const PaymentStatus(this.value);
  final String value;

  static PaymentStatus? fromString(String? value) {
    if (value == null) return null;
    return PaymentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => PaymentStatus.pending,
    );
  }
}

enum ServiceType {
  inStore('in_store'),
  onSite('on_site');

  const ServiceType(this.value);
  final String value;

  static ServiceType? fromString(String? value) {
    if (value == null) return null;
    return ServiceType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ServiceType.inStore,
    );
  }
}

class ServiceBooking {
  final String id;
  final BookingSource bookingSource;
  final String bookingReference;
  final String customerId;
  final String? petId;
  final String customerName;
  final String customerPhone;
  final String? customerEmail;
  final String storeId;
  final String serviceProductId;
  final String serviceName;
  final DateTime bookingDate;
  final String bookingTime;
  final int durationMinutes;
  final ServiceType serviceType;
  final String? customerAddress;
  final double? latitude;
  final double? longitude;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final double serviceFee;
  final double onSiteFee;
  final double discountAmount;
  final double totalAmount;
  final String? assignedStaffId;
  final String? staffNotes;
  final String? customerNotes;
  final double allnimallCommission;
  final String? partnershipId;
  final String? saleId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ServiceBooking({
    required this.id,
    required this.bookingSource,
    required this.bookingReference,
    required this.customerId,
    this.petId,
    required this.customerName,
    required this.customerPhone,
    this.customerEmail,
    required this.storeId,
    required this.serviceProductId,
    required this.serviceName,
    required this.bookingDate,
    required this.bookingTime,
    required this.durationMinutes,
    required this.serviceType,
    this.customerAddress,
    this.latitude,
    this.longitude,
    required this.status,
    required this.paymentStatus,
    required this.serviceFee,
    required this.onSiteFee,
    required this.discountAmount,
    required this.totalAmount,
    this.assignedStaffId,
    this.staffNotes,
    this.customerNotes,
    required this.allnimallCommission,
    this.partnershipId,
    this.saleId,
    required this.createdAt,
    this.updatedAt,
  });

  factory ServiceBooking.fromJson(Map<String, dynamic> json) {
    return ServiceBooking(
      id: json['id'] ?? '',
      bookingSource: BookingSource.fromString(json['booking_source']) ??
          BookingSource.merchantOnlineStore,
      bookingReference: json['booking_reference'] ?? '',
      customerId: json['customer_id'] ?? '',
      petId: json['pet_id'],
      customerName: json['customer_name'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      customerEmail: json['customer_email'],
      storeId: json['store_id'] ?? '',
      serviceProductId: json['service_product_id'] ?? '',
      serviceName: json['service_name'] ?? '',
      bookingDate: json['booking_date'] != null
          ? DateTime.parse(json['booking_date'])
          : DateTime.now(),
      bookingTime: json['booking_time'] ?? '',
      durationMinutes: json['duration_minutes'] ?? 0,
      serviceType:
          ServiceType.fromString(json['service_type']) ?? ServiceType.inStore,
      customerAddress: json['customer_address'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      status: BookingStatus.fromString(json['status']) ?? BookingStatus.pending,
      paymentStatus: PaymentStatus.fromString(json['payment_status']) ??
          PaymentStatus.pending,
      serviceFee: (json['service_fee'] ?? 0).toDouble(),
      onSiteFee: (json['on_site_fee'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      assignedStaffId: json['assigned_staff_id'],
      staffNotes: json['staff_notes'],
      customerNotes: json['customer_notes'],
      allnimallCommission: (json['allnimall_commission'] ?? 0).toDouble(),
      partnershipId: json['partnership_id'],
      saleId: json['sale_id'],
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
      'booking_source': bookingSource.value,
      'booking_reference': bookingReference,
      'customer_id': customerId,
      'pet_id': petId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_email': customerEmail,
      'store_id': storeId,
      'service_product_id': serviceProductId,
      'service_name': serviceName,
      'booking_date': bookingDate.toIso8601String().split('T')[0],
      'booking_time': bookingTime,
      'duration_minutes': durationMinutes,
      'service_type': serviceType.value,
      'customer_address': customerAddress,
      'latitude': latitude,
      'longitude': longitude,
      'status': status.value,
      'payment_status': paymentStatus.value,
      'service_fee': serviceFee,
      'on_site_fee': onSiteFee,
      'discount_amount': discountAmount,
      'total_amount': totalAmount,
      'assigned_staff_id': assignedStaffId,
      'staff_notes': staffNotes,
      'customer_notes': customerNotes,
      'allnimall_commission': allnimallCommission,
      'partnership_id': partnershipId,
      'sale_id': saleId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Helper methods
  bool get isPending => status == BookingStatus.pending;
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isInProgress => status == BookingStatus.inProgress;
  bool get isCompleted => status == BookingStatus.completed;
  bool get isCancelled => status == BookingStatus.cancelled;
  bool get isNoShow => status == BookingStatus.noShow;

  bool get isPaid => paymentStatus == PaymentStatus.paid;
  bool get isPendingPayment => paymentStatus == PaymentStatus.pending;
  bool get isRefunded => paymentStatus == PaymentStatus.refunded;

  bool get isOnSite => serviceType == ServiceType.onSite;
  bool get isInStore => serviceType == ServiceType.inStore;

  bool get hasPet => petId != null && petId!.isNotEmpty;

  String get statusLabel {
    switch (status) {
      case BookingStatus.pending:
        return 'Menunggu Konfirmasi';
      case BookingStatus.confirmed:
        return 'Dikonfirmasi';
      case BookingStatus.inProgress:
        return 'Sedang Berlangsung';
      case BookingStatus.completed:
        return 'Selesai';
      case BookingStatus.cancelled:
        return 'Dibatalkan';
      case BookingStatus.noShow:
        return 'Tidak Hadir';
    }
  }

  String get paymentStatusLabel {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return 'Menunggu Pembayaran';
      case PaymentStatus.paid:
        return 'Sudah Dibayar';
      case PaymentStatus.refunded:
        return 'Dikembalikan';
    }
  }

  String get bookingSourceLabel {
    switch (bookingSource) {
      case BookingSource.merchantOnlineStore:
        return 'Toko Online';
      case BookingSource.allnimallApp:
        return 'Aplikasi Allnimall';
      case BookingSource.offlineStore:
        return 'Toko Offline';
    }
  }

  String get serviceTypeLabel {
    switch (serviceType) {
      case ServiceType.inStore:
        return 'Di Toko';
      case ServiceType.onSite:
        return 'Panggilan';
    }
  }
}
