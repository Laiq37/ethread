import 'dart:convert';
import 'dart:io';

import 'package:ethread_app/auth/login/ui/login_screen.dart';
import 'package:ethread_app/home/controller/vehicles_controller.dart';
import 'package:ethread_app/route/controller/route_controller.dart';
import 'package:ethread_app/services/client/base_client.dart';
import 'package:ethread_app/services/controller/base_controller.dart';
import 'package:ethread_app/services/exceptions/app_exceptions.dart';
import 'package:ethread_app/services/models/bin/bin_report.dart';
import 'package:ethread_app/services/models/report/report.dart';
import 'package:ethread_app/services/models/report/report_response.dart';
import 'package:ethread_app/services/models/user/user.dart';
import 'package:ethread_app/task/service_screen/controller/bin_service_controller.dart';
import 'package:ethread_app/task/task_screen/controller/task_listing_screen_controller.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/config/font/font_size.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class DartFunctions {
  static void initControllers() {
    Get.lazyPut(() => VehiclesController());
    Get.lazyPut(() => RouteController());
    Get.lazyPut(() => TaskListingScreenController());
    Get.lazyPut(() => BinServiceController());
  }

  static void deleteFiles(List<String?> paths) async {
    for (var path in paths) {
      if (path == null) continue;
      final File file = File(path);
      final bool fileExist = await file.exists();
      if (!fileExist) continue;
      try {
        await file.delete();
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<bool?> binServing() async {
    final Box<Report> binReportsBox = Hive.box<Report>(Constants.reportsBox);
    bool? isBinServed;
    if (binReportsBox.isEmpty) return null;
    final List binReportsKey = binReportsBox.toMap().keys.toList();
    for (int index = 0; index < binReportsKey.length; index++) {
      final report = binReportsBox.get(binReportsKey[index].toString());
      List<Bin> servicedBins = report!.bins
          .where((element) =>
              element.lastPicture != null && element.isBinServed == false)
          .toList();
      if (servicedBins.isEmpty) {
        continue;
      }
      Report serviceReport = Report(
          driverRouteId: report.driverRouteId,
          locationId: report.locationId,
          bins: servicedBins);

      try {
        final response = await BaseClient()
            .binReportPostForm("driver/getbins", serviceReport.toJson());

        if (response != null) {
          isBinServed ??= true;

          reportResponseFromJson(response).data.forEach((completedBin) async {
            if (completedBin.status == Constants.completedStatus) {
              //Update binServiced to true in Reports local db
              //To make sure we don't send these bin to local db
              Bin currentBin = report.bins.firstWhere(
                  (element) => element.id.toString() == completedBin.binId && element.date == completedBin.date);
              report.bins.removeWhere(
                  (element) => element.id.toString() == completedBin.binId && element.date == completedBin.date);
              deleteFiles([currentBin.audio, currentBin.firstPicture, currentBin.lastPicture]);
            }
          });
          if (report.bins.isNotEmpty) {
            await binReportsBox.put(binReportsKey[index].toString(), report);
          } else {
            await binReportsBox.delete(binReportsKey[index].toString());
          }
        }
      } catch (error) {
        if (error is FetchDataException) {
          BaseController.handleError(error);
          return isBinServed;
        }
        BaseController.handleError(error);
      }
    }
    return isBinServed;
  }

  static Future<bool> refreshingTaskServiceUi(
      var binController, int locationId) async {
    return await binController.getBins(locationId).then((_) {
      return binController.totalBinServed == binController.binsList.length;
    });
  }

  static Future<List<dynamic>?> getRoutes(
    String driverId, [
    String? vehicleId,
    String? kilometers,
  ]) async {
    var response = await BaseClient().post("driver/startroute", {
      "driver_id": driverId,
      "vehicle_id": vehicleId,
      "kilometers": kilometers,
      "status": Constants.pendingStatus,
    }).catchError(BaseController.handleError);

    if (response != null) {
      return jsonDecode(response);
    } else {
      // print("Something went wrong");
    }

    return null;
  }

  static setUserToken(
      String token, DateTime tokenExpiry, String userType) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(Constants.token, token);
    preferences.setString(Constants.tokenExpiry, tokenExpiry.toIso8601String());
    preferences.setString(Constants.type, userType);
    Constants.userToken = token;
    Constants.userType = userType;
  }

  static Future<String> getUserTokenIfValid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString(Constants.tokenExpiry) != null &&
        DateTime.parse(preferences.getString(Constants.tokenExpiry)!)
            .isAfter(DateTime.now())) {
      Constants.userToken = preferences.getString(Constants.token)!;
      Constants.userType = preferences.getString(Constants.type)!;
    }
    return Constants.userToken;
  }

  static void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(Constants.token);
    preferences.remove(Constants.tokenExpiry);
    preferences.remove(Constants.type);
    Constants.userToken = "";
    Constants.userType = "";
    Box<User> usersBox = Hive.box<User>(Constants.userBox);
    await usersBox.clear();

    Get.offAll(() => const LoginScreen());
    Get.deleteAll();
    initControllers();
  }

  static Future<bool> isLoggedIn() async {
    String token = await getUserTokenIfValid();
    if (token.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static String getCurrentFormattedDate() {
    DateTime now = DateTime.now();
    var formatter = DateFormat(Constants.dateFormat);
    return formatter.format(now);
  }

  static String getCurrentFormattedTime() {
    DateTime now = DateTime.now();
    return DateFormat.jm().format(now);
  }

  static Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static bool isNum(String value){
    if(int.tryParse(value.trim()) == null)return false;
    return true;
  }

  static void showSnackBar(String message, String status) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      messageText: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: FontSize.font12,
          fontWeight: FontWeight.w400,
        ),
      ),
      titleText: Container(),
      margin: const EdgeInsets.only(
          bottom: kBottomNavigationBarHeight, left: 8, right: 8),
      padding: const EdgeInsets.only(bottom: 4, left: 16, right: 16),
      borderRadius: CustomRadius.customRadius4,
      backgroundColor: Colors.black54,
      colorText: Colors.white,
      mainButton: TextButton(
        child: Text(
          status,
          style: TextStyle(color: Colors.green[400]),
        ),
        onPressed: () {},
      ),
    );
  }

  static DateTime getCurrentDate(){
    final DateTime now = DateTime.now();
        return DateTime(now.year,now.month,now.day);
  }

}
