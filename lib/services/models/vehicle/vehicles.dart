// To parse this JSON data, do
//
//     final vehicles = vehiclesFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';

part 'vehicles.g.dart';


List<Vehicles> vehiclesFromJson(String str) => List<Vehicles>.from(json.decode(str).map((x) => Vehicles.fromJson(x)));

String vehiclesToJson(List<Vehicles> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 0)
class Vehicles extends HiveObject{
  Vehicles({
    required this.id,
    required this.registrationNumber,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @HiveField(0)
  int id;
  @HiveField(1)
  String registrationNumber;
  @HiveField(2)
  bool isActive;
  @HiveField(3)
  DateTime createdAt;
  @HiveField(4)
  DateTime updatedAt;

  factory Vehicles.fromJson(Map<String, dynamic> json) => Vehicles(
    id: json["id"],
    registrationNumber: json["registration_number"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "registration_number": registrationNumber,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
