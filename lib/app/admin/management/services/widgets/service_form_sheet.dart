import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_text_input.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_text_area.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_image_picker.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_select.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/data/usecases/get_service_categories_usecase.dart';
import 'package:allnimall_store/src/data/repositories/management_repository_impl.dart';
import 'dart:io';

class ServiceFormSheet extends StatefulWidget {
  final Product? service; // null untuk create, not null untuk edit

  const ServiceFormSheet({super.key, this.service});

  @override
  State<ServiceFormSheet> createState() => _ServiceFormSheetState();
}

class _ServiceFormSheetState extends State<ServiceFormSheet> {
  // Controller untuk setiap field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  bool _isActive = true;
  String? _selectedCategoryId;
  File? _selectedImage;
  String? _initialImageUrl;
  bool _isSubmitting = false;
  List<Map<String, dynamic>> _serviceCategories = [];

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      // Edit mode - populate fields with existing data
      _nameController.text = widget.service!.name;
      _codeController.text = widget.service!.code ?? '';
      _categoryController.text = widget.service!.categoryName ?? '';
      _priceController.text = widget.service!.price.toString();
      _discountController.text = widget.service!.discountValue.toString();
      _descriptionController.text = widget.service!.description ?? '';
      _durationController.text =
          widget.service!.durationMinutes?.toString() ?? '';
      _isActive = widget.service!.isActive;
      _selectedCategoryId = widget.service!.categoryId;
      _initialImageUrl = widget.service!.imageUrl;
    }
    _loadServiceCategories();
  }

  Future<void> _loadServiceCategories() async {
    try {
      final repository = ManagementRepositoryImpl(SupabaseService.client);
      final useCase = GetServiceCategoriesUseCase(repository);
      final categories = await useCase.execute();
      setState(() {
        _serviceCategories = categories;
      });
    } catch (e) {
      // Handle error silently for now
      debugPrint('Error loading service categories: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Get store ID
      final storeId = await SupabaseService.getStoreId();
      if (storeId == null) {
        throw Exception('Store ID tidak ditemukan');
      }

      String? pictureUrl = _initialImageUrl;

      // Upload image if selected
      if (_selectedImage != null) {
        pictureUrl =
            await SupabaseService.uploadProductImage(_selectedImage!, storeId);
      }

      // Prepare product data
      final productData = {
        'name': _nameController.text.trim(),
        'code': _codeController.text.trim().isEmpty
            ? null
            : _codeController.text.trim(),
        'category': _categoryController.text.trim().isEmpty
            ? null
            : _categoryController.text.trim(),
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'purchase_price': 0.0, // Services don't have purchase price
        'stock': 0, // Services don't have stock
        'unit': 'session', // Default unit for services
        'weight': 0.0, // Services don't have weight
        'discount': double.tryParse(_discountController.text) ?? 0.0,
        'description': _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        'is_active': _isActive,
        'picture_url': pictureUrl,
        'product_type': 'service', // Always set to service for this form
        'duration_minutes': _durationController.text.trim().isEmpty
            ? null
            : int.tryParse(_durationController.text),
        'category_id': _selectedCategoryId,
      };

      if (widget.service != null) {
        // Update existing service
        await SupabaseService.updateProduct(widget.service!.id, productData);
      } else {
        // Create new service
        await SupabaseService.createProduct(productData);
      }

      // Close sheet
      shadcn.closeSheet(context);

      // Show success toast
      if (mounted) {
        shadcn.showToast(
          context: context,
          builder: (context, overlay) => shadcn.SurfaceCard(
            child: shadcn.Basic(
              title: const Text('Berhasil'),
              content: Text(widget.service != null
                  ? 'Jasa berhasil diperbarui'
                  : 'Jasa berhasil disimpan'),
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
      // Show error toast
      if (mounted) {
        shadcn.showToast(
          context: context,
          builder: (context, overlay) => shadcn.SurfaceCard(
            child: shadcn.Basic(
              title: const Text('Error'),
              content: Text(
                  'Gagal ${widget.service != null ? 'memperbarui' : 'menyimpan'} jasa: ${e.toString()}'),
              trailing: AllnimallButton.primary(
                onPressed: () => overlay.close(),
                child: const Text('Tutup'),
              ),
            ),
          ),
          location: shadcn.ToastLocation.topCenter,
        );
      }
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.service != null;

    return Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 480),
      child: shadcn.Form(
        onSubmit: (context, values) async {
          await _submit();
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(isEditMode ? 'Edit Jasa' : 'Tambah Jasa')
                        .large()
                        .semiBold(),
                  ),
                  AllnimallButton.ghost(
                    onPressed: () => shadcn.closeSheet(context),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              const shadcn.Gap(16),
              Text(isEditMode
                      ? 'Edit detail jasa di bawah ini.'
                      : 'Isi detail jasa di bawah ini.')
                  .muted(),
              const shadcn.Gap(24),

              // Nama Jasa
              shadcn.FormField(
                key: const shadcn.TextFieldKey('name'),
                label: const Text('Nama Jasa'),
                validator: const shadcn.NotEmptyValidator(
                    message: 'Nama jasa wajib diisi'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan nama jasa',
                  controller: _nameController,
                ),
              ),
              const shadcn.Gap(16),

              // Kode Jasa
              shadcn.FormField(
                key: const shadcn.TextFieldKey('code'),
                label: const Text('Kode Jasa'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan kode jasa (opsional)',
                  controller: _codeController,
                ),
              ),
              const shadcn.Gap(16),

              // Kategori Jasa
              shadcn.FormField(
                key: const shadcn.TextFieldKey('category'),
                label: const Text('Kategori Jasa'),
                child: AllnimallSelect<String>(
                  value: _selectedCategoryId,
                  items:
                      _serviceCategories.map((e) => e['id'] as String).toList(),
                  itemBuilder: (context, item) => Text(
                    _serviceCategories
                        .firstWhere((e) => e['id'] == item)['name'] as String,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                  placeholder: const Text('Pilih kategori jasa'),
                ),
              ),
              const shadcn.Gap(16),

              // Durasi Jasa
              shadcn.FormField(
                key: const shadcn.TextFieldKey('duration'),
                label: const Text('Durasi (menit)'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan durasi dalam menit',
                  controller: _durationController,
                  features: const [
                    shadcn.InputFeature.leading(
                      Icon(Icons.access_time),
                    ),
                  ],
                ),
              ),
              const shadcn.Gap(16),

              // Foto Jasa
              shadcn.FormField(
                key: const shadcn.TextFieldKey('image'),
                label: const Text('Foto Jasa'),
                child: AllnimallImagePicker(
                  placeholder: 'Pilih foto jasa',
                  initialImageUrl: _initialImageUrl,
                  onImageSelected: (file) {
                    setState(() {
                      _selectedImage = file;
                    });
                  },
                  width: 200,
                  height: 200,
                ),
              ),
              const shadcn.Gap(16),

              // Harga
              shadcn.FormField(
                key: const shadcn.TextFieldKey('price'),
                label: const Text('Harga'),
                validator: const shadcn.NotEmptyValidator(
                    message: 'Harga wajib diisi'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan harga jasa',
                  controller: _priceController,
                  features: const [
                    shadcn.InputFeature.leading(
                      Icon(Icons.attach_money),
                    ),
                  ],
                ),
              ),
              const shadcn.Gap(16),

              // Diskon
              shadcn.FormField(
                key: const shadcn.TextFieldKey('discount'),
                label: const Text('Diskon (%)'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan persentase diskon',
                  controller: _discountController,
                  features: const [
                    shadcn.InputFeature.leading(
                      Icon(Icons.discount),
                    ),
                  ],
                ),
              ),
              const shadcn.Gap(16),

              // Deskripsi
              shadcn.FormField(
                key: const shadcn.TextFieldKey('description'),
                label: const Text('Deskripsi'),
                child: AllnimallTextArea(
                  placeholder: 'Masukkan deskripsi jasa',
                  controller: _descriptionController,
                ),
              ),
              const shadcn.Gap(16),

              // Status
              shadcn.FormField(
                key: const shadcn.TextFieldKey('isActive'),
                label: const Text('Status'),
                child: shadcn.Switch(
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
              ),
              const shadcn.Gap(24),

              // Submit Button
              AllnimallButton.primary(
                onPressed: _isSubmitting ? null : _submit,
                isLoading: _isSubmitting,
                child: Text(isEditMode ? 'Update Jasa' : 'Simpan Jasa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
