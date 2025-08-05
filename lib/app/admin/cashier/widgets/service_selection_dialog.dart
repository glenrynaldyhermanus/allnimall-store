import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'time_slot_selection_dialog.dart';

class ServiceSelectionDialog extends ConsumerStatefulWidget {
  final Product product;
  final Function(Map<String, dynamic>) onServiceSelected;

  const ServiceSelectionDialog({
    super.key,
    required this.product,
    required this.onServiceSelected,
  });

  @override
  ConsumerState<ServiceSelectionDialog> createState() => _ServiceSelectionDialogState();
}

class _ServiceSelectionDialogState extends ConsumerState<ServiceSelectionDialog> {
  DateTime? selectedDate;
  String? selectedTime;
  String? selectedStaffId;
  String? selectedStaffName;
  String customerNotes = '';


  @override
  void initState() {
    super.initState();
    debugPrint('🛒 [ServiceSelectionDialog] initState called for product: ${widget.product.name}');
    
    try {
      // Get the repository from the provider
      
      // Set default date to today
      selectedDate = DateTime.now();
      debugPrint('🛒 [ServiceSelectionDialog] Default date set: $selectedDate');
    } catch (e) {
      debugPrint('❌ [ServiceSelectionDialog] Error in initState: $e');
    }
  }

  void _onDateChanged(DateTime? date) {
    setState(() {
      selectedDate = date;
      selectedTime = null;
      selectedStaffId = null;
      selectedStaffName = null;
    });
  }

  void _onTimeSlotSelected(String time, String staffId, String staffName) {
    setState(() {
      selectedTime = time;
      selectedStaffId = staffId;
      selectedStaffName = staffName;
    });
  }

  void _showTimeSlotDialog() {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih tanggal terlebih dahulu')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => TimeSlotSelectionDialog(
        product: widget.product,
        selectedDate: selectedDate!,
        onTimeSlotSelected: _onTimeSlotSelected,
      ),
    );
  }

  void _onConfirm() {
    if (selectedDate == null || selectedTime == null || selectedStaffId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data booking')),
      );
      return;
    }

    final bookingData = {
      'productId': widget.product.id,
      'bookingDate': selectedDate,
      'bookingTime': selectedTime,
      'durationMinutes': widget.product.durationMinutes ?? 120,
      'assignedStaffId': selectedStaffId,
      'assignedStaffName': selectedStaffName,
      'customerNotes': customerNotes,
    };

    widget.onServiceSelected(bookingData);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Booking ${widget.product.name}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Service Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Durasi: ${widget.product.formattedDuration}'),
                  Text('Harga: ${widget.product.formattedPrice}'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Date Selection
            Text(
              'Pilih Tanggal',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                _onDateChanged(date);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'Pilih tanggal',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Time Slot Selection Button
            Text(
              'Pilih Waktu dan Staff',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _showTimeSlotDialog,
              icon: const Icon(Icons.schedule),
              label: Text(selectedTime != null && selectedStaffName != null
                  ? '$selectedTime - $selectedStaffName'
                  : 'Pilih Waktu dan Staff'),
            ),
            const SizedBox(height: 16),

            // Customer Notes
            Text(
              'Catatan (Opsional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) => customerNotes = value,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Masukkan catatan untuk booking ini...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedDate != null && 
                              selectedTime != null && 
                              selectedStaffId != null
                        ? _onConfirm
                        : null,
                    child: const Text('Tambah ke Cart'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 