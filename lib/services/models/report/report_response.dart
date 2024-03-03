// To parse this JSON data, do
//
//     final reportResponse = reportResponseFromJson(jsonString);

import 'dart:convert';

ReportResponse reportResponseFromJson(String str) => ReportResponse.fromJson(json.decode(str));

String reportResponseToJson(ReportResponse data) => json.encode(data.toJson());

class ReportResponse {
  ReportResponse({
    required this.data,
  });

  List<Datum> data;

  factory ReportResponse.fromJson(Map<String, dynamic> json) => ReportResponse(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.driverRouteId,
    required this.locationId,
    required this.binId,
    required this.serviceStartedAt,
    required this.serviceEndedAt,
    required this.binFilledStatus,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.date,
  });

  String driverRouteId;
  String locationId;
  String binId;
  DateTime serviceStartedAt;
  DateTime serviceEndedAt;
  String binFilledStatus;
  String status;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  DateTime date;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    driverRouteId: json["driver_route_id"],
    locationId: json["location_id"],
    binId: json["bin_id"],
    serviceStartedAt: DateTime.parse(json["service_started_at"]),
    serviceEndedAt: DateTime.parse(json["service_ended_at"]),
    binFilledStatus: json["bin_filled_status"],
    status: json["status"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    date: DateTime.parse(json["date"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "driver_route_id": driverRouteId,
    "location_id": locationId,
    "bin_id": binId,
    "service_started_at": serviceStartedAt.toIso8601String(),
    "service_ended_at": serviceEndedAt.toIso8601String(),
    "bin_filled_status": binFilledStatus,
    "status": status,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
