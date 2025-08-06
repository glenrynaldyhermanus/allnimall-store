import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_text_input.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_text_area.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_image_picker.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'dart:io';

class ItemFormSheet extends StatefulWidget {
  final Product? item; // null untuk create, not null untuk edit

  const ItemFormSheet({super.key, this.item});

  @override
  State<ItemFormSheet> createState() => _ItemFormSheetState();
}

class _ItemFormSheetState extends State<ItemFormSheet> {
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
  final TextEditingController _minStockController = TextEditingController();
  final TextEditingController _maxStockController = TextEditingController();
  final TextEditingController _shelfLifeController = TextEditingController();

  bool _isActive = true;
  bool _isPrescriptionRequired = false;
  File? _selectedImage;
  String? _initialImageUrl;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      // Edit mode - populate fields with existing data
      _nameController.text = widget.item!.name;
      _codeController.text = widget.item!.code ?? '';
      _categoryController.text = widget.item!.categoryName ?? '';
      _priceController.text = widget.item!.price.toString();
      _purchasePriceController.text = widget.item!.purchasePrice.toString();
      _stockController.text = widget.item!.stock.toString();
      _unitController.text = widget.item!.unit ?? '';
      _weightController.text = widget.item!.weightGrams.toString();
      _discountController.text = widget.item!.discountValue.toString();
      _descriptionController.text = widget.item!.description ?? '';
      _minStockController.text = widget.item!.minStock.toString();
      _maxStockController.text = widget.item!.maxStock?.toString() ?? '';
      _shelfLifeController.text = widget.item!.shelfLifeDays?.toString() ?? '';
      _isActive = widget.item!.isActive;
      _isPrescriptionRequired = widget.item!.isPrescriptionRequired;
      _initialImageUrl = widget.item!.imageUrl;
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
    _minStockController.dispose();
    _maxStockController.dispose();
    _shelfLifeController.dispose();
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
        'is_prescription_required': _isPrescriptionRequired,
        'picture_url': pictureUrl,
        'product_type': 'item', // Always set to item for this form
        'min_stock': int.tryParse(_minStockController.text) ?? 0,
        'max_stock': _maxStockController.text.trim().isEmpty
            ? null
            : int.tryParse(_maxStockController.text),
        'shelf_life_days': _shelfLifeController.text.trim().isEmpty
            ? null
            : int.tryParse(_shelfLifeController.text),
      };

      if (widget.item != null) {
        // Update existing product
        await SupabaseService.updateProduct(widget.item!.id, productData);
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
              content: Text(widget.item != null
                  ? 'Produk berhasil diperbarui'
                  : 'Produk berhasil disimpan'),
              trailing: AllnimallButton.primary(
                onPressed: () => overlay.close(),
                label: 'Tutup',
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
                  'Gagal ${widget.item != null ? 'memperbarui' : 'menyimpan'} produk: ${e.toString()}'),
              trailing: AllnimallButton.primary(
                onPressed: () => overlay.close(),
                label: 'Tutup',
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
    final isEditMode = widget.item != null;

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
                    label: 'Tutup',
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

              // Stok Minimum
              shadcn.FormField(
                key: const shadcn.TextFieldKey('minStock'),
                label: const Text('Stok Minimum'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan stok minimum',
                  controller: _minStockController,
                  features: const [
                    shadcn.InputFeature.leading(
                      Icon(Icons.warning),
                    ),
                  ],
                ),
              ),
              const shadcn.Gap(16),

              // Stok Maksimum
              shadcn.FormField(
                key: const shadcn.TextFieldKey('maxStock'),
                label: const Text('Stok Maksimum'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan stok maksimum (opsional)',
                  controller: _maxStockController,
                  features: const [
                    shadcn.InputFeature.leading(
                      Icon(Icons.storage),
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
                  placeholder: 'Contoh: pcs, kg, liter',
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
                  placeholder: 'Masukkan berat dalam gram',
                  controller: _weightController,
                  features: const [
                    shadcn.InputFeature.leading(
                      Icon(Icons.scale),
                    ),
                  ],
                ),
              ),
              const shadcn.Gap(16),

              // Masa Simpan (hari)
              shadcn.FormField(
                key: const shadcn.TextFieldKey('shelfLife'),
                label: const Text('Masa Simpan (hari)'),
                child: AllnimallTextInput(
                  placeholder: 'Masukkan masa simpan dalam hari',
                  controller: _shelfLifeController,
                  features: const [
                    shadcn.InputFeature.leading(
                      Icon(Icons.schedule),
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
                  placeholder: 'Masukkan deskripsi produk',
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
              const shadcn.Gap(16),

              // Butuh Resep
              shadcn.FormField(
                key: const shadcn.TextFieldKey('isPrescriptionRequired'),
                label: const Text('Butuh Resep'),
                child: shadcn.Switch(
                  value: _isPrescriptionRequired,
                  onChanged: (value) {
                    setState(() {
                      _isPrescriptionRequired = value;
                    });
                  },
                ),
              ),
              const shadcn.Gap(24),

              // Submit Button
              AllnimallButton.primary(
                onPressed: _isSubmitting ? null : _submit,
                isLoading: _isSubmitting,
                label: isEditMode ? 'Update Produk' : 'Simpan Produk',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
