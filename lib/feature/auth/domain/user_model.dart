class UserModel {
  const UserModel({
    required this.name,
    required this.email,
  });

  final String name;
  final String email;

  UserModel copyWith({String? name, String? email}) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
