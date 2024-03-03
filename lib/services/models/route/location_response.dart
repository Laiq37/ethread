
// To parse this JSON data, do
//
//     final location = locationFromJson(jsonString);

import 'dart:convert';

List<Location> locationFromJson(String str) => List<Location>.from(json.decode(str).map((x) => Location.fromJson(x)));

String locationToJson(List<Location> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Location {
  Location({
    required this.location,
  });

  LocationClass location;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    location: LocationClass.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
  };
}

class LocationClass {
  LocationClass({
    required this.id,
    required this.title,
    required this.address,
    required this.notes,
    required this.status,
    required this.binsCount,
  });

  int id;
  String title;
  String address;
  String notes;
  String status;
  int binsCount;

  factory LocationClass.fromJson(Map<String, dynamic> json) => LocationClass(
    id: json["id"],
    title: json["title"],
    address: json["address"],
    notes: json["notes"],
    status: json["status"],
    binsCount: json["bins_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "address": address,
    "notes": notes,
    "status": status,
    "bins_count": binsCount,
  };
}
