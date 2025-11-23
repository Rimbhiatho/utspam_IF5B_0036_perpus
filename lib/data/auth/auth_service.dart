class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  int? currentUserId;

  bool get isLoggedIn => currentUserId != null;

  void signIn(int userId) {
    currentUserId = userId;
  }

  void signOut() {
    currentUserId = null;
  }
}
