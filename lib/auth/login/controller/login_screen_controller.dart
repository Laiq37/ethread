
import 'package:ethread_app/home/ui/home_screen.dart';
import 'package:ethread_app/route/ui/route_screen.dart';
import 'package:ethread_app/services/client/base_client.dart';
import 'package:ethread_app/services/controller/base_controller.dart';
import 'package:ethread_app/services/models/login/login_response.dart';
import 'package:ethread_app/services/models/user/user.dart';
import 'package:ethread_app/utils/custom_widgets/cupertino_loader_dialog.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:ethread_app/utils/helpers/dart_functions.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class LoginScreenController{

  Future<void> login(String email,String password, BuildContext context) async{

    Get.dialog(const CupertinoLoaderDialog());

    var loginUserData = await BaseClient().post("auth/mobilelogin", {
      "email": email,
      "password": password,
    }).catchError(BaseController.handleError);

    if (loginUserData != null) {
      // Hide loader dialog
      Get.back();

      //Parsing login api response
      var data = loginResponseFromJson(loginUserData).data;

      final token = data.accessToken;
      final DateTime tokenExpiry = data.expiresAt;
      final String userType = data.type; 

      //Saves user token in local storage
      await DartFunctions.setUserToken(token, tokenExpiry, userType);

      //set user in local db
      await setUserDataToLocalDb(data.user);

      //Navigate to home screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Constants.userType == Constants.permenant ? const HomeScreen() : RouteScreen(routes: const[])));
    }
  }

  Future<void> setUserDataToLocalDb(User user) async {
    var usersBox = Hive.box<User>(Constants.userBox);

    //first clear all data from box
    await usersBox.clear();

    //Store updated data in user box
    await usersBox.put(Constants.userBox, user);
  }

}