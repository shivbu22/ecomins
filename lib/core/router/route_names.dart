/// All route path constants for the Ecomins app.
class RouteNames {
  RouteNames._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String loginOtp = '/login/otp';
  static const String home = '/home';
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String serviceCategory = '/services/:categoryId';
  static const String serviceDetail = '/services/:categoryId/:serviceId';
  static const String bookService = '/book/:serviceId';
  static const String smartScheduling = '/book/:serviceId/schedule';
  static const String bookingConfirmed = '/booking/:bookingId/confirmed';
  static const String liveTracking = '/booking/:bookingId/tracking';
  static const String workerProfile = '/worker/:workerId';
  static const String rateService = '/booking/:bookingId/rate';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String savedAddresses = '/profile/addresses';
  static const String paymentMethods = '/profile/payments';
  static const String walletHistory = '/profile/wallet';
  static const String transactionDetails = '/profile/wallet/:txId';
  static const String settings = '/profile/settings';
  static const String helpSupport = '/profile/help';
  static const String referralProgram = '/profile/referral';
  static const String ecoHub = '/eco';
  static const String sustainabilityImpact = '/eco/impact';
  static const String communityLeaderboard = '/eco/leaderboard';
  static const String ecoRewardsMarketplace = '/eco/rewards';
  static const String carbonCreditsMarketplace = '/eco/carbon';
  static const String ecoEventsWorkshops = '/eco/events';
  static const String smartHomeIntegration = '/eco/smarthome';

  // ── New screens ──────────────────────────────────────────────────────────
  static const String promoBanner = '/promo';
  static const String serviceMap = '/service-map';
  static const String bookingCancel = '/booking/:bookingId/cancel';
  static const String bookingReschedule = '/booking/:bookingId/reschedule';
  static const String serviceReviews = '/service-reviews/:serviceId';
  static const String serviceComparison = '/service-compare';
  static const String flashDeals = '/flash-deals';
  static const String howItWorks = '/how-it-works';
  static const String serviceBundles = '/bundles';
  static const String nearbyWorkers = '/workers/nearby';
  static const String workerAvailability = '/workers/availability';
  static const String serviceHistory = '/service-history';
  static const String appTour = '/tour';
  static const String serviceFeedback = '/feedback';
  static const String ecoCalculator = '/eco/calculator';
  static const String ecoBadges = '/eco/badges';
  static const String ecoChallenges = '/eco/challenges';
  static const String carbonOffset = '/eco/offset';
  static const String ecoNews = '/eco/news';
  static const String subscription = '/profile/subscription';
  static const String notificationPreferences = '/profile/notifications';
  static const String privacySettings = '/profile/privacy';
  static const String language = '/profile/language';
  static const String loyaltyProgram = '/profile/loyalty';
  static const String emergencyContact = '/profile/emergency';
}
