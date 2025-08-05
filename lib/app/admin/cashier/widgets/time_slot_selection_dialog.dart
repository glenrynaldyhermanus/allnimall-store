import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/data/usecases/service_selection_usecase.dart';
import 'package:allnimall_store/src/providers/cashier_provider.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';

class TimeSlotSelectionDialog extends ConsumerStatefulWidget {
  final Product product;
  final DateTime selectedDate;
  final Function(String time, String staffId, String staffName)
      onTimeSlotSelected;

  const TimeSlotSelectionDialog({
    super.key,
    required this.product,
    required this.selectedDate,
    required this.onTimeSlotSelected,
  });

  @override
  ConsumerState<TimeSlotSelectionDialog> createState() =>
      _TimeSlotSelectionDialogState();
}

class _TimeSlotSelectionDialogState
    extends ConsumerState<TimeSlotSelectionDialog> {
  bool isLoading = false;
  List<Map<String, dynamic>> availableSlots = [];
  String? selectedTime;
  String? selectedStaffId;
  String? selectedStaffName;

  late ServiceSelectionUseCase _serviceSelectionUseCase;

  @override
  void initState() {
    super.initState();
    debugPrint(
        '🛒 [TimeSlotSelectionDialog] initState called for product: ${widget.product.name}');

    try {
      final repository = ref.read(posRepositoryProvider);
      _serviceSelectionUseCase = ServiceSelectionUseCase(repository);
      debugPrint(
          '🛒 [TimeSlotSelectionDialog] ServiceSelectionUseCase initialized');
      _loadCalendarSlotsWithStaff();
    } catch (e) {
      debugPrint('❌ [TimeSlotSelectionDialog] Error in initState: $e');
    }
  }

  Future<void> _loadCalendarSlotsWithStaff() async {
    debugPrint(
        '🛒 [TimeSlotSelectionDialog] _loadCalendarSlotsWithStaff called');

    setState(() {
      isLoading = true;
    });

    try {
      debugPrint(
          '🛒 [TimeSlotSelectionDialog] Calling getCalendarSlotsWithStaff...');
      final calendarData =
          await _serviceSelectionUseCase.getCalendarSlotsWithStaff(
        serviceProductId: widget.product.id,
        bookingDate: widget.selectedDate,
      );

      debugPrint(
          '🛒 [TimeSlotSelectionDialog] Calendar data: ${calendarData.length} items');

      if (calendarData.isEmpty) {
        debugPrint(
            '🛒 [TimeSlotSelectionDialog] No calendar data from database, using fallback data');
        _loadFallbackCalendarData();
      } else {
        // Process calendar data to create matrix
        _processCalendarData(calendarData);
      }
    } catch (e) {
      debugPrint('❌ [TimeSlotSelectionDialog] Error loading calendar data: $e');
      _loadFallbackCalendarData();
    }
  }

  void _processCalendarData(List<Map<String, dynamic>> calendarData) {
    // Group by time slot
    final Map<String, List<Map<String, dynamic>>> timeSlots = {};

    for (final item in calendarData) {
      final time = item['slot_time'] as String;
      if (!timeSlots.containsKey(time)) {
        timeSlots[time] = [];
      }
      timeSlots[time]!.add(item);
    }

    // Convert to list format for UI
    final processedSlots = <Map<String, dynamic>>[];
    for (final entry in timeSlots.entries) {
      final time = entry.key;
      final staffList = entry.value;

      processedSlots.add({
        'time': time,
        'staff': staffList,
        'has_available_staff':
            staffList.any((staff) => staff['is_available'] == true),
      });
    }

    setState(() {
      availableSlots = processedSlots;
      isLoading = false;
    });
  }

  void _loadFallbackCalendarData() {
    debugPrint('🛒 [TimeSlotSelectionDialog] Loading fallback calendar data');

    final fallbackSlots = <Map<String, dynamic>>[];
    final mockStaff = [
      {
        'staff_id': 'staff-001',
        'staff_name': 'Glen Rynaldy Hermanus',
        'staff_phone': '+6281234567890',
        'avatar': 'GR'
      },
      {
        'staff_id': 'staff-002',
        'staff_name': 'Sarah Groomer',
        'staff_phone': '+6281234567891',
        'avatar': 'SG'
      },
      {
        'staff_id': 'staff-003',
        'staff_name': 'Budi Pet Care',
        'staff_phone': '+6281234567892',
        'avatar': 'BP'
      },
    ];

    for (int hour = 8; hour <= 17; hour++) {
      final time = '${hour.toString().padLeft(2, '0')}:00';
      final staffList = mockStaff.map((staff) {
        bool isAvailable = true; // Set to true for testing
        return {...staff, 'is_available': isAvailable};
      }).toList();

      fallbackSlots.add({
        'time': time,
        'staff': staffList,
        'has_available_staff': true,
      });
    }

    setState(() {
      availableSlots = fallbackSlots;
      isLoading = false;
    });
  }

  void _onTimeSlotSelected(String time, String staffId, String staffName) {
    setState(() {
      selectedTime = time;
      selectedStaffId = staffId;
      selectedStaffName = staffName;
    });
  }

  void _confirmSelection() {
    if (selectedTime == null || selectedStaffId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih waktu dan staff')),
      );
      return;
    }

    widget.onTimeSlotSelected(
        selectedTime!, selectedStaffId!, selectedStaffName!);
    Navigator.of(context).pop();
  }

  // Get all available time slots
  List<String> _getTimeSlots() {
    return availableSlots.map((slot) => slot['time'] as String).toList()
      ..sort();
  }

  // Get all unique staff members from calendar data
  List<Map<String, dynamic>> _getUniqueStaff() {
    final uniqueStaff = <String, Map<String, dynamic>>{};

    for (final slot in availableSlots) {
      final staffList = slot['staff'] as List<Map<String, dynamic>>?;
      if (staffList != null) {
        for (final staff in staffList) {
          final staffId = staff['staff_id'] as String?;
          if (staffId != null && !uniqueStaff.containsKey(staffId)) {
            uniqueStaff[staffId] = staff;
          }
        }
      }
    }

    return uniqueStaff.values.toList();
  }

  // Check if staff is available at specific time
  bool _isStaffAvailableAtTime(String staffId, String time) {
    for (final slot in availableSlots) {
      if (slot['time'] == time) {
        final staffList = slot['staff'] as List<Map<String, dynamic>>?;
        if (staffList != null) {
          for (final staff in staffList) {
            if (staff['staff_id'] == staffId && staff['is_available'] == true) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final timeSlots = _getTimeSlots();
    final staffList = _getUniqueStaff();

    return Dialog(
      child: Container(
        width: 1000,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Colors.blue[600],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Waktu dan Staff',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                        ),
                      ),
                      Text(
                        '${widget.product.name} - ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Service Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Harga: ${widget.product.formattedPrice}'),
                        Text('Durasi: ${widget.product.formattedDuration}'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Tipe: ${widget.product.displayType}'),
                        if (widget.product.serviceCategory != null)
                          Text(
                              'Kategori: ${widget.product.serviceCategoryLabel}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Time Slot Table
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Slot Waktu Tersedia',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Table Header
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'Waktu',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                              ...staffList.map((staff) => Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.blue[100],
                                            child: Text(
                                              _getInitials(staff['staff_name']
                                                      as String? ??
                                                  ''),
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.blue[700],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            staff['staff_name'] as String? ??
                                                'Unknown',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),

                        // Table Body
                        Expanded(
                          child: ListView.builder(
                            itemCount: timeSlots.length,
                            itemBuilder: (context, index) {
                              final time = timeSlots[index];

                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Text(
                                          time,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ),
                                    ...staffList.map((staff) {
                                      final staffId =
                                          staff['staff_id'] as String?;
                                      final staffName =
                                          staff['staff_name'] as String?;
                                      final isAvailable =
                                          _isStaffAvailableAtTime(
                                              staffId ?? '', time);
                                      final isSelected = selectedTime == time &&
                                          selectedStaffId == staffId;

                                      return Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          child: InkWell(
                                            onTap: isAvailable &&
                                                    staffId != null &&
                                                    staffName != null
                                                ? () => _onTimeSlotSelected(
                                                    time, staffId, staffName)
                                                : null,
                                            child: Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? Colors.blue[600]
                                                    : isAvailable
                                                        ? Colors.green[100]
                                                        : Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: isSelected
                                                      ? Colors.blue[600]!
                                                      : isAvailable
                                                          ? Colors.green[300]!
                                                          : Colors.grey[300]!,
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  isSelected
                                                      ? Icons.check
                                                      : isAvailable
                                                          ? Icons.schedule
                                                          : Icons.block,
                                                  size: 24,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : isAvailable
                                                          ? Colors.green[700]
                                                          : Colors.grey[500],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),

            // Action Buttons
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AllnimallButton.ghost(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AllnimallButton.primary(
                    onPressed: (selectedTime != null && selectedStaffId != null)
                        ? _confirmSelection
                        : null,
                    child: const Text('Pilih Slot'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
