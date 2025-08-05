import '../objects/service_booking.dart';
import '../repositories/booking_repository.dart';

class GetServiceBookingsUseCase {
  final BookingRepository _bookingRepository;

  GetServiceBookingsUseCase(this._bookingRepository);

  Future<List<ServiceBooking>> execute({
    String? storeId,
    String? customerId,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return await _bookingRepository.getServiceBookings(
      storeId: storeId,
      customerId: customerId,
      status: status,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
} 