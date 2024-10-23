import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.uid,
    required super.email,
    super.lastActive,
    super.isSessionValid,
  });

  factory UserModel.fromUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      lastActive: user.lastActive,
      isSessionValid: user.isSessionValid,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'lastActive': lastActive?.toIso8601String(),
      'isSessionValid': isSessionValid,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'])
          : null,
      isSessionValid: json['isSessionValid'] ?? true,
    );
  }
}
