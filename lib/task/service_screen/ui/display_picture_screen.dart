import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:ethread_app/services/client/base_client.dart';
import 'package:ethread_app/services/controller/base_controller.dart';
import 'package:ethread_app/services/models/bin/bin_report.dart';
import 'package:ethread_app/services/models/report/report.dart';
import 'package:ethread_app/services/models/report/report_response.dart';
import 'package:ethread_app/task/service_screen/controller/bin_service_controller.dart';
import 'package:ethread_app/task/task_screen/ui/task_listing_screen.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/font/font_size.dart';
import 'package:ethread_app/utils/custom_widgets/cupertino_alert_dialog.dart';
import 'package:ethread_app/utils/custom_widgets/cupertino_loader_dialog.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:ethread_app/utils/helpers/dart_functions.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class DisplayPictureScreen extends StatefulWidget {
  final int index;
  final int driverRouteId;
  final int routeId;
  final int locationId;
  final int binId;
  final String cameFrom;
  final String imagePath;
  final String? streetAddress;
  final String? postalCode;
  final String? country;
  final String? currentTimeStamp;

  const DisplayPictureScreen({
    Key? key,
    required this.index,
    required this.routeId,
    required this.driverRouteId,
    required this.locationId,
    required this.binId,
    required this.cameFrom,
    required this.streetAddress,
    required this.postalCode,
    required this.country,
    required this.imagePath,
    this.currentTimeStamp,
  }) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  GlobalKey globalKey = GlobalKey();

  final _controller = Get.find<BinServiceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              RepaintBoundary(
                key: globalKey,
                child: Stack(
                  children: [
                    SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        child: Image.file(
                          File(widget.imagePath),
                          fit: BoxFit.cover,
                        )),
                    Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: CustomPadding.padding8W,
                              vertical: CustomPadding.padding8W),
                          color: Colors.black.withOpacity(0.5),
                          child: Text(
                            "${widget.currentTimeStamp} \n ${widget.streetAddress} \n ${widget.postalCode} \n ${widget.country}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Theme.of(context).cardTheme.color,
                                fontSize: FontSize.font16),
                          ),
                        )),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.cancel,
                              size: 60,
                              color: Theme.of(context).cardTheme.color,
                            )),
                        InkWell(
                            onTap: () {
                              _save();
                            },
                            child: Icon(
                              Icons.check_circle,
                              size: 60,
                              color: Theme.of(context).cardTheme.color,
                            ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    try {
      RenderRepaintBoundary? boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      //It contains binary data of the watermark image
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      //This will get us the package directory of the app
      Directory? directory = await getExternalStorageDirectory();
      String path = directory!.path;

      //Here we use timestamp inorder to make each file name unique
      final filePath =
          '$path/${widget.binId}_${DateTime.now().millisecondsSinceEpoch}.png';

      //Now this is the file object which we sent to server/store local
      File imgFile = File(filePath);

      //Then write binary data to this file
      imgFile.writeAsBytes(pngBytes);

      //Core logic to insert data into LocationBinsReport db
      var binReportsBox = Hive.box<Report>(Constants.reportsBox);

      Report report = binReportsBox.get(widget.locationId.toString())!;

      //getting current date bin data
      Bin bin =
          report.bins.where((localBin) => localBin.id == widget.binId && localBin.date == DartFunctions.getCurrentDate()).single;

      //Store bin pictures and timestamp in local db

      //Check whether it is first arrive picture or compliance
      //If it is first picture than just saves it in local db
      if (widget.cameFrom == Constants.firstPicture) {
        bin.firstPicture = filePath;

        _controller.binsList[widget.index].firstPicture = bin.firstPicture;
        await binReportsBox.put(widget.locationId.toString(), report);
        _controller.binsList.refresh();

        Navigator.pop(context);
        Navigator.pop(context);
      }
      //If it is compliance picture than saves it in local db and
      //check if first arrived and compliance both exits then
      //send it to server
      else if (widget.cameFrom == Constants.lastPicture) {
        bin.lastPicture = filePath;
        bin.status = Constants.completedStatus;
        bin.endTime = DateTime.now().toUtc().toString();

        _controller.binsList[widget.index].lastPicture = bin.lastPicture;

        await binReportsBox.put(widget.locationId.toString(), report);
        _controller.binsList.refresh();

        final isConnected = await DartFunctions.checkInternetConnection();

        if (isConnected) {
          //send data to server

          //Show Loading dialog
          Get.dialog(const CupertinoLoaderDialog());

          //Logic to retrieve only processed bins and store it in temporary
          // report and send those to server

          //Here we create a new instance for report Obj
          late Report serviceReport;

          //Filter only services bins inorder to send to server
          List<Bin> servicedBins = report.bins
              .where((localBin) =>
                  localBin.lastPicture != null && localBin.isBinServed == false)
              .toList();

          //Add all serviced bins in this new report instance to
          //send to server
          serviceReport = Report(
              driverRouteId: report.driverRouteId,
              locationId: report.locationId,
              bins: servicedBins);

          final response = await BaseClient()
              .binReportPostForm("driver/getbins", serviceReport.toJson())
              .catchError(BaseController.handleError);

          if (response != null) {
            Report report = binReportsBox.get(widget.locationId.toString())!;

            reportResponseFromJson(response).data.forEach((completedBin) async {
              if (completedBin.status == Constants.completedStatus) {
                //Update binServiced to true in Reports local db
                //To make sure we don't send these bin to local db
                int binIndex = _controller.binsList.indexWhere(
                    (bin) => bin.id.toString() == completedBin.binId && bin.date == completedBin.date);

                final Bin currentBin = binIndex != -1 ? _controller.binsList[binIndex] : report.bins.firstWhere((localbin) => localbin.id.toString() == completedBin.binId && localbin.date == completedBin.date);
                DartFunctions.deleteFiles([currentBin.audio,currentBin.firstPicture,currentBin.lastPicture]);
                if(binIndex != -1){

                _controller.totalBinServed += 1;
                _controller.binsList[binIndex].isBinServed = true;
                }
                report.bins //added new line from here to binReportsBox.delete
                    .removeWhere((element) =>
                        element.id.toString() == completedBin.binId && element.date == completedBin.date);


              }
            });
            _controller.binsList.refresh();

            if (report.bins.isNotEmpty) {
              await binReportsBox.put(widget.locationId.toString(), report);
            } else {
              binReportsBox.delete(widget.locationId.toString());
            }

            if (Get.isDialogOpen!) {
              Get.back();
            }

            Navigator.pop(context);
            Navigator.pop(context);
            // _controller.totalBinServed += 1;
            Get.snackbar('Success', "Bin processed successfully",
                snackPosition: SnackPosition.BOTTOM, colorText: Colors.black);
            if (_controller.totalBinServed == _controller.binsList.length) {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => TaskListingScreen(
                            routeId: widget.routeId,
                            driverRouteId: widget.driverRouteId,
                          ))));
              return;
            }
          }
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
        }
        _controller.bins[widget.index] = false;
      }
    } catch (e, s) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'To get the crash report');
      const CustomIosDialog(
          title: "Something Went Wrong", message: "Failed to save picture");
    }
  }
}
