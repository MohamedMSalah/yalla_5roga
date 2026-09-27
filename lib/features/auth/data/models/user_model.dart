import 'package:yalla_5roga/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.phone,
    super.email,
    super.token,
    super.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      token: json['token'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'token': token,
      'imageUrl': imageUrl,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      phone: user.phone,
      email: user.email,
      token: user.token,
      imageUrl: user.imageUrl,
    );
  }
}
