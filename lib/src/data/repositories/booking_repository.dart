import '../objects/service_booking.dart';
import '../objects/booking_slot.dart';

abstract class BookingRepository {
  // Service Bookings
  Future<List<ServiceBooking>> getServiceBookings({
    String? storeId,
    String? customerId,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  });

  Future<ServiceBooking?> getServiceBookingById(String bookingId);

  Future<ServiceBooking> createServiceBooking(Map<String, dynamic> bookingData);

  Future<ServiceBooking> updateServiceBooking(String bookingId, Map<String, dynamic> bookingData);

  Future<void> deleteServiceBooking(String bookingId);

  // Booking Slots
  Future<List<BookingSlot>> getAvailableSlots({
    required String storeId,
    required String serviceProductId,
    required DateTime date,
  });

  Future<BookingSlot?> getBookingSlotById(String slotId);

  Future<BookingSlot> createBookingSlot(Map<String, dynamic> slotData);

  Future<BookingSlot> updateBookingSlot(String slotId, Map<String, dynamic> slotData);

  Future<void> deleteBookingSlot(String slotId);

  // Availability Management
  Future<bool> checkSlotAvailability({
    required String storeId,
    required String serviceProductId,
    required DateTime date,
    required String time,
  });

  Future<void> updateSlotCapacity({
    required String storeId,
    required String serviceProductId,
    required DateTime date,
    required String time,
    required bool increment,
  });

  // Helper Functions
  Future<String> generateBookingReference();

  Future<List<Map<String, dynamic>>> getAvailableSlotsRaw({
    required String storeId,
    required String serviceProductId,
    required DateTime date,
  });
} 