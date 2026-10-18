import 'package:flutter/material.dart';

// ── String Extensions ─────────────────────────────────────────────────────────

extension StringExtensions on String {
  /// Capitalizes the first letter: "hello" → "Hello"
  String get capitalize =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  /// Title-cases every word: "hello world" → "Hello World"
  String get titleCase => split(' ').map((w) => w.capitalize).join(' ');

  /// Returns true if this is a valid Indian mobile number
  bool get isValidPhone => RegExp(r'^[6-9]\d{9}$').hasMatch(this);

  /// Returns true if this is a valid email address
  bool get isValidEmail =>
      RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  /// Truncates to [maxLength] chars with ellipsis
  String truncate(int maxLength) =>
      length <= maxLength ? this : '${substring(0, maxLength)}...';
}

// ── DateTime Extensions ───────────────────────────────────────────────────────

extension DateTimeExtensions on DateTime {
  /// True if this date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// True if this date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Short day name: "Mon", "Tue", etc.
  String get dayName =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday - 1];

  /// Short month name: "Jan", "Feb", etc.
  String get monthName => [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ][month - 1];
}

// ── Double Extensions ─────────────────────────────────────────────────────────

extension DoubleExtensions on double {
  /// Formats as Indian Rupee: 1234.5 → "₹1,234"
  String get inr {
    final intAmount = toInt();
    final str = intAmount.toString();
    final result = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0) {
        if (count == 3 || (count > 3 && (count - 3) % 2 == 0)) {
          result.write(',');
        }
      }
      result.write(str[i]);
      count++;
    }
    return '₹${result.toString().split('').reversed.join()}';
  }
}

// ── BuildContext Extensions ───────────────────────────────────────────────────

extension ContextExtensions on BuildContext {
  /// Shows a floating snackbar with optional error styling
  void showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            isError ? const Color(0xFF93000A) : const Color(0xFF1D201D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  /// Shows a success snackbar with ✅ prefix
  void showSuccess(String msg) => showSnack('✅ $msg');

  /// Shows an error snackbar with ❌ prefix
  void showError(String msg) => showSnack('❌ $msg', isError: true);

  /// Screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// True if screen is tablet-sized (≥600px)
  bool get isTablet => screenWidth >= 600;
}
