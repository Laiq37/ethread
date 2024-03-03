import 'dart:convert';

import 'package:ethread_app/task/service_screen/ui/camer_preview_widget.dart';
import 'package:ethread_app/utils/custom_widgets/cupertino_alert_dialog.dart';
import 'package:ethread_app/utils/custom_widgets/cupertino_loader_dialog.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:ethread_app/utils/helpers/screen_info.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as locations;
import 'package:get/get.dart';
import 'display_picture_screen.dart';

class CameraScreen extends StatefulWidget {
  final String cameFrom;
  final int index;
  final int driverRouteId;
  final int routeId;
  final int locationId;
  final int binId;

  const CameraScreen(
      {required this.cameFrom,
      required this.index,
      required this.routeId,
      required this.driverRouteId,
      required this.locationId,
      required this.binId,
      Key? key})
      : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late locations.LocationData _locationData;
  bool _serviceEnabled = false;
  locations.Location location = locations.Location();
  String? streetAddress;
  String? postalCode;
  String? country;
  late XFile file;
  final ScreenInfo _screenInfo = ScreenInfo();

  // @override
  // void initState() {
  //   super.initState();
  //   _screenInfo.setCurrentScreen = Constants.none;
  // }

  // @override
  // void dispose() {
  //   _screenInfo.setCurrentScreen = Constants.serviceScreen;
  //   super.dispose();
  // }

  takePicture(CameraController controller) async {
    if (controller.value.isTakingPicture) {
      return;
    }
    Get.dialog(
      const CupertinoLoaderDialog(),barrierColor: Colors.transparent);
    try{
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Get.snackbar(
          'Permission Request',
          "Please turn on your location to proceed",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else if (_serviceEnabled) {
      var lat = _locationData.latitude;
      var lng = _locationData.longitude;

      await getUserLocation(lat!, lng!);
      // getUserLocation(-33.6233814, 151.1483653);  //-33.6233814,151.1483653

      // if(country == null || postalCode == null || streetAddress == null){
      //   Get.back();
      //   CustomIosDialog(title: "",)
      //   return;
      // }

      file = await controller.takePicture();

      Get.back();
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
              index: widget.index,
              routeId: widget.routeId,
              driverRouteId: widget.driverRouteId,
              locationId: widget.locationId,
              binId: widget.binId,
              cameFrom: widget.cameFrom,
              imagePath: file.path,
              streetAddress: streetAddress,
              postalCode: postalCode,
              country: country,
              currentTimeStamp:
                  DateFormat('dd MMM yyyy h:mm a').format(DateTime.now())),
        ),
      );
    }
    }catch(err){
      Get.back();
      Get.dialog(
      const CustomIosDialog(title: 'Something went wrong', message: 'Failed to get location, check your internet connection and try again!')
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    // if (!controller.value.isInitialized) {
    //   return Container();
    // }
    return FutureBuilder(
        future: getLocationData(),
        builder: (context, snapShot) {
          return snapShot.connectionState == ConnectionState.waiting
              ? const CupertinoLoaderDialog()
              : snapShot.connectionState == ConnectionState.done
                  ? snapShot.hasError
                      ? CustomIosDialog(
                          title: "Something went wrong!",
                          message: "Camera cant open, try again!",
                          callback: () => Navigator.of(context).pop(),
                        )
                      : Scaffold(
                          body: SafeArea(
                              child: CameraPreviewWidget(
                                  takePicture: takePicture)),
                        )
                  : CustomIosDialog(
                      title: "Something went wrong!",
                      message: "Camera cant open, try again!",
                      callback: () => Navigator.of(context).pop,
                    );
        });
  }

  Future<void> getLocationData() async {
    // locations.Location location = locations.Location();
    _locationData = await location.getLocation().timeout(const Duration(seconds: 10));
  }

  Future<void> getUserLocation(double latitude, double longitude) async {
    try
    {List<Placemark> placeMarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placeMarks[0];
    streetAddress = "${place.street} ${place.subLocality}";
    country = place.country;
    postalCode =
        "${place.locality}  ${place.administrativeArea}  ${place.postalCode}";}
        catch(e){
          rethrow;
        }
  }
}
