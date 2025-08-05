import 'package:allnimall_store/src/data/repositories/pos_repository.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';

class ServiceSelectionUseCase {
  final PosRepository _posRepository;

  ServiceSelectionUseCase(this._posRepository);

  // Get calendar slots with staff availability (Calendar-Style Booking)
  Future<List<Map<String, dynamic>>> getCalendarSlotsWithStaff({
    required String serviceProductId,
    required DateTime bookingDate,
    int startHour = 8,
    int endHour = 17,
  }) async {
    final storeId = await SupabaseService.getStoreId();
    if (storeId == null) return [];

    return await _posRepository.getCalendarSlotsWithStaff(
      storeId: storeId,
      serviceProductId: serviceProductId,
      bookingDate: bookingDate,
      startHour: startHour,
      endHour: endHour,
    );
  }

  // Check if staff is available for a specific time range
  Future<bool> isStaffAvailableForRange({
    required String serviceProductId,
    required DateTime bookingDate,
    required String staffId,
    required String startTime,
    required int durationMinutes,
  }) async {
    final storeId = await SupabaseService.getStoreId();
    if (storeId == null) return false;

    return await _posRepository.isStaffAvailableForRange(
      storeId: storeId,
      serviceProductId: serviceProductId,
      bookingDate: bookingDate,
      staffId: staffId,
      startTime: startTime,
      durationMinutes: durationMinutes,
    );
  }

  // Get available staff for a specific date and time (Legacy - for backward compatibility)
  Future<List<Map<String, dynamic>>> getAvailableStaff({
    required DateTime date,
    required String time,
  }) async {
    final storeId = await SupabaseService.getStoreId();
    if (storeId == null) return [];

    return await _posRepository.getAvailableStaff(
      storeId: storeId,
      date: date,
      time: time,
    );
  }

  // Validate service booking with calendar-style approach
  Future<Map<String, dynamic>> validateServiceBooking({
    required String serviceProductId,
    required DateTime bookingDate,
    required String startTime,
    required String assignedStaffId,
    required int durationMinutes,
  }) async {
    final results = <String, dynamic>{};

    // Check if staff is available for the time range
    final isStaffAvailable = await isStaffAvailableForRange(
      serviceProductId: serviceProductId,
      bookingDate: bookingDate,
      staffId: assignedStaffId,
      startTime: startTime,
      durationMinutes: durationMinutes,
    );
    results['staffAvailable'] = isStaffAvailable;

    // Overall validation
    results['isValid'] = isStaffAvailable;

    return results;
  }
}
