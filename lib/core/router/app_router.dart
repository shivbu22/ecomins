import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/onboarding_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/auth/splash_screen.dart';
import '../../features/booking/book_service_screen.dart';
import '../../features/booking/booking_cancel_screen.dart';
import '../../features/booking/booking_confirmed_screen.dart';
import '../../features/booking/booking_reschedule_screen.dart';
import '../../features/booking/live_tracking_screen.dart';
import '../../features/booking/rate_service_screen.dart';
import '../../features/booking/smart_scheduling_screen.dart';
import '../../features/booking/worker_profile_screen.dart';
import '../../features/eco/carbon_credits_marketplace_screen.dart';
import '../../features/eco/carbon_offset_screen.dart';
import '../../features/eco/community_leaderboard_screen.dart';
import '../../features/eco/eco_badges_screen.dart';
import '../../features/eco/eco_calculator_screen.dart';
import '../../features/eco/eco_challenges_screen.dart';
import '../../features/eco/eco_events_screen.dart';
import '../../features/eco/eco_hub_v2_screen.dart';
// eco_hub_screen.dart kept for backwards compat but EcoHubV2Screen is used
import '../../features/eco/eco_news_screen.dart';
import '../../features/eco/eco_rewards_marketplace_screen.dart';
import '../../features/eco/smart_home_screen.dart';
import '../../features/eco/sustainability_impact_screen.dart';
import '../../features/home/app_tour_screen.dart';
import '../../features/home/flash_deals_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/how_it_works_screen.dart';
import '../../features/home/nearby_workers_screen.dart';
import '../../features/home/promo_banner_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/orders/order_history_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/emergency_contact_screen.dart';
import '../../features/profile/language_screen.dart';
import '../../features/profile/loyalty_program_screen.dart';
import '../../features/profile/notification_preferences_screen.dart';
import '../../features/profile/payment_methods_screen.dart';
import '../../features/profile/privacy_settings_screen.dart';
import '../../features/profile/referral_program_screen.dart';
import '../../features/profile/saved_addresses_screen.dart';
import '../../features/profile/subscription_screen.dart';
import '../../features/profile/transaction_details_screen.dart';
// user_profile_screen.dart kept for backwards compat (not used in routes)
// ignore: unused_import
import '../../features/profile/user_profile_screen.dart';
import '../../features/profile/profile_v2_screen.dart';
import '../../features/profile/profile_completion_screen.dart';
import '../../features/profile/wallet_history_screen.dart';
import '../../features/search/search_results_screen.dart';
import '../../features/services/deep_clean_detail_screen.dart';
import '../../features/services/garbage_collection_screen.dart';
import '../../features/services/recycling_service_screen.dart';
import '../../features/services/service_bundle_screen.dart';
import '../../features/services/service_category_screen.dart';
import '../../features/services/service_comparison_screen.dart';
import '../../features/services/service_detail_screen.dart';
import '../../features/services/service_feedback_screen.dart';
import '../../features/services/service_history_screen.dart';
import '../../features/services/service_map_screen.dart';
import '../../features/services/service_review_list_screen.dart';
import '../../features/services/worker_availability_screen.dart';
import '../../features/booking/booking_invoice_screen.dart';
import '../../features/eco/eco_report_screen.dart';
import '../../features/eco/eco_streak_screen.dart';
import '../../features/eco/tree_tracker_screen.dart';
import '../../features/eco/volunteer_screen.dart';
import '../../features/home/app_update_screen.dart';
import '../../features/home/city_selector_screen.dart';
import '../../features/home/gift_card_screen.dart';
import '../../features/home/referral_landing_screen.dart';
import '../../features/home/seasonal_offers_screen.dart';
import '../../features/profile/account_security_screen.dart';
import '../../features/profile/address_add_screen.dart';
import '../../features/profile/data_export_screen.dart';
import '../../features/profile/help_ticket_screen.dart';
import '../../features/services/service_checklist_screen.dart';
import '../../features/services/service_faq_screen.dart';
import '../../features/services/service_package_detail_screen.dart';
import '../../features/services/service_provider_screen.dart';
import '../../features/services/service_rating_summary_screen.dart';
import '../../features/services/service_subscription_screen.dart';
import '../../features/settings/help_support_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../providers/auth_providers.dart';
import 'route_names.dart';

// ── New personalized screens ──────────────────────────────────────────────────
import '../../features/home/for_you_screen.dart';
import '../../features/home/home_profile_screen.dart';
import '../../features/home/personalized_dashboard_screen.dart';
import '../../features/home/quick_rebook_screen.dart';
import '../../features/home/live_activity_screen.dart';
import '../../features/home/service_request_screen.dart';
import '../../features/booking/worker_chat_screen.dart';
import '../../features/booking/tip_worker_screen.dart';
import '../../features/booking/service_proof_screen.dart';
import '../../features/booking/recurring_bookings_screen.dart';
import '../../features/booking/booking_timeline_screen.dart';
import '../../features/booking/post_service_survey_screen.dart';
import '../../features/services/promo_code_screen.dart';
import '../../features/services/favorites_screen.dart';
import '../../features/services/service_reminder_screen.dart';
import '../../features/services/service_availability_checker_screen.dart';
import '../../features/profile/wallet_topup_screen.dart';
import '../../features/profile/spending_insights_screen.dart';
import '../../features/profile/achievements_screen.dart';
import '../../features/eco/eco_goals_screen.dart';
import '../../features/services/all_services_screen.dart';
import '../../features/services/service_detail_v2_screen.dart';

/// Routes that do NOT require authentication.
const _publicRoutes = {
  RouteNames.splash,
  RouteNames.onboarding,
  RouteNames.login,
  RouteNames.loginOtp,
};

/// Riverpod provider that exposes the configured [GoRouter].
final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = _AuthNotifier(ref);

  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoggedIn = ref.read(authStateProvider);
      final isPublic = _publicRoutes.contains(state.matchedLocation);

      if (!isLoggedIn && !isPublic) {
        return RouteNames.login;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (_, __) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'otp',
            builder: (_, state) => OtpScreen(
              phone: state.uri.queryParameters['phone'] ?? '',
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.search,
        builder: (_, __) => const SearchResultsScreen(),
      ),
      GoRoute(
        path: RouteNames.notifications,
        builder: (_, __) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/services/:categoryId',
        builder: (_, state) => ServiceCategoryScreen(
          categoryId: state.pathParameters['categoryId']!,
        ),
        routes: [
          GoRoute(
            path: ':serviceId',
            builder: (_, state) => ServiceDetailScreen(
              categoryId: state.pathParameters['categoryId']!,
              serviceId: state.pathParameters['serviceId']!,
            ),
          ),
          GoRoute(
            path: 'deep_clean_detail',
            builder: (_, __) => const DeepCleanDetailScreen(),
          ),
          GoRoute(
            path: 'recycling_service',
            builder: (_, __) => const RecyclingServiceScreen(),
          ),
          GoRoute(
            path: 'garbage_collection',
            builder: (_, __) => const GarbageCollectionScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/book/:serviceId',
        builder: (_, state) => BookServiceScreen(
          serviceId: state.pathParameters['serviceId']!,
        ),
        routes: [
          GoRoute(
            path: 'schedule',
            builder: (_, state) => const SmartSchedulingScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/booking/:bookingId/confirmed',
        builder: (_, state) => BookingConfirmedScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/booking/:bookingId/tracking',
        builder: (_, state) => LiveTrackingScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/booking/:bookingId/rate',
        builder: (_, state) => RateServiceScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/worker/:workerId',
        builder: (_, state) => WorkerProfileScreen(
          workerId: state.pathParameters['workerId']!,
        ),
      ),
      GoRoute(
        path: '/scheduling',
        builder: (_, __) => const SmartSchedulingScreen(),
      ),
      GoRoute(
        path: RouteNames.orders,
        builder: (_, __) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (_, __) => const ProfileV2Screen(),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (_, __) => const EditProfileScreen(),
          ),
          GoRoute(
            path: 'addresses',
            builder: (_, __) => const SavedAddressesScreen(),
          ),
          GoRoute(
            path: 'payments',
            builder: (_, __) => const PaymentMethodsScreen(),
          ),
          GoRoute(
            path: 'wallet',
            builder: (_, __) => const WalletHistoryScreen(),
            routes: [
              GoRoute(
                path: ':txId',
                builder: (_, state) => TransactionDetailsScreen(
                  txId: state.pathParameters['txId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'settings',
            builder: (_, __) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'help',
            builder: (_, __) => const HelpSupportScreen(),
          ),
          GoRoute(
            path: 'referral',
            builder: (_, __) => const ReferralProgramScreen(),
          ),
          GoRoute(
            path: 'subscription',
            builder: (_, __) => const SubscriptionScreen(),
          ),
          GoRoute(
            path: 'notifications',
            builder: (_, __) => const NotificationPreferencesScreen(),
          ),
          GoRoute(
            path: 'privacy',
            builder: (_, __) => const PrivacySettingsScreen(),
          ),
          GoRoute(
            path: 'language',
            builder: (_, __) => const LanguageScreen(),
          ),
          GoRoute(
            path: 'loyalty',
            builder: (_, __) => const LoyaltyProgramScreen(),
          ),
          GoRoute(
            path: 'emergency',
            builder: (_, __) => const EmergencyContactScreen(),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.ecoHub,
        builder: (_, __) => const EcoHubV2Screen(),
        routes: [
          GoRoute(
            path: 'impact',
            builder: (_, __) => const SustainabilityImpactScreen(),
          ),
          GoRoute(
            path: 'leaderboard',
            builder: (_, __) => const CommunityLeaderboardScreen(),
          ),
          GoRoute(
            path: 'rewards',
            builder: (_, __) => const EcoRewardsMarketplaceScreen(),
          ),
          GoRoute(
            path: 'carbon',
            builder: (_, __) => const CarbonCreditsMarketplaceScreen(),
          ),
          GoRoute(
            path: 'events',
            builder: (_, __) => const EcoEventsScreen(),
          ),
          GoRoute(
            path: 'smarthome',
            builder: (_, __) => const SmartHomeScreen(),
          ),
          GoRoute(
            path: 'calculator',
            builder: (_, __) => const EcoCalculatorScreen(),
          ),
          GoRoute(
            path: 'badges',
            builder: (_, __) => const EcoBadgesScreen(),
          ),
          GoRoute(
            path: 'challenges',
            builder: (_, __) => const EcoChallengesScreen(),
          ),
          GoRoute(
            path: 'offset',
            builder: (_, __) => const CarbonOffsetScreen(),
          ),
          GoRoute(
            path: 'news',
            builder: (_, __) => const EcoNewsScreen(),
          ),
        ],
      ),
      // ── New screens ──────────────────────────────────────────────────────
      GoRoute(
        path: '/promo',
        builder: (_, __) => const PromoBannerScreen(),
      ),
      GoRoute(
        path: '/service-map',
        builder: (_, __) => const ServiceMapScreen(),
      ),
      GoRoute(
        path: '/booking/:bookingId/cancel',
        builder: (_, state) => BookingCancelScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/booking/:bookingId/reschedule',
        builder: (_, state) => BookingRescheduleScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/service-reviews/:serviceId',
        builder: (_, state) => ServiceReviewListScreen(
          serviceId: state.pathParameters['serviceId']!,
        ),
      ),
      GoRoute(
        path: '/service-compare',
        builder: (_, __) => const ServiceComparisonScreen(),
      ),
      GoRoute(
        path: '/flash-deals',
        builder: (_, __) => const FlashDealsScreen(),
      ),
      GoRoute(
        path: '/how-it-works',
        builder: (_, __) => const HowItWorksScreen(),
      ),
      GoRoute(
        path: '/bundles',
        builder: (_, __) => const ServiceBundleScreen(),
      ),
      GoRoute(
        path: '/workers/nearby',
        builder: (_, __) => const NearbyWorkersScreen(),
      ),
      GoRoute(
        path: '/workers/availability',
        builder: (_, __) => const WorkerAvailabilityScreen(),
      ),
      GoRoute(
        path: '/service-history',
        builder: (_, __) => const ServiceHistoryScreen(),
      ),
      GoRoute(
        path: '/tour',
        builder: (_, __) => const AppTourScreen(),
      ),
      GoRoute(
        path: '/feedback',
        builder: (_, __) => const ServiceFeedbackScreen(),
      ),
      // ── 20 New Screens ───────────────────────────────────────────────────
      GoRoute(
        path: '/city',
        builder: (_, __) => const CitySelectorScreen(),
      ),
      GoRoute(
        path: '/package/:packageId',
        builder: (_, state) => ServicePackageDetailScreen(
          packageId: state.pathParameters['packageId']!,
        ),
      ),
      GoRoute(
        path: '/booking/:bookingId/invoice',
        builder: (_, state) => BookingInvoiceScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/eco/streak',
        builder: (_, __) => const EcoStreakScreen(),
      ),
      GoRoute(
        path: '/profile/addresses/add',
        builder: (_, __) => const AddressAddScreen(),
      ),
      GoRoute(
        path: '/providers',
        builder: (_, __) => const ServiceProviderScreen(),
      ),
      GoRoute(
        path: '/seasonal',
        builder: (_, __) => const SeasonalOffersScreen(),
      ),
      GoRoute(
        path: '/eco/trees',
        builder: (_, __) => const TreeTrackerScreen(),
      ),
      GoRoute(
        path: '/profile/security',
        builder: (_, __) => const AccountSecurityScreen(),
      ),
      GoRoute(
        path: '/services/faq',
        builder: (_, __) => const ServiceFaqScreen(),
      ),
      GoRoute(
        path: '/gift-cards',
        builder: (_, __) => const GiftCardScreen(),
      ),
      GoRoute(
        path: '/eco/report',
        builder: (_, __) => const EcoReportScreen(),
      ),
      GoRoute(
        path: '/services/subscribe',
        builder: (_, __) => const ServiceSubscriptionScreen(),
      ),
      GoRoute(
        path: '/profile/ticket',
        builder: (_, __) => const HelpTicketScreen(),
      ),
      GoRoute(
        path: '/referral/:code',
        builder: (_, state) => ReferralLandingScreen(
          code: state.pathParameters['code']!,
        ),
      ),
      GoRoute(
        path: '/services/:serviceId/checklist',
        builder: (_, state) => ServiceChecklistScreen(
          serviceId: state.pathParameters['serviceId']!,
        ),
      ),
      GoRoute(
        path: '/eco/volunteer',
        builder: (_, __) => const VolunteerScreen(),
      ),
      GoRoute(
        path: '/profile/data',
        builder: (_, __) => const DataExportScreen(),
      ),
      GoRoute(
        path: '/update',
        builder: (_, __) => const AppUpdateScreen(),
      ),
      GoRoute(
        path: '/services/:serviceId/rating',
        builder: (_, state) => ServiceRatingSummaryScreen(
          serviceId: state.pathParameters['serviceId']!,
        ),
      ),

      // ── Personalized screens ─────────────────────────────────────────────
      GoRoute(
        path: '/for-you',
        builder: (_, __) => const ForYouScreen(),
      ),
      GoRoute(
        path: '/home-profile',
        builder: (_, __) => const HomeProfileScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (_, __) => const PersonalizedDashboardScreen(),
      ),
      GoRoute(
        path: '/quick-rebook',
        builder: (_, __) => const QuickRebookScreen(),
      ),
      GoRoute(
        path: '/live',
        builder: (_, __) => const LiveActivityScreen(),
      ),
      GoRoute(
        path: '/request',
        builder: (_, __) => const ServiceRequestScreen(),
      ),
      GoRoute(
        path: '/booking/:bookingId/chat',
        builder: (_, state) => WorkerChatScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/booking/:bookingId/tip',
        builder: (_, state) => TipWorkerScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/booking/:bookingId/proof',
        builder: (_, state) => ServiceProofScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/booking/:bookingId/timeline',
        builder: (_, state) => BookingTimelineScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/booking/:bookingId/survey',
        builder: (_, state) => PostServiceSurveyScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/recurring',
        builder: (_, __) => const RecurringBookingsScreen(),
      ),
      GoRoute(
        path: '/promo-codes',
        builder: (_, __) => const PromoCodeScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (_, __) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/reminders',
        builder: (_, __) => const ServiceReminderScreen(),
      ),
      GoRoute(
        path: '/availability',
        builder: (_, __) => const ServiceAvailabilityCheckerScreen(),
      ),
      GoRoute(
        path: '/profile/wallet/topup',
        builder: (_, __) => const WalletTopupScreen(),
      ),
      GoRoute(
        path: '/profile/insights',
        builder: (_, __) => const SpendingInsightsScreen(),
      ),
      GoRoute(
        path: '/profile/achievements',
        builder: (_, __) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/eco/goals',
        builder: (_, __) => const EcoGoalsScreen(),
      ),

      // ── New v2 routes ────────────────────────────────────────────────────
      GoRoute(
        path: '/services/all',
        builder: (_, __) => const AllServicesScreen(),
      ),
      GoRoute(
        path: '/profile/complete',
        builder: (_, __) => const ProfileCompletionScreen(),
      ),
      GoRoute(
        path: '/services/:categoryId/:serviceId/detail',
        builder: (_, state) => ServiceDetailV2Screen(
          categoryId: state.pathParameters['categoryId']!,
          serviceId: state.pathParameters['serviceId']!,
        ),
      ),
    ],
  );
});

class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(Ref ref) {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
  }
}
