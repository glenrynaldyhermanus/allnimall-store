import '../objects/booking_slot.dart';
import '../repositories/booking_repository.dart';

class GetAvailableSlotsUseCase {
  final BookingRepository _bookingRepository;

  GetAvailableSlotsUseCase(this._bookingRepository);

  Future<List<BookingSlot>> execute({
    required String storeId,
    required String serviceProductId,
    required DateTime date,
  }) async {
    return await _bookingRepository.getAvailableSlots(
      storeId: storeId,
      serviceProductId: serviceProductId,
      date: date,
    );
  }
} 