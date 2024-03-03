// To parse this JSON data, do
//
//     final report = reportFromJson(jsonString);

import 'dart:convert';

import 'package:ethread_app/services/models/bin/bin_report.dart';
import 'package:hive/hive.dart';

part 'report.g.dart';

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

@HiveType(typeId: 2)
class Report {
  Report({
    required this.driverRouteId,
    required this.locationId,
    required this.bins,
  });

  @HiveField(0)
  String driverRouteId;
  @HiveField(1)
  String locationId;
  @HiveField(2)
  List<Bin> bins;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    driverRouteId: json["driver_route_id"],
    locationId: json["location_id"],
    bins: List<Bin>.from(json["bin"].map((x) => Bin.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "driver_route_id": driverRouteId,
    "location_id": locationId,
    "bins": List<dynamic>.from(bins.map((x) => x.toJson())),
  };

}
