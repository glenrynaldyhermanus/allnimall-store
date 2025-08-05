import '../objects/service_booking.dart';
import '../repositories/booking_repository.dart';

class UpdateBookingStatusUseCase {
  final BookingRepository _bookingRepository;

  UpdateBookingStatusUseCase(this._bookingRepository);

  Future<ServiceBooking> execute({
    required String bookingId,
    required String status,
    String? assignedStaffId,
    String? staffNotes,
  }) async {
    final updateData = {
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (assignedStaffId != null) {
      updateData['assigned_staff_id'] = assignedStaffId;
    }

    if (staffNotes != null) {
      updateData['staff_notes'] = staffNotes;
    }

    return await _bookingRepository.updateServiceBooking(bookingId, updateData);
  }
} 