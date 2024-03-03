import 'dart:convert';

import 'package:ethread_app/services/client/base_client.dart';
import 'package:ethread_app/services/controller/base_controller.dart';
import 'package:ethread_app/utils/custom_widgets/cupertino_alert_dialog.dart';
import 'package:ethread_app/utils/custom_widgets/cupertino_loader_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController {

  Future<void> forgotPassword(String email, BuildContext context) async{

    Get.dialog(const CupertinoLoaderDialog());

    var response = await BaseClient().post("auth/forgotpassword", {
      "email": email,
    }).catchError(BaseController.handleError);

    if (response != null) {
      // Hide loader dialog
      Get.back();

      //Parsing forgot password api response
      Get.dialog(
          CustomIosDialog(
            title: "Forgot Password",
            message: "${jsonDecode(response)['message']}",
            callback: (){
              if (Get.isDialogOpen!) {
                Get.back();
              }
              Get.back();
            },
          ),
          barrierDismissible: false);

    }
  }
}