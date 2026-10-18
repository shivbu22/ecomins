/// Form field validators used throughout the app.
class Validators {
  Validators._();

  /// 10-digit Indian mobile number starting with 6-9
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (value.length != 10) return 'Enter a valid 10-digit number';
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      return 'Enter a valid Indian mobile number';
    }
    return null;
  }

  /// 6-digit OTP
  static String? otp(String? value) {
    if (value == null || value.isEmpty) return 'OTP is required';
    if (value.length != 6) return 'Enter all 6 digits';
    if (!RegExp(r'^\d{6}$').hasMatch(value)) return 'OTP must be digits only';
    return null;
  }

  /// Name: min 2 chars, letters and spaces only
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    if (!RegExp(r"^[a-zA-Z\s'.-]+$").hasMatch(value.trim())) {
      return 'Enter a valid name';
    }
    return null;
  }

  /// Valid email address
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// 6-digit Indian pincode
  static String? pincode(String? value) {
    if (value == null || value.isEmpty) return 'Pincode is required';
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Enter a valid 6-digit pincode';
    }
    return null;
  }

  /// Positive number (for amounts)
  static String? amount(String? value) {
    if (value == null || value.isEmpty) return 'Amount is required';
    final parsed = double.tryParse(value);
    if (parsed == null) return 'Enter a valid amount';
    if (parsed <= 0) return 'Amount must be greater than 0';
    return null;
  }
}
