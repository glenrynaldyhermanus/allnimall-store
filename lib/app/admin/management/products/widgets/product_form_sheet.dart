import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_text_input.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_text_area.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_image_picker.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'dart:io';

class ProductFormSheet extends StatefulWidget {
  final Product? product; // null untuk create, not null untuk edit

  const ProductFormSheet({super.key, this.product});

  @override
  State<ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<ProductFormSheet> {
  // Controller untuk setiap field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isActive = true;
  File? _selectedImage;
  String? _initialImageUrl;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      // Edit mode - populate fields with existing data
      _nameController.text = widget.product!.name;
      _codeController.text = widget.product!.code ?? '';
      _categoryController.text = widget.product!.categoryName ?? '';
      _priceController.text = widget.product!.price.toString();
      _purchasePriceController.text = widget.product!.purchasePrice.toString();
      _stockController.text = widget.product!.stock.toString();
      _unitController.text = widget.product!.unit ?? '';
      _weightController.text = widget.product!.weightGrams.toString();
      _discountController.text = widget.product!.discountValue.toString();
      _descriptionController.text = widget.product!.description ?? '';
      _isActive = widget.product!.isActive;
      _initialImageUrl = widget.product!.imageUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _purchasePriceController.dispose();
    _stockController.dispose();
    _unitController.dispose();
    _weightController.dispose();
    _discountController.dispose();
    _descriptionController.dispose();
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
        'purchase_price': double.tryParse(_purchasePriceController.text) ?? 0.0,
        'stock': int.tryParse(_stockController.text) ?? 0,
        'unit': _unitController.text.trim().isEmpty
            ? null
            : _unitController.text.trim(),
        'weight': double.tryParse(_weightController.text) ?? 0.0,
        'discount': double.tryParse(_discountController.text) ?? 0.0,
        'description': _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        'is_active': _isActive,
        'picture_url': pictureUrl,
      };

      if (widget.product != null) {
        // Update existing product
        await SupabaseService.updateProduct(widget.product!.id, productData);
      } else {
        // Create new product
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
              content: Text(widget.product != null
                  ? 'Produk berhasil diperbarui'
                  : 'Produk berhasil disimpan'),
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
                  'Gagal ${widget.product != null ? 'memperbarui' : 'menyimpan'} produk: ${e.toString()}'),
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
    final isEditMode = widget.product != null;

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
                    child: Text(isEditMode ? 'Edit Produk' : 'Tambah Produk')
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
                      ? 'Edit detail produk di bawah ini.'
                      : 'Isi detail produk di bawah ini.')
                  .muted(),
              const shadcn.Gap(24),

              // Nama Produk
              shadcn.FormField(
                key: const shadcn.TextFieldKey('name'),
                label: const Text('Nama Produk'),
                validator: const shadcn.NotEmptyValidator(
                    message: 'Nama produk wajib diisi'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan nama produk',
                  controller: _nameController,
                ),
              ),
              const shadcn.Gap(16),

              // Kode Produk
              shadcn.FormField(
                key: const shadcn.TextFieldKey('code'),
                label: const Text('Kode Produk'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan kode produk (opsional)',
                  controller: _codeController,
                ),
              ),
              const shadcn.Gap(16),

              // Kategori
              shadcn.FormField(
                key: const shadcn.TextFieldKey('category'),
                label: const Text('Kategori'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan kategori produk',
                  controller: _categoryController,
                ),
              ),
              const shadcn.Gap(16),

              // Foto Produk
              shadcn.FormField(
                key: const shadcn.TextFieldKey('image'),
                label: const Text('Foto Produk'),
                child: AllnimallImagePicker(
                  placeholder: 'Pilih foto produk',
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

              // Harga Jual
              shadcn.FormField(
                key: const shadcn.TextFieldKey('price'),
                label: const Text('Harga Jual'),
                validator: const shadcn.NotEmptyValidator(
                    message: 'Harga jual wajib diisi'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan harga jual',
                  controller: _priceController,
                  features: const [
                    shadcn.InputFeature.leading(
                      Icon(Icons.attach_money),
                    ),
                  ],
                ),
              ),
              const shadcn.Gap(16),

              // Harga Beli
              shadcn.FormField(
                key: const shadcn.TextFieldKey('purchasePrice'),
                label: const Text('Harga Beli'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan harga beli',
                  controller: _purchasePriceController,
                  features: const [
                    shadcn.InputFeature.leading(
                      Icon(Icons.attach_money),
                    ),
                  ],
                ),
              ),
              const shadcn.Gap(16),

              // Stok
              shadcn.FormField(
                key: const shadcn.TextFieldKey('stock'),
                label: const Text('Stok'),
                validator:
                    const shadcn.NotEmptyValidator(message: 'Stok wajib diisi'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan jumlah stok',
                  controller: _stockController,
                  features: const [
                    shadcn.InputFeature.leading(
                      Icon(Icons.inventory),
                    ),
                  ],
                ),
              ),
              const shadcn.Gap(16),

              // Satuan
              shadcn.FormField(
                key: const shadcn.TextFieldKey('unit'),
                label: const Text('Satuan'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan satuan (misal: pcs, box, kg)',
                  controller: _unitController,
                  features: const [
                    shadcn.InputFeature.leading(
                      Icon(Icons.category),
                    ),
                  ],
                ),
              ),
              const shadcn.Gap(16),

              // Berat (gram)
              shadcn.FormField(
                key: const shadcn.TextFieldKey('weight'),
                label: const Text('Berat (gram)'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan berat produk dalam gram',
                  controller: _weightController,
                  features: const [
                    shadcn.InputFeature.leading(
                      Icon(Icons.fitness_center),
                    ),
                  ],
                ),
              ),
              const shadcn.Gap(16),

              // Diskon (%)
              shadcn.FormField(
                key: const shadcn.TextFieldKey('discount'),
                label: const Text('Diskon (%)'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan diskon (jika ada)',
                  controller: _discountController,
                  features: const [
                    shadcn.InputFeature.leading(
                      Icon(Icons.discount),
                    ),
                  ],
                ),
              ),
              const shadcn.Gap(16),

              // Status Aktif
              Row(
                children: [
                  shadcn.Checkbox(
                    state: _isActive
                        ? shadcn.CheckboxState.checked
                        : shadcn.CheckboxState.unchecked,
                    onChanged: (value) => setState(() =>
                        _isActive = value == shadcn.CheckboxState.checked),
                  ),
                  const Text('Aktif (produk dapat dijual)'),
                ],
              ),
              const shadcn.Gap(16),

              // Deskripsi
              shadcn.FormField(
                key: const shadcn.TextFieldKey('description'),
                label: const Text('Deskripsi'),
                child: AllnimallTextArea(
                  placeholder: 'Masukkan deskripsi produk',
                  controller: _descriptionController,
                  expandableHeight: true,
                  initialHeight: 120,
                ),
              ),
              const shadcn.Gap(24),

              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: shadcn.FormErrorBuilder(
                  builder: (context, errors, child) {
                    return AllnimallButton.primary(
                      onPressed: errors.isEmpty && !_isSubmitting
                          ? () => context.submitForm()
                          : null,
                      isLoading: _isSubmitting,
                      child: Text(isEditMode ? 'Perbarui' : 'Simpan'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
