import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:allnimall_store/src/core/services/local_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global custom appbar widget for Allnimall application
///
/// This widget provides a consistent header across the application with:
/// - Business name and store name display
/// - User information with avatar
/// - Custom actions support
/// - Automatic data loading from local storage
/// - Real role data from database (e.g., "Owner", "Admin", "Cashier", "Vet", "Groomer")
///
/// Usage:
/// ```dart
/// // Basic usage - will show real role from database
/// const AllnimallAppBar()
///
/// // With custom title and subtitle
/// const AllnimallAppBar(
///   title: 'Custom Title',
///   subtitle: 'Custom Subtitle',
/// )
///
/// // With custom actions
/// const AllnimallAppBar(
///   actions: [
///     IconButton(
///       onPressed: () {},
///       icon: Icon(Icons.settings),
///     ),
///   ],
/// )
///
/// // Without user info
/// const AllnimallAppBar(
///   showUserInfo: false,
/// )
/// ```
///
/// **Role Data Priority:**
/// 1. Real role from database (stored in local storage)
/// 2. Fallback to "User"
class AllnimallAppBar extends ConsumerStatefulWidget {
  final String? title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showUserInfo;

  const AllnimallAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.actions,
    this.showUserInfo = true,
  });

  @override
  ConsumerState<AllnimallAppBar> createState() => _AllnimallAppBarState();
}

class _AllnimallAppBarState extends ConsumerState<AllnimallAppBar> {
  String storeName = 'Toko';
  String businessName = 'Allnimall Pet Shop';
  String userRole = 'User';
  String userName = 'User';
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (isLoaded) return;

    try {
      // Load data from local storage
      final businessData = await LocalStorageService.getBusinessData();
      final storeData = await LocalStorageService.getStoreData();
      final roleData = await LocalStorageService.getRoleAssignmentData();
      final userData = await LocalStorageService.getUserData();

      // Update values
      if (businessData != null && businessData['name'] != null) {
        businessName = businessData['name'];
      }
      if (storeData != null && storeData['name'] != null) {
        storeName = storeData['name'];
      }
      if (userData != null && userData['name'] != null) {
        userName = userData['name'];
      }

      // Get role name
      if (roleData != null && roleData['role'] != null) {
        final role = roleData['role'] as Map<String, dynamic>;
        final roleName = role['name'] as String?;
        if (roleName != null && roleName.isNotEmpty) {
          userRole = roleName;
        }
      }

      // Update state only once
      if (mounted) {
        setState(() {
          isLoaded = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading AppBar data: $e');
    }
  }

  String _getFirstName(String fullName) {
    final parts = fullName.split(' ');
    return parts.isNotEmpty ? parts.first : fullName;
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}';
    } else {
      return name.isNotEmpty ? name[0] : 'U';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.slate[100]),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title ?? businessName).bold(),
                Text(widget.subtitle ?? storeName).muted().small(),
              ],
            ),
          ),
          // Custom actions
          if (widget.actions != null) ...widget.actions!,
          // User info section
          if (widget.showUserInfo) ...[
            const Gap(16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // User info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getFirstName(userName),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ).small(),
                      const Gap(4),
                      const Text(
                        '|',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ).small,
                      const Gap(4),
                      Text(
                        userRole,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ).small,
                    ],
                  ),
                  const Gap(8),
                  // Avatar
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(userName),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
