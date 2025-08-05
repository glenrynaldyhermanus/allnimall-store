import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../objects/service_booking.dart';
import '../objects/booking_slot.dart';
import 'booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<ServiceBooking>> getServiceBookings({
    String? storeId,
    String? customerId,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      var query = _client
          .from('service_bookings')
          .select('*');

      if (storeId != null) {
        query = query.eq('store_id', storeId);
      }

      if (customerId != null) {
        query = query.eq('customer_id', customerId);
      }

      if (status != null) {
        query = query.eq('status', status);
      }

      if (fromDate != null) {
        query = query.gte('booking_date', fromDate.toIso8601String().split('T')[0]);
      }

      if (toDate != null) {
        query = query.lte('booking_date', toDate.toIso8601String().split('T')[0]);
      }

      final response = await query.order('created_at', ascending: false);
      return (response as List)
          .map((json) => ServiceBooking.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting service bookings: $e');
      return [];
    }
  }

  @override
  Future<ServiceBooking?> getServiceBookingById(String bookingId) async {
    try {
      final response = await _client
          .from('service_bookings')
          .select('*')
          .eq('id', bookingId)
          .single();

      return ServiceBooking.fromJson(response);
    } catch (e) {
      debugPrint('Error getting service booking by id: $e');
      return null;
    }
  }

  @override
  Future<ServiceBooking> createServiceBooking(Map<String, dynamic> bookingData) async {
    try {
      // Generate booking reference if not provided
      if (bookingData['booking_reference'] == null) {
        bookingData['booking_reference'] = await generateBookingReference();
      }

      final response = await _client
          .from('service_bookings')
          .insert(bookingData)
          .select()
          .single();

      return ServiceBooking.fromJson(response);
    } catch (e) {
      debugPrint('Error creating service booking: $e');
      rethrow;
    }
  }

  @override
  Future<ServiceBooking> updateServiceBooking(String bookingId, Map<String, dynamic> bookingData) async {
    try {
      bookingData['updated_at'] = DateTime.now().toIso8601String();

      final response = await _client
          .from('service_bookings')
          .update(bookingData)
          .eq('id', bookingId)
          .select()
          .single();

      return ServiceBooking.fromJson(response);
    } catch (e) {
      debugPrint('Error updating service booking: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteServiceBooking(String bookingId) async {
    try {
      await _client
          .from('service_bookings')
          .delete()
          .eq('id', bookingId);
    } catch (e) {
      debugPrint('Error deleting service booking: $e');
      rethrow;
    }
  }

  @override
  Future<List<BookingSlot>> getAvailableSlots({
    required String storeId,
    required String serviceProductId,
    required DateTime date,
  }) async {
    try {
      final response = await _client
          .rpc('get_available_slots', params: {
            'p_store_id': storeId,
            'p_service_product_id': serviceProductId,
            'p_booking_date': date.toIso8601String().split('T')[0],
          });

      return (response as List)
          .map((json) => BookingSlot.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting available slots: $e');
      return [];
    }
  }

  @override
  Future<BookingSlot?> getBookingSlotById(String slotId) async {
    try {
      final response = await _client
          .from('booking_slots')
          .select('*')
          .eq('id', slotId)
          .single();

      return BookingSlot.fromJson(response);
    } catch (e) {
      debugPrint('Error getting booking slot by id: $e');
      return null;
    }
  }

  @override
  Future<BookingSlot> createBookingSlot(Map<String, dynamic> slotData) async {
    try {
      final response = await _client
          .from('booking_slots')
          .insert(slotData)
          .select()
          .single();

      return BookingSlot.fromJson(response);
    } catch (e) {
      debugPrint('Error creating booking slot: $e');
      rethrow;
    }
  }

  @override
  Future<BookingSlot> updateBookingSlot(String slotId, Map<String, dynamic> slotData) async {
    try {
      slotData['updated_at'] = DateTime.now().toIso8601String();

      final response = await _client
          .from('booking_slots')
          .update(slotData)
          .eq('id', slotId)
          .select()
          .single();

      return BookingSlot.fromJson(response);
    } catch (e) {
      debugPrint('Error updating booking slot: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteBookingSlot(String slotId) async {
    try {
      await _client
          .from('booking_slots')
          .delete()
          .eq('id', slotId);
    } catch (e) {
      debugPrint('Error deleting booking slot: $e');
      rethrow;
    }
  }

  @override
  Future<bool> checkSlotAvailability({
    required String storeId,
    required String serviceProductId,
    required DateTime date,
    required String time,
  }) async {
    try {
      final response = await _client
          .rpc('check_slot_availability', params: {
            'p_store_id': storeId,
            'p_service_product_id': serviceProductId,
            'p_booking_date': date.toIso8601String().split('T')[0],
            'p_booking_time': time,
            'p_duration_minutes': 120, // Default duration
          });

      return response as bool;
    } catch (e) {
      debugPrint('Error checking slot availability: $e');
      return false;
    }
  }

  @override
  Future<void> updateSlotCapacity({
    required String storeId,
    required String serviceProductId,
    required DateTime date,
    required String time,
    required bool increment,
  }) async {
    try {
      await _client
          .rpc('update_slot_capacity', params: {
            'p_store_id': storeId,
            'p_service_product_id': serviceProductId,
            'p_booking_date': date.toIso8601String().split('T')[0],
            'p_booking_time': time,
            'p_increment': increment,
          });
    } catch (e) {
      debugPrint('Error updating slot capacity: $e');
      rethrow;
    }
  }

  @override
  Future<String> generateBookingReference() async {
    try {
      final response = await _client
          .rpc('generate_booking_reference');

      return response as String;
    } catch (e) {
      debugPrint('Error generating booking reference: $e');
      // Fallback to manual generation
      final now = DateTime.now();
      final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
      final timeStr = '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
      return 'BK-$dateStr-$timeStr';
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailableSlotsRaw({
    required String storeId,
    required String serviceProductId,
    required DateTime date,
  }) async {
    try {
      final response = await _client
          .rpc('get_available_slots', params: {
            'p_store_id': storeId,
            'p_service_product_id': serviceProductId,
            'p_booking_date': date.toIso8601String().split('T')[0],
          });

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error getting available slots raw: $e');
      return [];
    }
  }
} 