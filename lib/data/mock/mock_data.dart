import '../models/models.dart';
import '../models/personalization_models.dart';

class MockData {
  MockData._();

  // ── Promo Codes ───────────────────────────────────────────────────────────

  static const List<PromoCode> promoCodes = [
    PromoCode(
      code: 'ECO20',
      description: '20% off on all eco services',
      discountPercent: 20,
      maxDiscount: 200,
    ),
    PromoCode(
      code: 'FIRST50',
      description: '₹50 off on first booking',
      discountPercent: 0,
      maxDiscount: 50,
    ),
    PromoCode(
      code: 'GREEN30',
      description: '30% off on recycling services',
      discountPercent: 30,
      maxDiscount: 150,
    ),
  ];

  // ── Recurring Bookings ────────────────────────────────────────────────────

  static final List<RecurringBooking> recurringBookings = [
    const RecurringBooking(
      id: 'rb_001',
      serviceId: 'cleaning_basic',
      serviceName: 'Home Cleaning',
      serviceIcon: '🧹',
      frequency: 'weekly',
      nextDate: 'Every Monday',
      amount: 449,
      isActive: true,
    ),
    const RecurringBooking(
      id: 'rb_002',
      serviceId: 'garbage_daily',
      serviceName: 'Garbage Pickup',
      serviceIcon: '🗑️',
      frequency: 'daily',
      nextDate: 'Every day 8AM',
      amount: 99,
      isActive: true,
    ),
  ];

  // ── Service Categories ────────────────────────────────────────────────────

  static const List<ServiceCategory> categories = [
    ServiceCategory(id: 'cleaning', name: 'Cleaning', iconAsset: '🧹', color: '#3FE56C'),
    ServiceCategory(id: 'garbage', name: 'Garbage', iconAsset: '🗑️', color: '#FF8D81'),
    ServiceCategory(id: 'recycling', name: 'Recycling', iconAsset: '♻️', color: '#3FE56C'),
    ServiceCategory(id: 'bulk_pickup', name: 'Bulk Pickup', iconAsset: '🚛', color: '#BBCBB8'),
    ServiceCategory(id: 'deep_clean', name: 'Deep Clean', iconAsset: '🧴', color: '#3FE56C'),
    ServiceCategory(id: 'garden', name: 'Garden', iconAsset: '🌱', color: '#3FE56C'),
    ServiceCategory(id: 'sweeper', name: 'Sweeper', iconAsset: '🧺', color: '#BBCBB8'),
    ServiceCategory(id: 'homeguard', name: 'HomeGuard', iconAsset: '🏠', color: '#3FE56C'),
  ];

  // ── Services by Category ──────────────────────────────────────────────────

  static final Map<String, List<ServiceModel>> servicesByCategory = {
    'cleaning': [
      const ServiceModel(
        id: 'cleaning_basic',
        categoryId: 'cleaning',
        name: 'Basic Home Cleaning',
        description: 'Standard cleaning of all rooms including dusting, mopping, and vacuuming.',
        iconAsset: '🧹',
        basePrice: 299,
        unit: 'visit',
        avgRating: 4.7,
        totalBookings: 1240,
        isEcoFriendly: true,
        ecoPointsEarned: 20,
        packages: [
          ServicePackage(id: 'c1', name: '1 BHK', description: '1 bedroom home', price: 299, duration: 60),
          ServicePackage(id: 'c2', name: '2 BHK', description: '2 bedroom home', price: 449, duration: 90),
          ServicePackage(id: 'c3', name: '3 BHK', description: '3 bedroom home', price: 599, duration: 120),
        ],
      ),
      const ServiceModel(
        id: 'cleaning_kitchen',
        categoryId: 'cleaning',
        name: 'Kitchen Deep Clean',
        description: 'Thorough cleaning of kitchen including appliances, cabinets, and countertops.',
        iconAsset: '🍳',
        basePrice: 399,
        unit: 'visit',
        avgRating: 4.8,
        totalBookings: 890,
        isEcoFriendly: true,
        ecoPointsEarned: 25,
        packages: [
          ServicePackage(id: 'k1', name: 'Standard', description: 'Basic kitchen clean', price: 399, duration: 60),
          ServicePackage(id: 'k2', name: 'Premium', description: 'Deep clean with appliances', price: 599, duration: 90),
        ],
      ),
    ],
    'garbage': [
      const ServiceModel(
        id: 'garbage_daily',
        categoryId: 'garbage',
        name: 'Daily Garbage Pickup',
        description: 'Daily collection of household waste with eco-friendly disposal.',
        iconAsset: '🗑️',
        basePrice: 99,
        unit: 'day',
        avgRating: 4.6,
        totalBookings: 3200,
        isEcoFriendly: true,
        ecoPointsEarned: 15,
        packages: [
          ServicePackage(id: 'g1', name: 'Weekly', description: '7 days pickup', price: 499, duration: 10),
          ServicePackage(id: 'g2', name: 'Monthly', description: '30 days pickup', price: 1499, duration: 10),
        ],
      ),
      const ServiceModel(
        id: 'garbage_segregation',
        categoryId: 'garbage',
        name: 'Waste Segregation',
        description: 'Professional waste segregation into dry, wet, and hazardous categories.',
        iconAsset: '♻️',
        basePrice: 149,
        unit: 'visit',
        avgRating: 4.9,
        totalBookings: 560,
        isEcoFriendly: true,
        ecoPointsEarned: 30,
        packages: [
          ServicePackage(id: 'ws1', name: 'Basic', description: 'Dry/wet segregation', price: 149, duration: 30),
          ServicePackage(id: 'ws2', name: 'Full', description: 'All categories', price: 249, duration: 45),
        ],
      ),
    ],
    'recycling': [
      const ServiceModel(
        id: 'recycling_paper',
        categoryId: 'recycling',
        name: 'Paper & Cardboard Recycling',
        description: 'Collection and recycling of paper, newspapers, and cardboard boxes.',
        iconAsset: '📦',
        basePrice: 0,
        unit: 'kg',
        avgRating: 4.8,
        totalBookings: 2100,
        isEcoFriendly: true,
        ecoPointsEarned: 50,
        packages: [
          ServicePackage(id: 'r1', name: 'Pickup', description: 'We collect from your door', price: 0, duration: 15),
        ],
      ),
      const ServiceModel(
        id: 'recycling_ewaste',
        categoryId: 'recycling',
        name: 'E-Waste Recycling',
        description: 'Safe disposal of electronic waste including phones, laptops, and batteries.',
        iconAsset: '💻',
        basePrice: 49,
        unit: 'item',
        avgRating: 4.7,
        totalBookings: 780,
        isEcoFriendly: true,
        ecoPointsEarned: 100,
        packages: [
          ServicePackage(id: 'ew1', name: 'Small', description: 'Phones, tablets', price: 49, duration: 15),
          ServicePackage(id: 'ew2', name: 'Large', description: 'Laptops, TVs', price: 99, duration: 20),
        ],
      ),
    ],
    'bulk_pickup': [
      const ServiceModel(
        id: 'bulk_furniture',
        categoryId: 'bulk_pickup',
        name: 'Furniture Removal',
        description: 'Removal and eco-friendly disposal of old furniture and large items.',
        iconAsset: '🛋️',
        basePrice: 499,
        unit: 'item',
        avgRating: 4.5,
        totalBookings: 340,
        isEcoFriendly: false,
        ecoPointsEarned: 10,
        packages: [
          ServicePackage(id: 'bf1', name: 'Single', description: '1 large item', price: 499, duration: 60),
          ServicePackage(id: 'bf2', name: 'Multiple', description: 'Up to 5 items', price: 1299, duration: 120),
        ],
      ),
    ],
    'deep_clean': [
      const ServiceModel(
        id: 'deep_full',
        categoryId: 'deep_clean',
        name: 'Full Home Deep Clean',
        description: 'Comprehensive deep cleaning of entire home including hard-to-reach areas.',
        iconAsset: '🧴',
        basePrice: 799,
        unit: 'visit',
        avgRating: 4.9,
        totalBookings: 620,
        isEcoFriendly: true,
        ecoPointsEarned: 40,
        packages: [
          ServicePackage(id: 'dc1', name: '1 BHK', description: 'Full deep clean', price: 799, duration: 180),
          ServicePackage(id: 'dc2', name: '2 BHK', description: 'Full deep clean', price: 1199, duration: 240),
          ServicePackage(id: 'dc3', name: '3 BHK', description: 'Full deep clean', price: 1599, duration: 300),
        ],
      ),
    ],
    'garden': [
      const ServiceModel(
        id: 'garden_maintenance',
        categoryId: 'garden',
        name: 'Garden Maintenance',
        description: 'Regular garden upkeep including mowing, pruning, and watering.',
        iconAsset: '🌱',
        basePrice: 349,
        unit: 'visit',
        avgRating: 4.7,
        totalBookings: 450,
        isEcoFriendly: true,
        ecoPointsEarned: 35,
        packages: [
          ServicePackage(id: 'gm1', name: 'Basic', description: 'Mowing & watering', price: 349, duration: 60),
          ServicePackage(id: 'gm2', name: 'Full', description: 'All garden tasks', price: 599, duration: 120),
        ],
      ),
    ],
    'sweeper': [
      const ServiceModel(
        id: 'sweeper_daily',
        categoryId: 'sweeper',
        name: 'Daily Sweeping',
        description: 'Daily sweeping and mopping of floors and common areas.',
        iconAsset: '🧺',
        basePrice: 149,
        unit: 'day',
        avgRating: 4.6,
        totalBookings: 1800,
        isEcoFriendly: false,
        ecoPointsEarned: 10,
        packages: [
          ServicePackage(id: 'sw1', name: 'Weekly', description: '7 days', price: 799, duration: 30),
          ServicePackage(id: 'sw2', name: 'Monthly', description: '30 days', price: 2499, duration: 30),
        ],
      ),
    ],
    'homeguard': [
      const ServiceModel(
        id: 'homeguard_basic',
        categoryId: 'homeguard',
        name: 'Home Security Check',
        description: 'Professional security inspection and monitoring of your home.',
        iconAsset: '🏠',
        basePrice: 599,
        unit: 'visit',
        avgRating: 4.8,
        totalBookings: 280,
        isEcoFriendly: false,
        ecoPointsEarned: 10,
        packages: [
          ServicePackage(id: 'hg1', name: 'Basic', description: 'Security check', price: 599, duration: 60),
          ServicePackage(id: 'hg2', name: 'Premium', description: 'Full inspection', price: 999, duration: 120),
        ],
      ),
    ],
  };

  // ── Current User ──────────────────────────────────────────────────────────

  static UserModel currentUser = const UserModel(
    uid: 'mock_user_001',
    name: 'Arjun Sharma',
    phone: '9876543210',
    email: 'arjun.sharma@example.com',
    savedAddresses: [
      Address(
        id: 'addr_1',
        label: 'Home',
        fullAddress: '42, 5th Cross, Koramangala, Bangalore - 560034',
        latitude: 12.9352,
        longitude: 77.6245,
      ),
      Address(
        id: 'addr_2',
        label: 'Office',
        fullAddress: '100, MG Road, Bangalore - 560001',
        latitude: 12.9716,
        longitude: 77.5946,
      ),
    ],
    ecoProfile: EcoProfile(
      ecoPoints: 1250,
      carbonCredits: 5,
      co2SavedKg: 34.5,
      leaderboardRank: 12,
      badges: ['🌱 Eco Starter', '♻️ Recycler', '🏆 Top 50'],
    ),
    wallet: WalletInfo(balance: 500.0, currency: 'INR'),
  );

  // ── Workers ───────────────────────────────────────────────────────────────

  static const List<WorkerModel> workers = [
    WorkerModel(
      id: 'worker_001',
      name: 'Ravi Kumar',
      avatarEmoji: '👨',
      phone: '9123456789',
      serviceIds: ['cleaning_basic', 'cleaning_kitchen', 'deep_full'],
      rating: 4.9,
      totalJobs: 342,
      status: WorkerStatus.available,
      certifications: ['Eco Certified', 'Background Verified'],
      ecoScore: 92.5,
    ),
    WorkerModel(
      id: 'worker_002',
      name: 'Priya Devi',
      avatarEmoji: '👩',
      phone: '9234567890',
      serviceIds: ['garbage_daily', 'garbage_segregation', 'recycling_paper'],
      rating: 4.8,
      totalJobs: 218,
      status: WorkerStatus.available,
      certifications: ['Waste Management Certified'],
      ecoScore: 88.0,
    ),
    WorkerModel(
      id: 'worker_003',
      name: 'Suresh Babu',
      avatarEmoji: '👨',
      phone: '9345678901',
      serviceIds: ['garden_maintenance', 'sweeper_daily'],
      rating: 4.7,
      totalJobs: 156,
      status: WorkerStatus.available,
      certifications: ['Horticulture Certified'],
      ecoScore: 85.0,
    ),
  ];

  // ── Bookings ──────────────────────────────────────────────────────────────

  static List<BookingModel> bookings = [
    BookingModel(
      id: 'booking_001',
      userId: 'mock_user_001',
      serviceId: 'cleaning_basic',
      serviceName: 'Basic Home Cleaning',
      serviceIcon: '🧹',
      workerId: 'worker_001',
      status: BookingStatus.completed,
      serviceAddress: const Address(
        id: 'addr_1',
        label: 'Home',
        fullAddress: '42, 5th Cross, Koramangala, Bangalore - 560034',
        latitude: 12.9352,
        longitude: 77.6245,
      ),
      scheduledAt: DateTime.now().subtract(const Duration(days: 3)),
      completedAt: DateTime.now().subtract(const Duration(days: 3, hours: -2)),
      totalAmount: 449,
      paymentMethod: 'upi',
      rating: 5.0,
      review: 'Excellent service! Very thorough.',
      scheduleConfig: const ScheduleConfig(type: ScheduleType.immediate),
    ),
    BookingModel(
      id: 'booking_002',
      userId: 'mock_user_001',
      serviceId: 'garbage_daily',
      serviceName: 'Daily Garbage Pickup',
      serviceIcon: '🗑️',
      workerId: 'worker_002',
      status: BookingStatus.workerAssigned,
      serviceAddress: const Address(
        id: 'addr_1',
        label: 'Home',
        fullAddress: '42, 5th Cross, Koramangala, Bangalore - 560034',
        latitude: 12.9352,
        longitude: 77.6245,
      ),
      scheduledAt: DateTime.now().add(const Duration(hours: 1)),
      totalAmount: 499,
      paymentMethod: 'wallet',
      scheduleConfig: const ScheduleConfig(type: ScheduleType.scheduled),
    ),
  ];

  // ── Eco Rewards ───────────────────────────────────────────────────────────

  static final List<EcoReward> ecoRewards = [
    EcoReward(
      id: 'reward_001',
      title: '₹100 Zomato Voucher',
      description: 'Get ₹100 off on your next Zomato order.',
      imageEmoji: '🍕',
      pointsCost: 500,
      type: RewardType.voucher,
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    ),
    EcoReward(
      id: 'reward_002',
      title: 'Plant a Tree',
      description: 'We plant a tree in your name in a local forest.',
      imageEmoji: '🌳',
      pointsCost: 200,
      type: RewardType.donation,
      expiresAt: DateTime.now().add(const Duration(days: 365)),
    ),
    EcoReward(
      id: 'reward_003',
      title: 'Eco Tote Bag',
      description: 'Reusable organic cotton tote bag delivered to your door.',
      imageEmoji: '👜',
      pointsCost: 800,
      type: RewardType.product,
      expiresAt: DateTime.now().add(const Duration(days: 60)),
    ),
    EcoReward(
      id: 'reward_004',
      title: 'Composting Workshop',
      description: 'Free entry to a 2-hour composting workshop.',
      imageEmoji: '🌿',
      pointsCost: 300,
      type: RewardType.experience,
      expiresAt: DateTime.now().add(const Duration(days: 14)),
    ),
    EcoReward(
      id: 'reward_005',
      title: '₹200 Amazon Voucher',
      description: 'Get ₹200 off on eco-friendly products on Amazon.',
      imageEmoji: '🛒',
      pointsCost: 1000,
      type: RewardType.voucher,
      expiresAt: DateTime.now().add(const Duration(days: 45)),
    ),
    EcoReward(
      id: 'reward_006',
      title: 'Solar Charger',
      description: 'Portable solar-powered phone charger.',
      imageEmoji: '☀️',
      pointsCost: 2000,
      type: RewardType.product,
      expiresAt: DateTime.now().add(const Duration(days: 90)),
    ),
  ];

  // ── Carbon Credits ────────────────────────────────────────────────────────

  static const List<CarbonCredit> carbonCredits = [
    CarbonCredit(
      id: 'cc_001',
      projectName: 'Western Ghats Reforestation',
      description: 'Planting native trees in the Western Ghats to restore biodiversity and sequester carbon.',
      priceInr: 1500,
      co2TonnesOffset: 1.0,
      verificationStandard: 'VCS',
    ),
    CarbonCredit(
      id: 'cc_002',
      projectName: 'Solar Village Initiative',
      description: 'Installing solar panels in rural villages to replace diesel generators.',
      priceInr: 2000,
      co2TonnesOffset: 1.5,
      verificationStandard: 'Gold Standard',
    ),
    CarbonCredit(
      id: 'cc_003',
      projectName: 'Mangrove Conservation',
      description: 'Protecting and restoring mangrove ecosystems along the Indian coastline.',
      priceInr: 1200,
      co2TonnesOffset: 0.8,
      verificationStandard: 'Plan Vivo',
    ),
  ];

  // ── Leaderboard ───────────────────────────────────────────────────────────

  static const List<LeaderboardEntry> leaderboard = [
    LeaderboardEntry(userId: 'u1', displayName: 'Meera Nair', ecoPoints: 4200, rank: 1, badge: '🥇 Eco Champion'),
    LeaderboardEntry(userId: 'u2', displayName: 'Vikram Singh', ecoPoints: 3800, rank: 2, badge: '🥈 Green Hero'),
    LeaderboardEntry(userId: 'u3', displayName: 'Ananya Patel', ecoPoints: 3500, rank: 3, badge: '🥉 Eco Warrior'),
    LeaderboardEntry(userId: 'u4', displayName: 'Rahul Gupta', ecoPoints: 2900, rank: 4, badge: '🌿 Eco Enthusiast'),
    LeaderboardEntry(userId: 'u5', displayName: 'Sneha Reddy', ecoPoints: 2600, rank: 5, badge: '🌿 Eco Enthusiast'),
    LeaderboardEntry(userId: 'u6', displayName: 'Karthik Iyer', ecoPoints: 2300, rank: 6, badge: '🌱 Eco Starter'),
    LeaderboardEntry(userId: 'u7', displayName: 'Divya Menon', ecoPoints: 2100, rank: 7, badge: '🌱 Eco Starter'),
    LeaderboardEntry(userId: 'u8', displayName: 'Arun Krishnan', ecoPoints: 1900, rank: 8, badge: '🌱 Eco Starter'),
    LeaderboardEntry(userId: 'u9', displayName: 'Pooja Sharma', ecoPoints: 1700, rank: 9, badge: '🌱 Eco Starter'),
    LeaderboardEntry(userId: 'u10', displayName: 'Nikhil Joshi', ecoPoints: 1500, rank: 10, badge: '🌱 Eco Starter'),
    LeaderboardEntry(userId: 'u11', displayName: 'Lakshmi Rao', ecoPoints: 1400, rank: 11, badge: '🌱 Eco Starter'),
    LeaderboardEntry(userId: 'mock_user_001', displayName: 'Arjun Sharma', ecoPoints: 1250, rank: 12, badge: '🏆 Top 50'),
  ];

  // ── Notifications ─────────────────────────────────────────────────────────

  static List<NotificationItem> notifications = [
    NotificationItem(
      id: 'notif_001',
      title: 'Booking Confirmed! 🎉',
      body: 'Your cleaning service has been confirmed for today.',
      type: NotificationType.bookingUpdate,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      targetRoute: '/orders',
    ),
    NotificationItem(
      id: 'notif_002',
      title: 'Eco Milestone Reached! 🌱',
      body: 'You\'ve saved 30kg of CO₂! Keep up the great work.',
      type: NotificationType.ecoMilestone,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      targetRoute: '/eco/impact',
    ),
    NotificationItem(
      id: 'notif_003',
      title: 'New Badge Earned! 🏆',
      body: 'You\'ve earned the "Recycler" badge for recycling 10 times.',
      type: NotificationType.badge,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      targetRoute: '/eco',
    ),
    NotificationItem(
      id: 'notif_004',
      title: 'Worker Assigned',
      body: 'Ravi Kumar has been assigned to your booking.',
      type: NotificationType.bookingUpdate,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      targetRoute: '/orders',
    ),
    NotificationItem(
      id: 'notif_005',
      title: 'Special Offer! 🎁',
      body: 'Get 20% off on your next deep cleaning service this weekend.',
      type: NotificationType.general,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // ── Transactions ─────────────────────────────────────────────────────────

  static final List<Map<String, dynamic>> transactions = [
    {'id': 'TXN-001', 'type': 'credit', 'amount': 450.0, 'description': 'Recycling Pickup Reward', 'date': '24 Oct 2024', 'co2': 12.4},
    {'id': 'TXN-002', 'type': 'debit', 'amount': 249.0, 'description': 'Home Cleaning Payment', 'date': '22 Oct 2024', 'co2': 0.0},
    {'id': 'TXN-003', 'type': 'credit', 'amount': 200.0, 'description': 'Referral Bonus', 'date': '20 Oct 2024', 'co2': 0.0},
    {'id': 'TXN-004', 'type': 'debit', 'amount': 149.0, 'description': 'Garbage Collection', 'date': '18 Oct 2024', 'co2': 0.0},
    {'id': 'TXN-005', 'type': 'credit', 'amount': 320.0, 'description': 'Bulk Pickup Reward', 'date': '15 Oct 2024', 'co2': 8.2},
  ];

  // ── Payment Methods ───────────────────────────────────────────────────────

  static const List<Map<String, dynamic>> paymentMethods = [
    {'id': 'pm1', 'type': 'card', 'name': 'Visa Card', 'last4': '4242', 'isDefault': true},
    {'id': 'pm2', 'type': 'upi', 'name': 'UPI', 'handle': 'arjun@upi', 'isDefault': false},
    {'id': 'pm3', 'type': 'wallet', 'name': 'Ecomins Wallet', 'balance': 500.0, 'isDefault': false},
  ];

  // ── Eco Events ────────────────────────────────────────────────────────────

  static final List<EcoEvent> ecoEvents = [
    EcoEvent(
      id: 'event_001',
      title: 'Community Clean-Up Drive',
      description: 'Join us for a neighbourhood clean-up event. Earn 200 eco points!',
      emoji: '🧹',
      location: 'Cubbon Park, Bangalore',
      startDate: DateTime.now().add(const Duration(days: 5)),
      ecoPointsReward: 200,
    ),
    EcoEvent(
      id: 'event_002',
      title: 'Zero Waste Workshop',
      description: 'Learn practical tips to reduce household waste to near zero.',
      emoji: '♻️',
      location: 'Online',
      startDate: DateTime.now().add(const Duration(days: 3)),
      ecoPointsReward: 100,
      isOnline: true,
    ),
    EcoEvent(
      id: 'event_003',
      title: 'Tree Plantation Drive',
      description: 'Plant trees in Bannerghatta National Park with our eco team.',
      emoji: '🌳',
      location: 'Bannerghatta, Bangalore',
      startDate: DateTime.now().add(const Duration(days: 10)),
      ecoPointsReward: 300,
    ),
  ];
}
