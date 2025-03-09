enum UserRole {
  admin,
  staff
}

extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.staff:
        return 'Staff';
    }
  }
}

class User {
  final int id;
  final String username;
  final String name;
  final UserRole role;
  final String? email;
  final String? token;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.role,
    this.email,
    this.token,
  });

  // Create a copy with updated values
  User copyWith({
    int? id,
    String? username,
    String? name,
    UserRole? role,
    String? email,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      role: role ?? this.role,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }

  // Convert User to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'role': role.index,
      'email': email,
      'token': token,
    };
  }

  // Create User from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      name: map['name'],
      role: UserRole.values[map['role']],
      email: map['email'],
      token: map['token'],
    );
  }
}