import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:ethread_app/utils/config/font/font_size.dart';
import 'package:ethread_app/utils/config/theme/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelectVehicleCardWidget extends StatelessWidget {
  final int id;
  final String? vehicleNumber;
  final bool isActive;
  final VoidCallback callback;
  final bool isSeleted;

  const SelectVehicleCardWidget(
      {required this.id,
      required this.vehicleNumber,
      required this.isActive,
      required this.callback,
      required this.isSeleted,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Card(
          clipBehavior: Clip.hardEdge,
          margin:  EdgeInsets.symmetric(horizontal: CustomPadding.padding14W, vertical: CustomPadding.padding16H),
          color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
          elevation: isActive ? 20 : 0,
          shadowColor: isActive ? Colors.black26 : null,
          shape: isSeleted ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(CustomRadius.customRadius15),
                    side: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ): RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CustomRadius.customRadius8),
          ),
          child: InkWell(
            onTap: isActive ? callback : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 SizedBox(height: CustomHeight.height8),
                SvgPicture.asset(
                  isActive
                      ? "assets/images/ic_truck_logo.svg"
                      : "assets/images/ic_truck_inactive_logo.svg",
                  width: CustomWidth.width40,
                  height: CustomHeight.height30,
                ),
                 SizedBox(height: CustomHeight.height20),
                Text("Vehicle No",
                overflow: TextOverflow.fade,
                    style: isActive
                        ? Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Theme.of(context).splashColor,
                            fontWeight: FontWeight.w600)
                        : Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: ThemeConfig().inactiveColor,
                            fontWeight: FontWeight.w600)),
                //  SizedBox(height: CustomHeight.height4),
                Text(vehicleNumber ?? "",
                overflow: TextOverflow.fade,
                    style: isActive
                        ? Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontWeight: FontWeight.w600, fontSize: FontSize.font20)
                        : Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: ThemeConfig().inactiveColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20))
              ],
            ),
          ),
        ),
        if(isSeleted)
        Positioned(top: 5, right: 5, child: SvgPicture.asset('./assets/images/Vector.svg', width: CustomWidth.width30, height: CustomHeight.height30, fit: BoxFit.scaleDown,)),
        ],
    );
  }
}
