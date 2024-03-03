import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ethread_app/task/task_screen/controller/task_listing_screen_controller.dart';
import 'package:ethread_app/task/task_screen/ui/task_completed_widget.dart';
import 'package:ethread_app/task/task_screen/ui/task_pending_widget.dart';
import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/custom_widgets/custom_app_bar.dart';
import 'package:ethread_app/utils/custom_widgets/title_header_widget.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:ethread_app/utils/helpers/screen_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskListingScreen extends StatefulWidget {
  final int routeId;
  final int driverRouteId;
  const TaskListingScreen(
      {required this.routeId, required this.driverRouteId, Key? key})
      : super(key: key);

  @override
  _TaskListingScreenState createState() => _TaskListingScreenState();
}

class _TaskListingScreenState extends State<TaskListingScreen> {
  final _controller = Get.find<TaskListingScreenController>();

  final _screenInfo = ScreenInfo();


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero)
        .then((value) => _controller.getLocations(widget.routeId));
    // _controller.getLocations(widget.routeId);
    _screenInfo.setCurrentScreen = Constants.listingScreen;
  }

  @override
  dispose() {
    _screenInfo.setCurrentScreen = Constants.routeScreen;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: CustomPadding.padding32H,
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
              SizedBox(
                height: CustomHeight.height16,
              ),
              const TitleHeaderWidget(),
              SizedBox(
                height: CustomHeight.height32,
              ),
              Obx(() => _controller.isLoading.isTrue
                  ? Center(
                      child: CupertinoActivityIndicator(
                        radius: CustomRadius.customRadius15,
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (_, index) {
                          return _controller
                                      .locationList[index].location.status ==
                                  Constants.completedStatus
                              ? TaskCompletedWidget(
                                  index: index + 1,
                                  title: _controller
                                      .locationList[index].location.title,
                                  address: _controller
                                      .locationList[index].location.address,
                                )
                              : TaskPendingWidget(
                                  id: _controller
                                      .locationList[index].location.id,
                                  routeId: widget.routeId,
                                  driverRouteId: widget.driverRouteId,
                                  index: index + 1,
                                  title: _controller
                                      .locationList[index].location.title,
                                  address: _controller
                                      .locationList[index].location.address,
                                  numberOfBins: _controller
                                      .locationList[index].location.binsCount,
                                  isActive: _controller
                                      .locationList[index].location.status,
                                  notes: _controller
                                      .locationList[index].location.notes,
                                );
                        },
                        itemCount: _controller.locationList.length,
                      ),
                    ))
            ],
          ),
        )));
  }
}
