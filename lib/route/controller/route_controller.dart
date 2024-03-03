import 'dart:convert';

import 'package:ethread_app/services/client/base_client.dart';
import 'package:ethread_app/services/controller/base_controller.dart';
import 'package:ethread_app/services/models/route/route_model.dart';
import 'package:ethread_app/services/models/user/user.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';

class RouteController extends GetxController {
  RxBool isLoading = false.obs;

  late int currentRouteId;

  late int currentDriverRouteId;

  late Box<User> usersBox;

  List<RouteModel> routeList = [];
  Future<List<dynamic>> getRoutes() async {
    isLoading.value = true;
    await openBox();
    routeList.clear();
    final String? driverId = usersBox.get(Constants.userBox)?.id.toString();

    var response = await BaseClient().post("driver/startroute", {
      "driver_id": driverId!,
      "status": Constants.pendingStatus,
    }).catchError(BaseController.handleError);

    if (response != null) {
      var routeRes = jsonDecode(response);

      routeList = [
        ...routeRes.map((route) => RouteModel.fromJson(route)).toList()
      ];

      return routeList;
    } else {
      // print("Something went wrong");
    }

    return routeList;
  }

  Future<void> openBox() async {
    usersBox = Hive.box<User>(Constants.userBox);
  }
}
