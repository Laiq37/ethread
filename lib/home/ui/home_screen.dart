import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ethread_app/home/controller/vehicles_controller.dart';
import 'package:ethread_app/home/ui/select_vehicle_card_widget.dart';
import 'package:ethread_app/route/controller/route_controller.dart';
import 'package:ethread_app/task/service_screen/controller/bin_service_controller.dart';
import 'package:ethread_app/task/task_screen/controller/task_listing_screen_controller.dart';
import 'package:ethread_app/task/task_screen/ui/task_listing_screen.dart';
import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/custom_widgets/custom_app_bar.dart';
import 'package:ethread_app/utils/custom_widgets/enter_km_dialog.dart';
import 'package:ethread_app/utils/custom_widgets/responsive_widget.dart';
import 'package:ethread_app/utils/custom_widgets/title_header_widget.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:ethread_app/utils/helpers/dart_functions.dart';
import 'package:ethread_app/utils/helpers/screen_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = Get.find<VehiclesController>();

  final _screenInfo = ScreenInfo();

  late StreamSubscription<ConnectivityResult> subscription;

  @override
  initState() {
    super.initState();
    _screenInfo.setCurrentScreen = Constants.homeScreen;
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result == ConnectivityResult.wifi) {
        if(_screenInfo.getCurrentScreen == Screen.home && _controller.vehiclesList.isEmpty){
          _controller.getVehicles();
        }
        DartFunctions.binServing().then((isServed) {
          if (isServed == true) {
          var _routeController = Get.find<RouteController>();
          var _binController = Get.find<BinServiceController>();
          var _listingController = Get.find<TaskListingScreenController>();
            switch (_screenInfo.getCurrentScreen) {
              case Screen.listing:
                {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskListingScreen(
                                routeId: _routeController.currentRouteId,
                                driverRouteId:
                                    _routeController.currentDriverRouteId,
                              )));
                }
                break;

              case Screen.service:
                {
                  DartFunctions.refreshingTaskServiceUi(
                          _binController, _listingController.currentLocationId)
                      .then((isLocationCompleted) {
                    if (isLocationCompleted) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskListingScreen(
                                    routeId: _routeController.currentRouteId,
                                    driverRouteId:
                                        _routeController.currentDriverRouteId,
                                  )));
                      return;
                    }
                    _binController.createBinsOpen();
                  });
                }
                break;
            }
          }
        });
        return;
      }
      else{
        DartFunctions.showSnackBar(
          "Please check internet connectivity.",
          'No internet',
        );
      }   
    });
    Connectivity().checkConnectivity().then((result) => result == ConnectivityResult.wifi ? null : _controller.fetchVehiclesFromLocalDb()); 
  }

// Be sure to cancel subscription after you are done
  @override
  dispose() {
    subscription.cancel();
    _screenInfo.setCurrentScreen = Constants.none;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("width: ${MediaQuery.of(context).size.width}\nheight: ${MediaQuery.of(context).size.height}");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: CustomPadding.padding32W,
                  vertical: CustomPadding.padding8H),
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CustomAppBar(),
                  SizedBox(height: CustomHeight.height16),
                  const TitleHeaderWidget(
                    isHome: true,
                  ),
                  SizedBox(height: CustomHeight.height32),
                  Obx(() => _controller.isLoading.isTrue
                      ? Center(
                          child: CupertinoActivityIndicator(
                            radius: CustomRadius.customRadius15,
                          ),
                        )
                      : Expanded(
                          child: ResponsiveWidget(builder: (isWide, width) {
                            return GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          isWide || width >= 800 ? 5 : 3),
                              itemBuilder: (_, index) {
                                return Obx(
                                  () => SelectVehicleCardWidget(
                                    id: _controller.vehiclesList[index].id,
                                    vehicleNumber: _controller
                                        .vehiclesList[index].registrationNumber,
                                    isActive: _controller
                                        .vehiclesList[index].isActive,
                                    isSeleted:
                                        _controller.selectedVehicleList[index],
                                    callback: () {
                                      _controller.selectedVehicleList[index] =
                                          true;
                                      _controller.selectedVehicleList.refresh();
                                      Get.dialog(EnterKilometersDialog(
                                        vehicleId:
                                            _controller.vehiclesList[index].id,
                                        index: index,
                                      ));
                                    },
                                  ),
                                );
                              },
                              itemCount: _controller.vehiclesList.length,
                            );
                          }),
                        ))
                ],
              )),
        ));
  }
}
