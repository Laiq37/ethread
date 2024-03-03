import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ethread_app/route/controller/route_controller.dart';
import 'package:ethread_app/route/ui/route_card_widget.dart';
import 'package:ethread_app/services/models/route/route_model.dart';
import 'package:ethread_app/task/service_screen/controller/bin_service_controller.dart';
import 'package:ethread_app/task/task_screen/controller/task_listing_screen_controller.dart';
import 'package:ethread_app/task/task_screen/ui/task_listing_screen.dart';
import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/custom_widgets/custom_app_bar.dart';
import 'package:ethread_app/utils/custom_widgets/responsive_widget.dart';
import 'package:ethread_app/utils/custom_widgets/title_header_widget.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:ethread_app/utils/helpers/dart_functions.dart';
import 'package:ethread_app/utils/helpers/screen_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RouteScreen extends StatefulWidget {
   List<RouteModel> routes;

   RouteScreen({required this.routes, Key? key}) : super(key: key);

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {

  final _screenInfo = ScreenInfo();

  StreamSubscription<ConnectivityResult>? subscription;

  bool isLoading = false;

  final RouteController routeController = Get.put(RouteController());

  @override
  initState() {
    super.initState();
    _screenInfo.setCurrentScreen = Constants.routeScreen;
      if(widget.routes.isNotEmpty)return;
      subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if(result == ConnectivityResult.wifi){
        if(_screenInfo.getCurrentScreen == Screen.route && routeController.routeList.isEmpty){
          routeController.getRoutes().then((routeList) => widget.routes = routeList as List<RouteModel>).then((_) => routeController.isLoading.value = false);
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
    
  }

  @override
  dispose() {
    subscription?.cancel();
    _screenInfo.setCurrentScreen = Constants.type == Constants.permenant ? Constants.homeScreen : Constants.none;
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
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
                  const TitleHeaderWidget(),
                  SizedBox(height: CustomHeight.height32),
                  Obx(
                     () {
                      return routeController.isLoading.isTrue ? Center(child: CupertinoActivityIndicator(radius: CustomRadius.customRadius15,),) : Expanded(
                        child: ResponsiveWidget(builder: (isWide, width) {
                          return GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 225,
                                crossAxisCount: 2
                                // isWide || width >= 800 ? 5 : 3
                                ),
                            itemBuilder: (_, index) {
                              return RouteCardWidget(route: widget.routes[index], routeNumber: index);
                            },
                            itemCount: widget.routes.length,
                          );
                        }),
                      );
                    }
                  )
                ],
              )),
        ));
  }
}
