import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/providers/booking_provider.dart';
import 'package:allnimall_store/src/data/objects/service_booking.dart';
import 'package:allnimall_store/src/core/services/local_storage_service.dart';

class BookingsPage extends ConsumerStatefulWidget {
  const BookingsPage({super.key});

  @override
  ConsumerState<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends ConsumerState<BookingsPage> {
  String? selectedStatus;
  DateTime? selectedDate;
  String? storeId;

  @override
  void initState() {
    super.initState();
    _loadStoreId();
  }

  Future<void> _loadStoreId() async {
    final storeIdData = await LocalStorageService.getStoreId();
    setState(() {
      storeId = storeIdData;
    });

    if (storeId != null) {
      ref.read(bookingNotifierProvider.notifier).loadBookings(
            storeId: storeId,
            status: selectedStatus,
            fromDate: selectedDate,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Booking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to create booking page
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedStatus,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Semua Status'),
                      ),
                      ...BookingStatus.values.map((status) => DropdownMenuItem(
                            value: status.value,
                            child: Text(status.value),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                      _loadBookings();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                        _loadBookings();
                      }
                    },
                    child: Text(selectedDate != null
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : 'Pilih Tanggal'),
                  ),
                ),
              ],
            ),
          ),

          // Bookings List
          Expanded(
            child: bookingsAsync.when(
              data: (bookings) => bookings.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Belum ada booking',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return _BookingCard(
                          booking: booking,
                          onStatusUpdate: (status) {
                            ref
                                .read(bookingNotifierProvider.notifier)
                                .updateBookingStatus(
                                  bookingId: booking.id,
                                  status: status,
                                );
                          },
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: AlertDialog(
                  title: const Text('Error'),
                  content: Text('Gagal memuat data booking: $error'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _loadBookings() {
    if (storeId != null) {
      ref.read(bookingNotifierProvider.notifier).loadBookings(
            storeId: storeId,
            status: selectedStatus,
            fromDate: selectedDate,
          );
    }
  }
}

class _BookingCard extends StatelessWidget {
  final ServiceBooking booking;
  final Function(String) onStatusUpdate;

  const _BookingCard({
    required this.booking,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.serviceName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ref: ${booking.bookingReference}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusChip(status: booking.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(booking.customerName),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 16),
                const SizedBox(width: 8),
                Text(booking.customerPhone),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year} ${booking.bookingTime}',
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 8),
                Text(booking.serviceTypeLabel),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rp ${booking.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (booking.isPending)
                  ElevatedButton(
                    onPressed: () {
                      onStatusUpdate('confirmed');
                    },
                    child: const Text('Konfirmasi'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final BookingStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case BookingStatus.pending:
        color = Colors.orange;
        break;
      case BookingStatus.confirmed:
        color = Colors.blue;
        break;
      case BookingStatus.inProgress:
        color = Colors.purple;
        break;
      case BookingStatus.completed:
        color = Colors.green;
        break;
      case BookingStatus.cancelled:
        color = Colors.red;
        break;
      case BookingStatus.noShow:
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status.statusLabel,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
