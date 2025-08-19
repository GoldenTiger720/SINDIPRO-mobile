import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String email;
  final String? username;
  final String role; // 'caretaker' or 'manager'
  final String? condominium; // Only for caretakers - their specific building

  const User({
    required this.id,
    required this.email,
    this.username,
    required this.role,
    this.condominium,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  bool get isCaretaker => role == 'caretaker';
  bool get isManager => role == 'manager';

  User copyWith({
    int? id,
    String? email,
    String? username,
    String? role,
    String? condominium,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      role: role ?? this.role,
      condominium: condominium ?? this.condominium,
    );
  }
}

@JsonSerializable()
class LoginResponse {
  final String access;
  final String refresh;
  final User user;

  const LoginResponse({
    required this.access,
    required this.refresh,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class RegisterResponse {
  final String access;
  final String refresh;
  final User user;

  const RegisterResponse({
    required this.access,
    required this.refresh,
    required this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => _$RegisterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}