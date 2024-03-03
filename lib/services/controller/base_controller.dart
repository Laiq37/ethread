import 'dart:convert';

import 'package:ethread_app/auth/login/ui/login_screen.dart';
import 'package:ethread_app/services/exceptions/app_exceptions.dart';
import 'package:ethread_app/utils/custom_widgets/cupertino_alert_dialog.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:get/get.dart';

class BaseController {
  static void handleError(error) {
    if(Get.isDialogOpen ?? false){
      Get.back();
    }

    if (error is BadRequestException) {
      Get.dialog(
          CustomIosDialog(
            title: Constants.apFailureMessage,
            message: "${error.message}",
          ),
          barrierDismissible: false);
    } else if (error is FetchDataException) {
      Get.dialog(
          CustomIosDialog(
            title: Constants.apFailureMessage,
            message: "${error.message}",
          ),
          barrierDismissible: false);
    } else if (error is ApiNotRespondingException) {
      Get.dialog(
          CustomIosDialog(
            title: Constants.apFailureMessage,
            message: "${error.message}",
          ),
          barrierDismissible: false);
    } else if (error is UnAuthorizedException) {
      Get.dialog(
          CustomIosDialog(
            title: Constants.apFailureMessage,
            message: "${json.decode(error.message!)["errors"]["message"][0]}",
            callback: () {
                if (Get.isDialogOpen!) {
                  Get.back();
                }
                Get.offAll(const LoginScreen());
              },
          ),
          barrierDismissible: false);
    }
    else if (error is ValidationException) {
      Get.dialog(
          CustomIosDialog(
            title: Constants.apFailureMessage,
            message: "${jsonDecode(error.message!)['errors']['message'][0]}",
          ),
          barrierDismissible: false);
    }
  }
}
