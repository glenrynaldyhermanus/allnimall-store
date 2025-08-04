import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_icon_button.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';
import 'package:allnimall_store/src/providers/management_provider.dart';

class SupplierFormSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic>? supplier;

  const SupplierFormSheet({super.key, this.supplier});

  @override
  ConsumerState<SupplierFormSheet> createState() => _SupplierFormSheetState();
}

class _SupplierFormSheetState extends ConsumerState<SupplierFormSheet> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      _nameController.text = widget.supplier!['name'] ?? '';
      _emailController.text = widget.supplier!['email'] ?? '';
      _phoneController.text = widget.supplier!['phone'] ?? '';
      _addressController.text = widget.supplier!['address'] ?? '';
      _isActive = widget.supplier!['is_active'] ?? true;
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

  Future<void> _saveSupplier() async {
    // Basic validation
    if (_nameController.text.trim().isEmpty) {
      _showErrorToast('Nama supplier harus diisi');
      return;
    }

    if (_emailController.text.trim().isNotEmpty) {
      // Simple email validation
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(_emailController.text.trim())) {
        _showErrorToast('Format email tidak valid');
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.supplier != null) {
        // Update existing supplier
        await SupabaseService.updateSupplier(
          widget.supplier!['id'],
          {
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'address': _addressController.text.trim(),
            'is_active': _isActive,
          },
        );
      } else {
        // Create new supplier
        await SupabaseService.createSupplier({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'is_active': _isActive,
        });
      }

      // Reload suppliers
      ref.read(managementProvider.notifier).loadSuppliers();

      // Close sheet
      if (mounted) {
        shadcn.closeSheet(context);

        // Show success toast
        shadcn.showToast(
          context: context,
          builder: (context, overlay) => shadcn.SurfaceCard(
            child: shadcn.Basic(
              title: const Text('Berhasil'),
              content: Text(widget.supplier != null
                  ? 'Supplier berhasil diperbarui'
                  : 'Supplier berhasil ditambahkan'),
              trailing: AllnimallButton.primary(
                onPressed: () => overlay.close(),
                child: const Text('Tutup'),
              ),
            ),
          ),
          location: shadcn.ToastLocation.topCenter,
        );
      }
    } catch (e) {
      _showErrorToast('Gagal menyimpan supplier: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorToast(String message) {
    shadcn.showToast(
      context: context,
      builder: (context, overlay) => shadcn.SurfaceCard(
        child: shadcn.Basic(
          title: const Text('Error'),
          content: Text(message),
          trailing: AllnimallButton.primary(
            onPressed: () => overlay.close(),
            child: const Text('Tutup'),
          ),
        ),
      ),
      location: shadcn.ToastLocation.topCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.supplier != null ? 'Edit Supplier' : 'Tambah Supplier',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AllnimallIconButton.ghost(
                onPressed: () => shadcn.closeSheet(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Form fields
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Name field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nama Supplier',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan nama supplier',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Email field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan email supplier',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Phone field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Telepon',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan nomor telepon',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Address field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alamat',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _addressController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan alamat supplier',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Active status
                  Row(
                    children: [
                      Switch(
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Status Aktif',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: AllnimallButton.outline(
                  onPressed: () => shadcn.closeSheet(context),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AllnimallButton.primary(
                  onPressed: _isLoading ? null : _saveSupplier,
                  isLoading: _isLoading,
                  child: Text(widget.supplier != null ? 'Simpan' : 'Tambah'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
