class User {
  final int id;
  final String? email;
  final String name;
  final String? profileUrl;
  final int exp;

  User({
    required this.id,
    required this.name,
    this.email,
    this.profileUrl,
    required this.exp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileUrl: json['profileUrl'],
      exp: json['exp'],
    );
  }
}
