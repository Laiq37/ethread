import 'dart:async';

import 'package:ethread_app/services/models/bin/bin_report.dart';
import 'package:ethread_app/services/models/permission/mic_permission.dart';
import 'package:ethread_app/services/models/report/report.dart';
import 'package:ethread_app/services/models/voice_recoder/value_notifier_timer.dart';
import 'package:ethread_app/task/service_screen/controller/bin_service_controller.dart';
import 'package:ethread_app/task/service_screen/ui/service_title_widget.dart';
import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/theme/theme_config.dart';
import 'package:ethread_app/utils/custom_widgets/acordion_widget.dart';
import 'package:ethread_app/utils/custom_widgets/cupertino_alert_dialog.dart';
import 'package:ethread_app/utils/custom_widgets/custom_app_bar.dart';
import 'package:ethread_app/utils/custom_widgets/gradient_button.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:ethread_app/utils/helpers/screen_info.dart';
import 'package:ethread_app/utils/helpers/sound_recorder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../services/models/voice_recoder/voice_rec_provider.dart';

class TaskServiceScreen extends StatefulWidget {
  final int locationId;
  final int routeId;
  final int driverRouteId;
  final String? title;
  final String? address;
  final int index;

  const TaskServiceScreen(
      {required this.locationId,
      required this.routeId,
      required this.driverRouteId,
      required this.title,
      required this.address,
      required this.index,
      Key? key})
      : super(key: key);

  @override
  State<TaskServiceScreen> createState() => _TaskServiceScreenState();
}

class _TaskServiceScreenState extends State<TaskServiceScreen> {
  final _controller = Get.find<BinServiceController>();
  String? barcodeValue = "-1";
  int barcodeMatchedIndex = -1;
  late ScrollController _scrollController;
  final timerProvider = TimerProvider();
  final voiceRecProvider = VoiceRecProvider();
  final recorder = SoundRecorder();
  final _screenInfo = ScreenInfo();

  @override
  void initState() {
    super.initState();
    _screenInfo.setCurrentScreen = Constants.serviceScreen;
    _controller.getBins(widget.locationId).then((_) {
      _controller.createBinsOpen();
    });
    _scrollController = ScrollController();
    MicPermission().setStatus();
  }

  @override
  void dispose() {
    recorder.dispose();
    // player.dispose();
    timerProvider.dispose();
    voiceRecProvider.dispose();
    _scrollController.dispose();
    _screenInfo.setCurrentScreen = Constants.listingScreen;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ServiceTitleWidget(
                index: widget.index,
                title: widget.title,
                address: widget.address,
              ),
              SizedBox(height: CustomHeight.height12),
              GradientButton(
                  key: const Key('scan_bin'),
                  child: const Text('Scan Bin',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[
                      ThemeConfig().gradientDark,
                      ThemeConfig().gradientLight
                    ],
                  ),
                  onPressed: () async {
                    barcodeValue = await binScanner();
                    if (barcodeValue == null) return;
                    for (var i = 0; i < _controller.binsList.length; i++) {
                      if (_controller.binsList[i].barcodeNum != barcodeValue)continue;
                      _controller.createBinsOpen();
                      //Inorder to scroll listview to the scanned bin card
                      _scrollController.animateTo(85.0 * i,
                          curve: Curves.easeIn,
                          duration: const Duration(milliseconds: 500));
                      if (_controller.binsList[i].isBinServed) return;
                      _controller.bins[i] = true;
                      if (_controller.binsList[i].isBinScanned) return;
                      barcodeMatchedIndex = i;
                      saveBinScanStatusToLocalDb(
                          _controller.binsList[i].id, barcodeMatchedIndex);
                      if (_controller.binsList[i].driverMessage == null ||
                          _controller.binsList[i].driverMessage!.trim() == "") return;
                      Get.dialog(
                          CustomIosDialog(
                            title: "Attention",
                            message: _controller.binsList[i].driverMessage!,
                          ),
                          barrierDismissible: false);
                      break;
                    }
                  }),
              SizedBox(height: CustomHeight.height14),
              Obx(() => _controller.isLoading.isTrue
                  ? const Center(child: CupertinoActivityIndicator())
                  : Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (_, index) {
                          return Accordion(
                              recorder: recorder,
                              // binStatus: binStatus,
                              // player: player,
                              routeId: widget.routeId,
                              driverRouteId: widget.driverRouteId,
                              locationId: widget.locationId,
                              binId: _controller.binsList[index].id,
                              index: index,
                              barcode: _controller.binsList[index].barcodeNum,
                              notes: _controller.binsList[index].driverMessage);
                        },
                        itemCount: _controller.binsList.length,
                      ),
                    ))
            ],
          ),
        )));
  }

  Future<String?> binScanner() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#00FF00",
        "Cancel",
        Constants.isFlashAvailable,
        ScanMode.DEFAULT,
      );

      if (barcodeScanRes.isNotEmpty && barcodeScanRes != "-1") {
        return barcodeScanRes;
      }
      return null;
    } catch (e) {
      Get.back();
      print(e);
    }
  }

  Future<void> saveBinScanStatusToLocalDb(int binId, int index) async {
    Bin? bin;
    var binReportsBox = Hive.box<Report>(Constants.reportsBox);
    Report? report = binReportsBox.get(widget.locationId.toString());
    if (report != null && report.bins.isNotEmpty) {
      bin = report.bins.firstWhereOrNull((element) =>
          element.id == binId &&
          element.date == _controller.binsList[index].date);
    }

    bin ??= _controller.binsList[index];

    bin.isBinScanned = true;

    //Inorder to calculate bin service start time and save to local db
    bin.startTime = DateTime.now().toUtc().toString();

    _controller.binsList[index].isBinScanned = true;

    // final now = DateTime.now();

    // bin.date =  DateTime(now.year, now.month, now.day);

    _controller.bins[index] = true;

    //_controller.bins[index] = !_controller.bins[index];
    if (report != null && report.bins.isNotEmpty) {
      report.bins.add(bin);
      await binReportsBox.put(widget.locationId.toString(), report);
    } else {
      _controller.createBins(widget.driverRouteId, widget.locationId, [bin]);
    }

    _controller.binsList.refresh();
  }
}
