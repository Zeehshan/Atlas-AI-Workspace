import 'package:shared_contracts/shared_contracts.dart';

class AuthenticatedUser {
  const AuthenticatedUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.roles,
    required this.sessionId,
  });

  final String id;
  final String email;
  final String displayName;
  final List<String> roles;
  final String sessionId;

  UserProfile toUserProfile() {
    return UserProfile(
      id: id,
      email: email,
      displayName: displayName,
      roles: roles,
    );
  }

  Map<String, Object?> toContextMap() {
    return {'uid': id, 'email': email, 'roles': roles, 'sessionId': sessionId};
  }
}
