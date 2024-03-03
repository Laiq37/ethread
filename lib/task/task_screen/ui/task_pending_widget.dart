import 'package:ethread_app/task/task_screen/ui/task_done_start_widget.dart';
import 'package:ethread_app/task/task_screen/ui/task_location_address_widget.dart';
import 'package:ethread_app/task/task_screen/ui/task_location_num_widget.dart';
import 'package:ethread_app/task/task_screen/ui/task_location_title_status_widget.dart';
import 'package:ethread_app/task/task_screen/ui/task_pending_nav_button.dart';
import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:ethread_app/utils/custom_widgets/cupertino_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:get/get.dart';

class TaskPendingWidget extends StatelessWidget {
  final int id;
  final int routeId;
  final int driverRouteId;
  final int index;
  final String? title;
  final String? address;
  final int numberOfBins;
  final String isActive;
  final String notes;

  TaskPendingWidget(
      {required this.id,
      required this.routeId,
      required this.driverRouteId,
      required this.index,
      required this.title,
      required this.address,
      required this.numberOfBins,
      required this.isActive,
      required this.notes,
      Key? key})
      : super(key: key);

  late LocationData _locationData;
  Location location = Location();
  bool _serviceEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(
          horizontal: 0.0, vertical: CustomPadding.padding10H),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CustomRadius.customRadius16),
      ),
      child: Row(
        children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: CustomPadding.padding20W,
            ),
            child: Row(
              children: [
                const TaskDoneStartWidget(text: "Start"),
                SizedBox(
                  width: CustomWidth.width20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          TaskLocationNumWidget(num: index),
                          SizedBox(
                              height: CustomHeight.height12,
                              child: VerticalDivider(
                                width: CustomWidth.width12,
                                color: Colors.black,
                              )),
                          Text(
                            " ${numberOfBins.toString().padLeft(2, '0')} Bins ",
                            style: Theme.of(context).textTheme.bodyText2!,
                          ),
                          SizedBox(
                            width: CustomWidth.width4,
                          ),
                          InkWell(
                            onTap: () async {
                              _serviceEnabled = await location.serviceEnabled();
                              if (!_serviceEnabled) {
                                _serviceEnabled =
                                    await location.requestService();
                                if (!_serviceEnabled) {
                                  Get.snackbar('Permission Request',
                                      "Please turn on your location to proceed",
                                      snackPosition: SnackPosition.BOTTOM,
                                      colorText: Colors.black);
                                } else {
                                  navigateToGoogleMaps();
                                }
                              } else {
                                navigateToGoogleMaps();
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Theme.of(context).splashColor,
                                ),
                                SizedBox(width: CustomWidth.width4),
                                Text(
                                  "Get Directions",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          decoration: TextDecoration.underline),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: CustomHeight.height4),
                      TaskLocationTitleStatusWidget(title: title!),
                      SizedBox(height: CustomHeight.height4),
                      TaskLocationAddressWidget(address: address!),
                    ],
                  ),
                ),
              ],
            ),
          )),
          TaskPendingNavButton(
              numberOfBins: numberOfBins,
              index: index,
              routeId: routeId,
              driverRouteId: driverRouteId,
              id: id,
              title: title!,
              address: address!)
        ],
      ),
    );
  }

  void navigateToGoogleMaps() async {
    try {
      List<geocoding.Location> destinationLocation =
          await geocoding.locationFromAddress(address!);

      double destinationLatitude = destinationLocation[0].latitude;
      double destinationLongitude = destinationLocation[0].longitude;

      _locationData = await location.getLocation();

      double? originLatitude = _locationData.latitude;
      double? originLongitude = _locationData.longitude;

      //-34.1023497,150.7879994 default origin from somewhere in Australia

      await MapLauncher.showDirections(
        destination: Coords(destinationLatitude, destinationLongitude),
        origin: Coords(originLatitude!, originLongitude!),
        mapType: MapType.google,
      );
    } on Exception catch (e) {
      CustomIosDialog(
        title: "Can't open",
        message: "Something went wrong!",
        callback: () => Get.back(),
      );
    }
  }
}
