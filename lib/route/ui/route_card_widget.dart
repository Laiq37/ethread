import 'package:ethread_app/route/controller/route_controller.dart';
import 'package:ethread_app/services/models/route/route_model.dart';
import 'package:ethread_app/task/task_screen/ui/task_listing_screen.dart';
import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:ethread_app/utils/config/font/font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RouteCardWidget extends StatelessWidget {
  final int routeNumber;
  final RouteModel route;
  const RouteCardWidget({required this.route, required this.routeNumber, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
                            clipBehavior: Clip.hardEdge,
                            margin: EdgeInsets.symmetric(
                                horizontal: CustomPadding.padding14W,
                                vertical: CustomPadding.padding16H),
                            color: Colors.white,
                            elevation: 20,
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  CustomRadius.customRadius15),
                            ),
                            child: InkWell(
                              onTap: () async{
                                var controller = Get.find<RouteController>();
                                controller.currentRouteId = route.routeId;
                                controller.currentDriverRouteId = route.driverRouteId;
                               Navigator.push(context, MaterialPageRoute(builder: (context) => TaskListingScreen(routeId: route.routeId, driverRouteId: route.driverRouteId,)));
                              // print(isBack);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: CustomHeight.height8),
                                  SvgPicture.asset(
                                    "assets/images/way_4.svg",
                                    // width: 60,
                                    height: CustomHeight.height45,
                                  ),
                                  SizedBox(height: CustomHeight.height16),
                                  Text("Route ${routeNumber + 1 < 10 ? "0${routeNumber+1}" : routeNumber}",
                                  overflow: TextOverflow.fade,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              color:
                                                  Theme.of(context).splashColor,
                                              fontWeight: FontWeight.w600)),
                                  Container(
                                    alignment: Alignment.center,
                                    height: CustomHeight.height70,
                                    padding: EdgeInsets.symmetric(horizontal:CustomWidth.width8,),
                                    child: Text(route.routeTitle,
                                    textAlign: TextAlign.center,
                                    // maxLines: 1,
                                    overflow: TextOverflow.visible,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: FontSize.font15)),
                                  )
                                ],
                              ),
                            ),
                          );
  }
}