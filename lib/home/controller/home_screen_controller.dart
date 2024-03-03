import 'dart:convert';

import 'package:ethread_app/home/controller/vehicles_controller.dart';
import 'package:ethread_app/route/ui/route_screen.dart';
import 'package:ethread_app/services/client/base_client.dart';
import 'package:ethread_app/services/controller/base_controller.dart';
import 'package:ethread_app/services/models/route/route_model.dart';
import 'package:ethread_app/services/models/user/user.dart';
// import 'package:ethread_app/task/task_screen/ui/task_listing_screen.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class HomeScreenController{

  late Box<User> usersBox;

  ///Validate KM Dialog Field and then Navigate to TaskListingScreen
  void validateAndNavigate(BuildContext context, GlobalKey<FormState> formKey,String km, String vehicleId, index) async{
    if(!formKey.currentState!.validate())return Get.back();
      await openBox();
      String? driverId =  usersBox.get(Constants.userBox)?.id.toString();
      final routeRes = await getRouteId(driverId!,vehicleId,km);
      if(routeRes != null){

      // final int? routeId = routeRes['route_id'];
      // final int? driverRouteId = routeRes['driver_route_id'];
      final List<RouteModel> routeList = routeRes.map((route)=> RouteModel.fromJson(route)).toList();
      Get.back();
      final _controller = Get.find<VehiclesController>();
      _controller.selectedVehicleList[index] = false;
      _controller.selectedVehicleList.refresh();
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TaskListingScreen(routeId: routeId!, driverRouteId: driverRouteId!,)));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RouteScreen(routes: routeList)));
    }
      
  }

  Future<void> openBox() async{
    usersBox = Hive.box<User>(Constants.userBox);
  }

  Future<List<dynamic>?> getRouteId(String driverId,String vehicleId,String kilometers,) async {
    var response = await BaseClient().post("driver/startroute", {
      "driver_id": driverId,
      "vehicle_id": vehicleId,
      "kilometers": kilometers,
      "status": Constants.pendingStatus,
    }).catchError(BaseController.handleError);

    if (response != null) {

      return jsonDecode(response) ;
    } 
    else {
      // print("Something went wrong");
    }

    return null;
  }

}