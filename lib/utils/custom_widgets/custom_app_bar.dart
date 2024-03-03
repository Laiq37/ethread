import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:ethread_app/utils/custom_widgets/confirm_logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: CustomPadding.padding16H, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: () {},
              child: Image.asset(
                "assets/images/logo.png",
                width: CustomWidth.width200,
              )),
          Card(
              clipBehavior: Clip.hardEdge,
              elevation: 5,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CustomRadius.customRadius20)),
              child: InkWell(
                  onTap: () {
                    Get.dialog(const ConfirmLogoutDialog());
                  },
                  child:   Padding(
                    padding: EdgeInsets.symmetric(horizontal: CustomPadding.padding14W, vertical: CustomPadding.padding14H),
                    child: const Icon(
                      Icons.power_settings_new,
                    )
                  ))),
        ],
      ),
    );
  }
}
