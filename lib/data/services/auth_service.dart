/// Simple in-memory auth service (no Firebase).
/// Authentication is handled directly via authStateProvider in providers/auth_providers.dart.
class AuthService {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> signIn() async {
    _isLoggedIn = true;
  }

  Future<void> signOut() async {
    _isLoggedIn = false;
  }
}
