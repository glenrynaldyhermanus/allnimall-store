# Utils

## NumberFormatter

Utility class untuk format angka dan mata uang Indonesia (Rupiah).

### Penggunaan

```dart
import 'package:allnimall_store/src/core/utils/number_formatter.dart';

// Format harga
NumberFormatter.formatPrice(15000); // "Rp 15.000"

// Format total
NumberFormatter.formatTotalPrice(25000); // "Rp 25.000"

// Format stok
NumberFormatter.formatStock(0); // "Habis"
NumberFormatter.formatStock(5); // "Terbatas (5)"
NumberFormatter.formatStock(50); // "50"

// Format kuantitas
NumberFormatter.formatQuantity(10); // "10"

// Format diskon
NumberFormatter.formatDiscount(5000); // "-Rp 5.000"
```

### Helper Methods di Object Classes

#### Product
```dart
product.formattedPrice; // "Rp 15.000"
product.formattedStock; // "50" atau "Habis" atau "Terbatas (5)"
product.formattedWeight; // "1.5 kg" atau "500 g"
product.formattedDiscount; // "-Rp 5.000"
```

#### CartItem
```dart
cartItem.formattedTotalPrice; // "Rp 30.000"
cartItem.formattedQuantity; // "2"
```

### Method yang Tersedia

- `formatCurrency(double amount)` - Format mata uang dengan simbol Rp
- `formatCurrencyWithoutSymbol(double amount)` - Format mata uang tanpa simbol
- `formatNumber(double number)` - Format angka dengan pemisah ribuan
- `formatNumberWithDecimal(double number, {int decimalDigits = 2})` - Format angka dengan desimal
- `formatPercentage(double percentage)` - Format persentase
- `formatWeight(double weight)` - Format berat (g/kg)
- `formatStock(int stock)` - Format stok dengan status
- `formatQuantity(int quantity)` - Format kuantitas
- `parseCurrency(String text)` - Parse string ke double
- `formatPrice(double price)` - Format harga untuk display
- `formatTotalPrice(double total)` - Format total harga
- `formatDiscount(double discount)` - Format diskon
- `formatTax(double tax)` - Format pajak 