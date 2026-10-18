import 'package:flutter/foundation.dart';

/// Mock analytics tracker — logs events to debug console only.
/// Replace with real analytics (Firebase, Mixpanel, etc.) in production.
class AppAnalytics {
  AppAnalytics._();

  static void trackScreen(String screenName) {
    debugPrint('[Analytics] Screen: $screenName');
  }

  static void trackEvent(String event, {Map<String, dynamic>? params}) {
    debugPrint('[Analytics] Event: $event ${params ?? ''}');
  }

  static void trackBooking(String serviceId, double amount) {
    debugPrint('[Analytics] Booking: $serviceId ₹$amount');
  }

  static void trackSearch(String query) {
    debugPrint('[Analytics] Search: $query');
  }

  static void trackEcoAction(String action, int pointsEarned) {
    debugPrint('[Analytics] Eco: $action (+$pointsEarned pts)');
  }

  static void trackError(String error, {String? screen}) {
    debugPrint('[Analytics] Error: $error${screen != null ? ' on $screen' : ''}');
  }
}
