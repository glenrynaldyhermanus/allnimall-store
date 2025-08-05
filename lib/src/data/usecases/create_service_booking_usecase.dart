import '../objects/service_booking.dart';
import '../repositories/booking_repository.dart';

class CreateServiceBookingUseCase {
  final BookingRepository _bookingRepository;

  CreateServiceBookingUseCase(this._bookingRepository);

  Future<ServiceBooking> execute({
    required String bookingSource,
    required String customerId,
    String? petId,
    required String customerName,
    required String customerPhone,
    String? customerEmail,
    required String storeId,
    required String serviceProductId,
    required String serviceName,
    required DateTime bookingDate,
    required String bookingTime,
    required int durationMinutes,
    required String serviceType,
    String? customerAddress,
    double? latitude,
    double? longitude,
    required double serviceFee,
    double onSiteFee = 0,
    double discountAmount = 0,
    String? customerNotes,
    double allnimallCommission = 0,
    String? partnershipId,
  }) async {
    final bookingData = {
      'booking_source': bookingSource,
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
      'service_type': serviceType,
      'customer_address': customerAddress,
      'latitude': latitude,
      'longitude': longitude,
      'status': 'pending',
      'payment_status': 'pending',
      'service_fee': serviceFee,
      'on_site_fee': onSiteFee,
      'discount_amount': discountAmount,
      'total_amount': serviceFee + onSiteFee - discountAmount,
      'customer_notes': customerNotes,
      'allnimall_commission': allnimallCommission,
      'partnership_id': partnershipId,
    };

    return await _bookingRepository.createServiceBooking(bookingData);
  }
} 