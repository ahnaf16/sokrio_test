import 'package:linkify/main.export.dart';

class User {
  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
  });

  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String image;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map.parseInt('id'),
      email: map['email'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      image: map['avatar'] ?? '',
    );
  }

  static User? tryParse(dynamic value) {
    try {
      if (value case final User u) return u;
      if (value case final Map map) return User.fromMap(map.toStringKey());
    } catch (e) {
      return null;
    }
    return null;
  }
}
