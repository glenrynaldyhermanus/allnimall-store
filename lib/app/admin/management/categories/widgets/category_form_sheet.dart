import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_select.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';
import 'package:allnimall_store/src/providers/management_provider.dart';

class CategoryFormSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic>? category;

  const CategoryFormSheet({super.key, this.category});

  @override
  ConsumerState<CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends ConsumerState<CategoryFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'item';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!['name'] ?? '';
      _descriptionController.text = widget.category!['description'] ?? '';
      _selectedType = widget.category!['type'] ?? 'item';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.category != null) {
        // Update existing category
        await SupabaseService.updateCategory(
          widget.category!['id'],
          _nameController.text.trim(),
          _descriptionController.text.trim(),
          _selectedType,
        );
      } else {
        // Create new category
        await SupabaseService.createCategory(
          _nameController.text.trim(),
          _descriptionController.text.trim(),
          _selectedType,
        );
      }

      // Reload categories
      ref.read(managementProvider.notifier).loadCategories();

      // Show success toast first
      if (mounted) {
        showToast(
          context: context,
          builder: (context, overlay) => SurfaceCard(
            child: Basic(
              title: const Text('Berhasil'),
              content: Text(
                widget.category != null
                    ? 'Kategori berhasil diperbarui'
                    : 'Kategori berhasil ditambahkan',
              ),
              trailing: AllnimallButton.primary(
                onPressed: () => overlay.close(),
                label: 'Tutup',
              ),
            ),
          ),
          location: ToastLocation.topCenter,
        );
      }

      // Close sheet after showing toast
      if (mounted) {
        closeSheet(context);
      }
    } catch (e) {
      // Show error toast
      if (mounted) {
        showToast(
          context: context,
          builder: (context, overlay) => SurfaceCard(
            child: Basic(
              title: const Text('Error'),
              content: Text('Gagal menyimpan kategori: ${e.toString()}'),
              trailing: AllnimallButton.primary(
                onPressed: () => overlay.close(),
                label: 'Tutup',
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
      width: 400,
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.category_outlined,
                  size: 24,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.category != null ? 'Edit Kategori' : 'Tambah Kategori',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                AllnimallButton.ghost(
                  onPressed: () => closeSheet(context),
                  label: 'Tutup',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Form fields
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nama Kategori',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  placeholder: const Text('Masukkan nama kategori'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tipe Kategori',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                AllnimallSelect<String>(
                  items: const ['item', 'service'],
                  itemBuilder: (context, item) => Text(
                    item == 'item' ? 'Produk' : 'Jasa',
                  ),
                  placeholder: const Text('Pilih tipe kategori'),
                  value: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value ?? 'item';
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Deskripsi (Opsional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextArea(
                  controller: _descriptionController,
                  placeholder: const Text('Masukkan deskripsi kategori'),
                  initialHeight: 100,
                  expandableHeight: true,
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
                    label: 'Batal',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AllnimallButton.primary(
                    onPressed: _isLoading ? null : _saveCategory,
                    isLoading: _isLoading,
                    label: widget.category != null ? 'Simpan' : 'Tambah',
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
