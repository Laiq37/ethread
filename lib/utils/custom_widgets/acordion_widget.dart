import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:ethread_app/utils/config/font/font_size.dart';
import 'package:ethread_app/utils/custom_widgets/expanded_acordion_widget.dart';
import 'package:ethread_app/task/service_screen/controller/bin_service_controller.dart';
import 'package:ethread_app/utils/config/theme/theme_config.dart';
import 'package:ethread_app/utils/helpers/sound_recorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
class Accordion extends StatefulWidget {
  final SoundRecorder recorder;
  final String? title;
  final Widget? widgetItems;
  final int index;
  final int routeId;
  final int driverRouteId;
  final int locationId;
  final int binId;
  final String? barcode;
  final String? notes;

  const Accordion({
    required this.recorder,
    required this.binId,
    required this.routeId,
    required this.driverRouteId,
    required this.locationId,
    this.title,
    this.widgetItems,
    required this.barcode,
    required this.index,
    required this.notes,
    Key? key,
  }) : super(key: key);

  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool? showContent = true;

  final _controller = Get.find<BinServiceController>();

  var barcodeValue = "-1";
  
  @override
  Widget build(BuildContext context) {
    // final isRecording = recorder.isRecording;

    return Obx(
      ()=> Card(
        color: _controller.binsList[widget.index].isBinServed ? Colors.white.withOpacity(0.6) : Colors.white,
          elevation: 4,
          clipBehavior: Clip.hardEdge,
          margin:  EdgeInsets.symmetric(horizontal: CustomPadding.padding10W, vertical: CustomPadding.padding10H),
          shape: _controller.binsList[widget.index].isBinServed
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CustomRadius.customRadius8),
                  side: BorderSide(
                    width: 1.25,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CustomRadius.customRadius8),
                  side: const BorderSide(
                    color: Colors.white,
                  ),
                ),
          child: 
            Column(children: [
              scanBinWidget(context, widget.index),
               Obx(() => _controller.bins[widget.index] ? 
              ExpandedAcordionWidget(index: widget.index, routeId: widget.routeId, driverRouteId: widget.driverRouteId, locationId: widget.locationId, binId: widget.binId, recorder: widget.recorder,)
                  : const SizedBox())
                  
      ]),
          ),
    );
  }
  InkWell scanBinWidget(BuildContext context, int index) {
    return InkWell(
        onTap: () async {
         if(_controller.binsList[widget.index].isBinScanned && !_controller.binsList[widget.index].isBinServed){
          if(!_controller.bins[index])_controller.createBinsOpen();
          _controller.bins[index] = !_controller.bins[index];
          // _controller.bins.refresh();
         }

          //Inorder to show notes to driver after scanning the bin
          // if (_controller.bins[index] && widget.notes != null && widget.notes != "") {
          //   Get.dialog(
          //       CustomIosDialog(
          //         title: "Attention",
          //         message: widget.notes!,
          //       ),
          //       barrierDismissible: false);
          // }
        },
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: CustomPadding.padding10H),
          child: ListTile(
            leading: SvgPicture.asset(
              "assets/images/ic_bin.svg",
              width: CustomWidth.width35,
              height: CustomHeight.height35,
            ),
            title: Row(
              children: [
                ConstrainedBox(
                  constraints:
                       BoxConstraints(minWidth: CustomWidth.width150, maxWidth: CustomWidth.width150),
                  child: RichText(
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: index < 9 ? "0${index + 1}" : "${index + 1}",
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(fontSize: FontSize.font18)),
                        TextSpan(
                          text:
                              ' - ${_controller.binsList[widget.index].title}',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(fontSize: FontSize.font18),
                        ),
                      ],
                    ),
                  ),
                ),
                 SizedBox(
                  width: CustomWidth.width30,
                ),
                Text(
                  _controller.binsList[widget.index].barcodeNum!,
                  style: TextStyle(
                      color: ThemeConfig().inactiveColor, fontSize: FontSize.font10),
                ),
                if (_controller.binsList[widget.index].isBinScanned)
                   SizedBox(
                    width: CustomWidth.width40,
                  ),
                if (_controller.binsList[widget.index].isBinScanned)
                  Text("Scanned",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).splashColor,
                          fontSize: FontSize.font12))
              ],
            ),
            trailing: _controller.binsList[widget.index].isBinServed
                ? Icon(Icons.check_circle, color: Theme.of(context).splashColor)
                :  SizedBox(
                    width: CustomWidth.width1,
                  ),
          ),
        ));
  }
}
