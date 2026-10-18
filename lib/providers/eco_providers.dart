import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/data/models/models.dart';
import 'package:ecomins/data/mock/mock_data.dart';
import 'package:ecomins/providers/auth_providers.dart';

/// Returns the EcoProfile for the given uid (from mock current user).
final ecoProfileProvider = Provider.family<EcoProfile?, String>((ref, uid) {
  final isLoggedIn = ref.watch(authStateProvider);
  if (!isLoggedIn) return null;
  return ref.watch(currentUserProvider).ecoProfile;
});

/// Leaderboard entries (same list for all periods in mock).
final leaderboardProvider = Provider.family<List<LeaderboardEntry>, String>((ref, period) {
  return MockData.leaderboard;
});

/// All available eco rewards.
final rewardsProvider = Provider<List<EcoReward>>((ref) {
  return MockData.ecoRewards;
});

/// All carbon credit projects.
final carbonCreditsProvider = Provider<List<CarbonCredit>>((ref) {
  return MockData.carbonCredits;
});

/// All eco events.
final ecoEventsProvider = Provider<List<EcoEvent>>((ref) {
  return MockData.ecoEvents;
});

/// Eco repository (for reward redemption — in-memory).
final ecoRepositoryProvider = Provider<_EcoService>((ref) => _EcoService(ref));

class _EcoService {
  _EcoService(this._ref);
  final Ref _ref;

  Future<void> redeemReward(String uid, EcoReward reward) async {
    final current = _ref.read(currentUserProvider);
    if (current.ecoProfile.ecoPoints < reward.pointsCost) {
      throw StateError('Insufficient eco points.');
    }
    _ref.read(currentUserProvider.notifier).state = current.copyWith(
      ecoProfile: current.ecoProfile.copyWith(
        ecoPoints: current.ecoProfile.ecoPoints - reward.pointsCost,
      ),
    );
  }
}
