import 'package:ethread_app/task/service_screen/ui/task_service_screen.dart';
import 'package:ethread_app/task/task_screen/controller/task_listing_screen_controller.dart';
import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:ethread_app/utils/config/theme/theme_config.dart';
import 'package:ethread_app/utils/custom_widgets/cupertino_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskPendingNavButton extends StatelessWidget {
  final int numberOfBins;
  final int index;
  final int routeId;
  final int driverRouteId;
  final int id;
  final String title;
  final String address;
  const TaskPendingNavButton(
      {required this.numberOfBins,
      required this.index,
      required this.routeId,
      required this.driverRouteId,
      required this.id,
      required this.title,
      required this.address,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: numberOfBins == 0
          ? () => Get.dialog(CustomIosDialog(
              title: "Location ${index < 10 ? '0' : ''}$index",
              message: "No bin Added yet!"))
          : () {
              Get.find<TaskListingScreenController>().currentLocationId = id;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskServiceScreen(
                    routeId: routeId,
                    driverRouteId: driverRouteId,
                    locationId: id,
                    title: title,
                    address: address,
                    index: index,
                  ),
                ),
              );
            },
      child: Container(
        height: CustomHeight.height140,
        width: CustomWidth.width50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: <Color>[
              ThemeConfig().gradientDark,
              ThemeConfig().gradientLight
            ],
          ),
        ),
        child:
            const Icon(Icons.arrow_forward_ios, size: 24, color: Colors.white),
      ),
    );
  }
}
