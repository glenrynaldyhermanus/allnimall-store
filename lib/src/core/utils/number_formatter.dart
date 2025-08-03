import 'package:intl/intl.dart';

class NumberFormatter {
  // Format currency untuk Indonesia (Rupiah)
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Format currency tanpa simbol mata uang
  static String formatCurrencyWithoutSymbol(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Format angka dengan pemisah ribuan
  static String formatNumber(double number) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(number);
  }

  // Format angka dengan pemisah ribuan dan desimal
  static String formatNumberWithDecimal(double number, {int decimalDigits = 2}) {
    final formatter = NumberFormat('#,###.##', 'id_ID');
    formatter.minimumFractionDigits = decimalDigits;
    formatter.maximumFractionDigits = decimalDigits;
    return formatter.format(number);
  }

  // Format persentase
  static String formatPercentage(double percentage) {
    final formatter = NumberFormat('#,##0.0%', 'id_ID');
    return formatter.format(percentage / 100);
  }

  // Format berat/ukuran
  static String formatWeight(double weight) {
    if (weight >= 1000) {
      return '${(weight / 1000).toStringAsFixed(1)} kg';
    } else {
      return '${weight.toStringAsFixed(0)} g';
    }
  }

  // Format stok
  static String formatStock(int stock) {
    if (stock <= 0) {
      return 'Habis';
    } else if (stock <= 10) {
      return 'Terbatas ($stock)';
    } else {
      return stock.toString();
    }
  }

  // Format kuantitas
  static String formatQuantity(int quantity) {
    return quantity.toString();
  }

  // Parse string ke double (untuk input)
  static double? parseCurrency(String text) {
    if (text.isEmpty) return null;
    
    // Hapus semua karakter non-digit kecuali titik dan koma
    final cleanText = text.replaceAll(RegExp(r'[^\d.,]'), '');
    
    try {
      // Ganti koma dengan titik untuk parsing
      final normalizedText = cleanText.replaceAll(',', '.');
      return double.parse(normalizedText);
    } catch (e) {
      return null;
    }
  }

  // Format harga untuk display di UI
  static String formatPrice(double price) {
    return formatCurrency(price);
  }

  // Format total harga
  static String formatTotalPrice(double total) {
    return formatCurrency(total);
  }

  // Format diskon
  static String formatDiscount(double discount) {
    if (discount <= 0) {
      return formatCurrency(0);
    }
    return '-${formatCurrency(discount)}';
  }

  // Format pajak
  static String formatTax(double tax) {
    return formatCurrency(tax);
  }
} 