import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/objects/service_booking.dart';
import '../data/objects/booking_slot.dart';
import '../data/repositories/booking_repository.dart';
import '../data/repositories/booking_repository_impl.dart';
import '../data/usecases/get_service_bookings_usecase.dart';
import '../data/usecases/create_service_booking_usecase.dart';
import '../data/usecases/get_available_slots_usecase.dart';
import '../data/usecases/update_booking_status_usecase.dart';

// Repository Provider
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepositoryImpl();
});

// Usecase Providers
final getServiceBookingsUseCaseProvider =
    Provider<GetServiceBookingsUseCase>((ref) {
  final repository = ref.watch(bookingRepositoryProvider);
  return GetServiceBookingsUseCase(repository);
});

final createServiceBookingUseCaseProvider =
    Provider<CreateServiceBookingUseCase>((ref) {
  final repository = ref.watch(bookingRepositoryProvider);
  return CreateServiceBookingUseCase(repository);
});

final getAvailableSlotsUseCaseProvider =
    Provider<GetAvailableSlotsUseCase>((ref) {
  final repository = ref.watch(bookingRepositoryProvider);
  return GetAvailableSlotsUseCase(repository);
});

final updateBookingStatusUseCaseProvider =
    Provider<UpdateBookingStatusUseCase>((ref) {
  final repository = ref.watch(bookingRepositoryProvider);
  return UpdateBookingStatusUseCase(repository);
});

// State Providers
final serviceBookingsProvider =
    FutureProvider.family<List<ServiceBooking>, Map<String, dynamic>>(
        (ref, params) async {
  final useCase = ref.watch(getServiceBookingsUseCaseProvider);
  return await useCase.execute(
    storeId: params['storeId'],
    customerId: params['customerId'],
    status: params['status'],
    fromDate: params['fromDate'],
    toDate: params['toDate'],
  );
});

final availableSlotsProvider =
    FutureProvider.family<List<BookingSlot>, Map<String, dynamic>>(
        (ref, params) async {
  final useCase = ref.watch(getAvailableSlotsUseCaseProvider);
  return await useCase.execute(
    storeId: params['storeId'],
    serviceProductId: params['serviceProductId'],
    date: params['date'],
  );
});

// Notifier for booking management
class BookingNotifier extends StateNotifier<AsyncValue<List<ServiceBooking>>> {
  final GetServiceBookingsUseCase _getBookingsUseCase;
  final CreateServiceBookingUseCase _createBookingUseCase;
  final UpdateBookingStatusUseCase _updateStatusUseCase;

  BookingNotifier({
    required GetServiceBookingsUseCase getBookingsUseCase,
    required CreateServiceBookingUseCase createBookingUseCase,
    required UpdateBookingStatusUseCase updateStatusUseCase,
  })  : _getBookingsUseCase = getBookingsUseCase,
        _createBookingUseCase = createBookingUseCase,
        _updateStatusUseCase = updateStatusUseCase,
        super(const AsyncValue.loading());

  Future<void> loadBookings({
    String? storeId,
    String? customerId,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    state = const AsyncValue.loading();
    try {
      final bookings = await _getBookingsUseCase.execute(
        storeId: storeId,
        customerId: customerId,
        status: status,
        fromDate: fromDate,
        toDate: toDate,
      );
      state = AsyncValue.data(bookings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createBooking({
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
    try {
      final newBooking = await _createBookingUseCase.execute(
        bookingSource: bookingSource,
        customerId: customerId,
        petId: petId,
        customerName: customerName,
        customerPhone: customerPhone,
        customerEmail: customerEmail,
        storeId: storeId,
        serviceProductId: serviceProductId,
        serviceName: serviceName,
        bookingDate: bookingDate,
        bookingTime: bookingTime,
        durationMinutes: durationMinutes,
        serviceType: serviceType,
        customerAddress: customerAddress,
        latitude: latitude,
        longitude: longitude,
        serviceFee: serviceFee,
        onSiteFee: onSiteFee,
        discountAmount: discountAmount,
        customerNotes: customerNotes,
        allnimallCommission: allnimallCommission,
        partnershipId: partnershipId,
      );

      // Add new booking to current state
      final currentBookings = state.value ?? [];
      state = AsyncValue.data([newBooking, ...currentBookings]);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
    String? assignedStaffId,
    String? staffNotes,
  }) async {
    try {
      final updatedBooking = await _updateStatusUseCase.execute(
        bookingId: bookingId,
        status: status,
        assignedStaffId: assignedStaffId,
        staffNotes: staffNotes,
      );

      // Update booking in current state
      final currentBookings = state.value ?? [];
      final updatedBookings = currentBookings.map((booking) {
        if (booking.id == bookingId) {
          return updatedBooking;
        }
        return booking;
      }).toList();

      state = AsyncValue.data(updatedBookings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final bookingNotifierProvider =
    StateNotifierProvider<BookingNotifier, AsyncValue<List<ServiceBooking>>>(
        (ref) {
  return BookingNotifier(
    getBookingsUseCase: ref.watch(getServiceBookingsUseCaseProvider),
    createBookingUseCase: ref.watch(createServiceBookingUseCaseProvider),
    updateStatusUseCase: ref.watch(updateBookingStatusUseCaseProvider),
  );
});
