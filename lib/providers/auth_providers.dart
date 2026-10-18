import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/data/models/models.dart';
import 'package:ecomins/data/mock/mock_data.dart';

/// `true` = logged in, `false` = logged out.
final authStateProvider = StateProvider<bool>((ref) => false);

/// The current logged-in user (in-memory).
final currentUserProvider = StateProvider<UserModel>((ref) => MockData.currentUser);

/// Convenience provider: returns the current user's uid when logged in.
final currentUidProvider = Provider<String?>((ref) {
  final isLoggedIn = ref.watch(authStateProvider);
  if (!isLoggedIn) return null;
  return ref.watch(currentUserProvider).uid;
});

/// Backwards-compat: screens that used userProvider(uid) can use this.
final userProvider = Provider.family<UserModel?, String>((ref, uid) {
  final isLoggedIn = ref.watch(authStateProvider);
  if (!isLoggedIn) return null;
  return ref.watch(currentUserProvider);
});

/// Backwards-compat: screens that used userRepositoryProvider.
final userRepositoryProvider = Provider<_UserService>((ref) => _UserService(ref));

class _UserService {
  _UserService(this._ref);
  final Ref _ref;

  Future<void> updateProfile(String uid, {String? name, String? email, String? avatarUrl}) async {
    final current = _ref.read(currentUserProvider);
    _ref.read(currentUserProvider.notifier).state = current.copyWith(
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );
  }
}
