// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:ethread_app/services/models/user/user.dart';


LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.message,
    required this.data,
  });

  String message;
  Data data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.rememberMe,
    required this.user,
    required this.accessToken,
    required this.tokenType,
    required this.expiresAt,
    required this.type,
  });

  dynamic rememberMe;
  User user;
  String accessToken;
  String tokenType;
  DateTime expiresAt;
  String type;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    rememberMe: json["remember_me"],
    user: User.fromJson(json["user"]),
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresAt: DateTime.parse(json["expires_at"]),
    type: json['contract_type']
  );

  Map<String, dynamic> toJson() => {
    "remember_me": rememberMe,
    "user": user.toJson(),
    "access_token": accessToken,
    "token_type": tokenType,
    "expires_at": expiresAt.toIso8601String(),
  };
}
