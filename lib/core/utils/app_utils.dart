import 'package:flutter/material.dart';

/// Utility helpers used throughout the app.
class AppUtils {
  AppUtils._();

  /// Format currency: 1234.5 → "₹1,234"
  static String formatCurrency(double amount) {
    final intAmount = amount.toInt();
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

  /// Format date: DateTime → "24 Oct 2024"
  static String formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  /// Format time: DateTime → "10:30 AM"
  static String formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:$minute $period';
  }

  /// Relative time: "2 min ago", "3 hours ago", "Yesterday"
  static String relativeTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return formatDate(time);
  }

  /// Greeting based on hour: "Good morning", "Good afternoon", "Good evening"
  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  /// Greeting emoji based on hour
  static String greetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '☀️';
    if (hour < 17) return '🌤️';
    return '🌙';
  }

  /// Truncate text: "Hello world this is..." → "Hello world..."
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Format phone: "9876543210" → "+91 98765 43210"
  static String formatPhone(String phone) {
    if (phone.length != 10) return '+91 $phone';
    return '+91 ${phone.substring(0, 5)} ${phone.substring(5)}';
  }

  /// Eco points to tier: 0-500=Bronze, 501-1500=Silver, 1501-3000=Gold, 3001+=Platinum
  static String ecoTier(int points) {
    if (points <= 500) return 'Bronze';
    if (points <= 1500) return 'Silver';
    if (points <= 3000) return 'Gold';
    return 'Platinum';
  }

  static Color ecoTierColor(int points) {
    if (points <= 500) return const Color(0xFFCD7F32);
    if (points <= 1500) return const Color(0xFFC0C0C0);
    if (points <= 3000) return const Color(0xFFFFD700);
    return const Color(0xFFE5E4E2);
  }

  static String ecoTierEmoji(int points) {
    if (points <= 500) return '🥉';
    if (points <= 1500) return '🥈';
    if (points <= 3000) return '🥇';
    return '💎';
  }

  /// Points needed to reach next tier
  static int pointsToNextTier(int points) {
    if (points <= 500) return 500 - points;
    if (points <= 1500) return 1500 - points;
    if (points <= 3000) return 3000 - points;
    return 0;
  }

  /// Progress (0.0–1.0) within current tier
  static double tierProgress(int points) {
    if (points <= 500) return points / 500;
    if (points <= 1500) return (points - 500) / 1000;
    if (points <= 3000) return (points - 1500) / 1500;
    return 1.0;
  }
}
