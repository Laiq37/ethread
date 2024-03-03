import 'package:ethread_app/home/controller/home_screen_controller.dart';
import 'package:ethread_app/home/controller/vehicles_controller.dart';
import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:ethread_app/utils/config/theme/theme_config.dart';
import 'package:ethread_app/utils/custom_widgets/cupertino_loader_dialog.dart';
import 'package:ethread_app/utils/helpers/dart_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'gradient_button.dart';

class EnterKilometersDialog extends StatelessWidget {

  final int vehicleId;
  final int index;
  EnterKilometersDialog({required this.vehicleId, required this.index, Key? key}) : super(key: key);

  final VehiclesController _controller = Get.find<VehiclesController>();

  final _formKey = GlobalKey<FormState>(); //use to validate form fields errors

  final TextEditingController _numbersOfKilometersTextController = TextEditingController();

  final _homeScreenController = HomeScreenController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        _controller.selectedVehicleList[index] = false;
        _controller.selectedVehicleList.refresh();
        return true;
      },
      child: Dialog(
        insetPadding:  EdgeInsets.symmetric(horizontal: CustomPadding.padding100W),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CustomRadius.customRadius22)
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: CustomPadding.padding32W, vertical: CustomPadding.padding32H),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Please Enter Current \n Kilometers",
                    textAlign:
                    TextAlign.left,
                    style: Theme.of(context).textTheme.headline2!.copyWith(height: CustomHeight.height1_2)),
                 SizedBox(height: CustomHeight.height16),
                Form(
                  key:_formKey,
                  child: TextFormField(
                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,
                    style: Theme.of(context).textTheme.bodyText1,
                    controller: _numbersOfKilometersTextController,
                    keyboardType: TextInputType.number,
                    cursorColor: Theme.of(context).splashColor,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).splashColor,
                              width: 2.0),
                          borderRadius: BorderRadius.circular(CustomRadius.customRadius8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:  const BorderSide(
                              color: Color(0xffF2F2F2),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(CustomRadius.customRadius8),
                        ),
                        filled: true,
                        suffixIcon: SizedBox(
                          height: CustomHeight.height60,
                          child: ElevatedButton(
                            onPressed: () {
                            },
                            child: Text("KM",style: Theme.of(context).textTheme.bodyText1,),
                            style: ElevatedButton.styleFrom(
                              primary:  const Color(0xffF2F2F2),
                              textStyle: Theme.of(context).textTheme.bodyText1,
                              shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(CustomRadius.customRadius8),
                                    bottomRight:
                                    Radius.circular(CustomRadius.customRadius8)),
                              ),
                            ),
                          ),
                        ),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(CustomRadius.customRadius8))),
                    validator: (value) => value!.isEmpty || !DartFunctions.isNum(value)? 'Enter valid number' : null,
                  ),
                ),
                 SizedBox(height: CustomHeight.height16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GradientButton(
                    width: CustomWidth.width80,
                    height: CustomHeight.height40,
                    child: Text(
                      'Start',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.white,fontWeight: FontWeight.w600),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[
                        ThemeConfig().gradientDark,
                        ThemeConfig().gradientLight
                      ],
                    ),
                    onPressed: () {
                      Get.dialog(const CupertinoLoaderDialog());
                      _homeScreenController.validateAndNavigate(context,_formKey,_numbersOfKilometersTextController.text.trim(),vehicleId.toString(), index);},
                    key: const Key("km_dialog_button"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
