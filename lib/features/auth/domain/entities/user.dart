class User {
  final String uid;
  final String email;
  final DateTime? lastActive;
  final bool isSessionValid;

  User({
    required this.uid,
    required this.email,
    this.lastActive,
    this.isSessionValid = true,
  });

  User copyWith({
    String? uid,
    String? email,
    DateTime? lastActive,
    bool? isSessionValid,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      lastActive: lastActive ?? this.lastActive,
      isSessionValid: isSessionValid ?? this.isSessionValid,
    );
  }
}
