class User {
  final int id;
  final String username;
  final String password;

  User({required this.id, required this.username, required this.password});

  User copyWith({int? id, String? username, String? password}) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
