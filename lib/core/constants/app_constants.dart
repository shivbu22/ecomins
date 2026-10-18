/// Firestore collection path constants and environment key names.
class AppConstants {
  AppConstants._();

  // ── Firestore collection paths ──────────────────────────────────────────────
  static const String usersCollection = 'users';
  static const String addressesSubcollection = 'addresses';
  static const String paymentMethodsSubcollection = 'paymentMethods';

  static const String servicesCollection = 'services';
  static const String categoriesCollection = 'categories';

  static const String workersCollection = 'workers';

  static const String bookingsCollection = 'bookings';

  static const String ecoRewardsCollection = 'ecoRewards';
  static const String carbonCreditsCollection = 'carbonCredits';
  static const String ecoEventsCollection = 'ecoEvents';

  static const String leaderboardCollection = 'leaderboard';
  static const String leaderboardEntriesSubcollection = 'entries';

  static const String notificationsCollection = 'notifications';
  static const String notificationItemsSubcollection = 'items';

  // ── Leaderboard period keys ─────────────────────────────────────────────────
  static const String leaderboardWeekly = 'weekly';
  static const String leaderboardMonthly = 'monthly';
  static const String leaderboardAllTime = 'allTime';

  // ── Environment variable key names ─────────────────────────────────────────
  static const String envGoogleMapsApiKey = 'GOOGLE_MAPS_API_KEY';
  static const String envRazorpayKeyId = 'RAZORPAY_KEY_ID';
  static const String envRazorpayKeySecret = 'RAZORPAY_KEY_SECRET';
  static const String envFirebaseProjectId = 'FIREBASE_PROJECT_ID';
  static const String envFirebaseApiKey = 'FIREBASE_API_KEY';
  static const String envFirebaseAppId = 'FIREBASE_APP_ID';
  static const String envFirebaseMessagingSenderId = 'FIREBASE_MESSAGING_SENDER_ID';
  static const String envFirebaseStorageBucket = 'FIREBASE_STORAGE_BUCKET';
  static const String envSmartHomeWebhookSecret = 'SMART_HOME_WEBHOOK_SECRET';

  // ── Pagination ──────────────────────────────────────────────────────────────
  static const int pageSize = 20;

  // ── Worker location update interval ────────────────────────────────────────
  static const Duration workerLocationUpdateInterval = Duration(seconds: 5);

  // ── Worker assignment timeout ───────────────────────────────────────────────
  static const Duration workerAssignmentTimeout = Duration(minutes: 10);

  // ── SharedPreferences keys ──────────────────────────────────────────────────
  static const String prefOnboardingComplete = 'onboarding_complete';
}
