import 'package:ethread_app/utils/helpers/dart_functions.dart';
import 'package:hive/hive.dart';
import 'dart:convert';

part 'bin_report.g.dart';

List<Bin> binFromJson(String str) =>
    List<Bin>.from(json.decode(str).map((x) => Bin.fromJson(x)));

String binToJson(List<Bin> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 3)
class Bin {
  Bin({
    required this.id,
    this.startTime,
    this.endTime,
    this.firstPicture,
    this.lastPicture,
    this.audio,
    this.finalComments,
    this.status,
    this.binFilledStatus,
    this.title,
    this.driverMessage,
    this.isActive,
    this.barcodeNum,
    this.isBinScanned = false,
    this.isBinServed = false,
    this.date,
  });

  @HiveField(3)
  int id;
  @HiveField(4)
  String? startTime;
  @HiveField(5)
  String? endTime;
  @HiveField(6)
  String? firstPicture;
  @HiveField(7)
  String? lastPicture;
  @HiveField(8)
  String? audio;
  @HiveField(9)
  String? finalComments;
  @HiveField(10)
  String? status;
  @HiveField(11)
  String? binFilledStatus;
  @HiveField(12, defaultValue: false)
  bool isBinScanned;
  @HiveField(13)
  String? title;
  @HiveField(14)
  String? driverMessage;
  @HiveField(15, defaultValue: false)
  bool? isActive;
  @HiveField(16)
  String? barcodeNum;
  @HiveField(17, defaultValue: false)
  bool isBinServed;
  @HiveField(18)
  DateTime? date;

  factory Bin.fromJson(Map<String, dynamic> json) =>
     Bin(
      id: json["id"],
      startTime: json["start_time"],
      endTime: json["end_time"],
      firstPicture: json["first_picture"],
      lastPicture: json["last_picture"],
      audio: json["audio"],
      finalComments: json["final_comments"],
      status: json["binStatus"] == false ? "pending" : "completed",
      binFilledStatus: json["bin_filled_status"],
      title: json["title"],
      driverMessage: json["driver_message"],
      isActive: json["is_active"],
      barcodeNum: json["barcodenum"],
      isBinScanned: json["binStatus"] == "completed" ? true : false,
      isBinServed: json["binStatus"] == "completed" ? true : false,
      date:DartFunctions.getCurrentDate(),
    );
  

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_time": startTime,
        "end_time": endTime,
        "first_picture": firstPicture,
        "last_picture": lastPicture,
        "audio": audio,
        "final_comments": finalComments,
        "bin_filled_status": binFilledStatus,
        "status": status,
        "title": title,
        "driver_message": driverMessage,
        "is_active": isActive,
        "barcodenum": barcodeNum,
        "is_bin_served": isBinServed
      };
}
