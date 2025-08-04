import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';
import 'package:allnimall_store/src/data/objects/customer.dart';
import 'package:allnimall_store/src/providers/management_provider.dart';

class CustomerFormSheet extends ConsumerStatefulWidget {
  final Customer? customer;

  const CustomerFormSheet({super.key, this.customer});

  @override
  ConsumerState<CustomerFormSheet> createState() => _CustomerFormSheetState();
}

class _CustomerFormSheetState extends ConsumerState<CustomerFormSheet> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _nameController.text = widget.customer!.name;
      _emailController.text = widget.customer!.email ?? '';
      _phoneController.text = widget.customer!.phone ?? '';
      _addressController.text = widget.customer!.address ?? '';
      _isActive = widget.customer!.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveCustomer() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final customerData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        'phone': _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        'address': _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        'is_active': _isActive,
      };

      if (widget.customer != null) {
        // Update existing customer
        await SupabaseService.updateCustomer(widget.customer!.id, customerData);
      } else {
        // Create new customer
        await SupabaseService.createCustomer(customerData);
      }

      // Reload customers
      ref.read(managementProvider.notifier).loadCustomers();

      // Close sheet
      if (mounted) {
        closeSheet(context);
      }

      // Show success toast
      if (mounted) {
        showToast(
          context: context,
          builder: (context, overlay) => SurfaceCard(
            child: Basic(
              title: const Text('Berhasil'),
              content: Text(widget.customer != null
                  ? 'Pelanggan berhasil diperbarui'
                  : 'Pelanggan berhasil ditambahkan'),
              trailing: AllnimallButton.primary(
                onPressed: () => overlay.close(),
                child: const Text('Tutup'),
              ),
            ),
          ),
          location: ToastLocation.topCenter,
        );
      }
    } catch (e) {
      // Show error toast
      if (mounted) {
        showToast(
          context: context,
          builder: (context, overlay) => SurfaceCard(
            child: Basic(
              title: const Text('Error'),
              content: Text('Gagal menyimpan pelanggan: ${e.toString()}'),
              trailing: AllnimallButton.primary(
                onPressed: () => overlay.close(),
                child: const Text('Tutup'),
              ),
            ),
          ),
          location: ToastLocation.topCenter,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.customer != null
                      ? 'Edit Pelanggan'
                      : 'Tambah Pelanggan',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AllnimallButton.ghost(
                onPressed: () => closeSheet(context),
                child: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Form fields
          Column(
            children: [
              // Name field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nama Pelanggan',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    placeholder: const Text('Masukkan nama pelanggan'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Email field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Email',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    placeholder: const Text('Masukkan email pelanggan'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Phone field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Telepon',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneController,
                    placeholder: const Text('Masukkan nomor telepon'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Address field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Alamat',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextArea(
                    controller: _addressController,
                    placeholder: const Text('Masukkan alamat pelanggan'),
                    expandableHeight: true,
                    initialHeight: 100,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Active status
              Row(
                children: [
                  const Text('Status Aktif',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(width: 12),
                  Switch(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: AllnimallButton.outline(
                  onPressed: () => closeSheet(context),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AllnimallButton.primary(
                  onPressed: _isLoading ? null : _saveCustomer,
                  isLoading: _isLoading,
                  child: Text(widget.customer != null ? 'Simpan' : 'Tambah'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
