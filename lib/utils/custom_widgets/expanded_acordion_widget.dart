import 'dart:async';
import 'package:ethread_app/services/models/bin/bin_report.dart';
import 'package:ethread_app/services/models/report/report.dart';
import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:ethread_app/utils/helpers/dart_functions.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:ethread_app/services/models/voice_recoder/voice_rec_provider.dart';
import 'package:ethread_app/task/service_screen/controller/bin_service_controller.dart';
import 'package:ethread_app/task/service_screen/ui/camera_screen.dart';
import 'package:ethread_app/utils/config/theme/theme_config.dart';
import 'package:ethread_app/utils/custom_widgets/voice_recorder_wudget/voice_rec_anim.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:ethread_app/utils/helpers/sound_recorder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'gradient_button.dart';

String halfFilled = "half_filled";

enum BIN_STATUS { empty, halfFilled, full, oneFourth, threeFourths, overflow }
// { empty, partialFilled, full, overflow, other }
//one third
//half filled
//

class ExpandedAcordionWidget extends StatefulWidget {
  final int index;
  final int routeId;
  final int driverRouteId;
  final int locationId;
  final int binId;

  final SoundRecorder recorder;

  const ExpandedAcordionWidget(
      {required this.index,
      required this.routeId,
      required this.driverRouteId,
      required this.locationId,
      required this.binId,
      required this.recorder,
      Key? key})
      : super(key: key);

  @override
  State<ExpandedAcordionWidget> createState() => _ExpandedAcordionWidgetState();
}

class _ExpandedAcordionWidgetState extends State<ExpandedAcordionWidget> {
  final _controller = Get.find<BinServiceController>();

  final TextEditingController _finalCommentsController =
      TextEditingController(); //use to hold username field text

  final ValueNotifier<BIN_STATUS> _binStatus = ValueNotifier(BIN_STATUS.empty);

  late Box<Report> binReportsBox;

  late final VoiceRecProvider voiceRecProvider;

  late StreamSubscription<bool> keyboardSubscription;

  initRecorderPlayer() async {
    if (!widget.recorder.isInitialized) {
      await widget.recorder.init();
    }
    // MicPermission().setStatus();
  }

  @override
  void initState() {
    super.initState();
    initRecorderPlayer();
    voiceRecProvider = VoiceRecProvider();
    getBinsBox();
    String prevText = _finalCommentsController.text;
    KeyboardVisibilityController keyboardVisibilityController =
        KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible || prevText == _finalCommentsController.text) return;
      saveCommentsToLocalDb();
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    _finalCommentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        takePictureQuestion(context),
        const Divider(),
        binStatusQuestion(context, widget.index),
        const Divider(),
        compliancePictureWidget(context),
        SizedBox(
          height: CustomHeight.height8,
        ),
      ],
    );
  }

  ListTile takePictureQuestion(BuildContext context) {
    return ListTile(
      leading: _controller.binsList[widget.index].firstPicture != null
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).splashColor,
            )
          : SizedBox(
              width: CustomWidth.width1,
            ),
      title: Text("Take Site Picture (First Arrived)",
          style: Theme.of(context).textTheme.bodyText1),
      trailing: GradientButton(
        width: CustomWidth.width120,
        height: CustomHeight.height40,
        child: Text(
          'Take Picture',
          style: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: <Color>[
            _controller.binsList[widget.index].firstPicture != null
                ? ThemeConfig().gradientDark.withOpacity(0.3)
                : ThemeConfig().gradientDark,
            _controller.binsList[widget.index].firstPicture != null
                ? ThemeConfig().gradientLight.withOpacity(0.3)
                : ThemeConfig().gradientLight
          ],
        ),
        onPressed: () {
          _controller.binsList[widget.index].firstPicture != null
              ? null
              : openCamera(context, Constants.firstPicture);
        },
        key: const Key("km_dialog_button"),
      ),
    );
  }

  ListTile binStatusQuestion(BuildContext context, int index) {
    return ListTile(
      leading: Icon(
        Icons.check_circle,
        color: Theme.of(context).splashColor,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("How much items are in bin?",
              style: Theme.of(context).textTheme.bodyText1),
          SizedBox(
            height: CustomHeight.height8,
          ),
          ValueListenableBuilder(
              valueListenable: _binStatus,
              builder: (context, BIN_STATUS binStatus, ch) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Radio<BIN_STATUS>(
                                value: BIN_STATUS.empty,
                                groupValue: _binStatus.value,
                                onChanged: (BIN_STATUS? value) {
                                  // setState(() {
                                  _binStatus.value = value!;
                                  // });

                                  saveBinFilledStatusToLocalDb(
                                      _binStatus.value);
                                },
                              ),
                              Text("Empty",
                                  style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<BIN_STATUS>(
                                value: BIN_STATUS.oneFourth,
                                groupValue: _binStatus.value,
                                onChanged: (BIN_STATUS? value) {
                                  // setState(() {
                                  _binStatus.value = value!;
                                  // });

                                  saveBinFilledStatusToLocalDb(
                                      _binStatus.value);
                                },
                              ),
                              Text("1/4",
                                  style:
                                      Theme.of(context).textTheme.bodyText2!),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<BIN_STATUS>(
                                value: BIN_STATUS.halfFilled,
                                groupValue: _binStatus.value,
                                onChanged: (BIN_STATUS? value) {
                                  // setState(() {
                                  _binStatus.value = value!;
                                  // });

                                  saveBinFilledStatusToLocalDb(
                                      _binStatus.value);
                                },
                              ),
                              Text("Half Filled",
                                  style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Radio<BIN_STATUS>(
                                value: BIN_STATUS.threeFourths,
                                groupValue: _binStatus.value,
                                onChanged: (BIN_STATUS? value) {
                                  // setState(() {
                                  _binStatus.value = value!;
                                  // });

                                  saveBinFilledStatusToLocalDb(
                                      _binStatus.value);
                                },
                              ),
                              Text("3/4",
                                  style:
                                      Theme.of(context).textTheme.bodyText2!),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<BIN_STATUS>(
                                value: BIN_STATUS.full,
                                groupValue: _binStatus.value,
                                onChanged: (BIN_STATUS? value) {
                                  // setState(() {
                                  _binStatus.value = value!;
                                  // });

                                  saveBinFilledStatusToLocalDb(
                                      _binStatus.value);
                                },
                              ),
                              Text("Full",
                                  style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<BIN_STATUS>(
                                value: BIN_STATUS.overflow,
                                groupValue: _binStatus.value,
                                onChanged: (BIN_STATUS? value) {
                                  // setState(() {
                                  _binStatus.value = value!;
                                  // });

                                  saveBinFilledStatusToLocalDb(
                                      _binStatus.value);
                                },
                              ),
                              Text("Overflow",
                                  style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }),
          SizedBox(height: CustomHeight.height16),
          Text("Final Comments",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: CustomHeight.height8),
          SizedBox(
            height: CustomHeight.height50,
            child: Stack(
              children: [
                ValueListenableBuilder<bool>(
                    valueListenable: voiceRecProvider.isLongPress,
                    builder: (context, bool isLongPress, _) {
                      return !isLongPress
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: _finalCommentsController,
                                style: Theme.of(context).textTheme.bodyText1,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Theme.of(context).splashColor,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: CustomPadding.padding20W),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 2.0),
                                      borderRadius: BorderRadius.circular(
                                          CustomRadius.customRadius8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(
                                          CustomRadius.customRadius8),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            CustomRadius.customRadius32))),
                              ),
                            )
                          : const SizedBox();
                    }),
                VoiceReco(
                  recorder: widget.recorder,
                  saveBinAudioToLocalDB: saveBinAudioToLocalDb,
                ),
              ],
            ),
          ),
          SizedBox(height: CustomHeight.height16),
        ],
      ),
    );
  }

  ListTile compliancePictureWidget(BuildContext context) {
    return ListTile(
      leading: _controller.binsList[widget.index].isBinServed
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).splashColor,
            )
          : SizedBox(
              width: CustomWidth.width1,
            ),
      title: Text("Take Compliance Picture",
          style: Theme.of(context).textTheme.bodyText1),
      trailing: GradientButton(
        width: CustomWidth.width120,
        height: CustomHeight.height40,
        child: Text(
          'Take Picture',
          style: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: <Color>[
            _controller.binsList[widget.index].lastPicture != null
                ? ThemeConfig().gradientDark.withOpacity(0.3)
                : ThemeConfig().gradientDark,
            _controller.binsList[widget.index].lastPicture != null
                ? ThemeConfig().gradientLight.withOpacity(0.3)
                : ThemeConfig().gradientLight
          ],
        ),
        onPressed: () {
          if (_controller.binsList[widget.index].firstPicture != null) {
            _controller.binsList[widget.index].lastPicture != null
                ? null
                : openCamera(context, Constants.lastPicture);
          } else {
            Get.snackbar('Request', "Please take site picture first",
                snackPosition: SnackPosition.BOTTOM, colorText: Colors.black);
          }
        },
        key: const Key("km_dialog_button"),
      ),
    );
  }

  void openCamera(BuildContext context, String cameFrom) async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

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
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted == PermissionStatus.granted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CameraScreen(
                      routeId: widget.routeId,
                      driverRouteId: widget.driverRouteId,
                      locationId: widget.locationId,
                      binId: widget.binId,
                      cameFrom: cameFrom,
                      index: widget.index)));
        }
        if (_permissionGranted == PermissionStatus.grantedLimited) {}
      } else if (_permissionGranted == PermissionStatus.granted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CameraScreen(
                    routeId: widget.routeId,
                    driverRouteId: widget.driverRouteId,
                    locationId: widget.locationId,
                    binId: widget.binId,
                    cameFrom: cameFrom,
                    index: widget.index)));
      }
    }
  }

  Future<void> saveCommentsToLocalDb() async {
    Report report = binReportsBox.get(widget.locationId.toString())!;
    final DateTime now = DateTime.now();
        final DateTime currentDate = DateTime(now.year,now.month,now.day);
    Bin bin = report.bins.where((localBin) => localBin.id == widget.binId && localBin.date == DartFunctions.getCurrentDate()).single;

    bin.finalComments = _finalCommentsController.text.trim();
    await binReportsBox.put(widget.locationId.toString(), report);
  }

  Future<void> saveBinFilledStatusToLocalDb(BIN_STATUS binFilledStatus) async {
    Report report = binReportsBox.get(widget.locationId.toString())!;
    Bin bin = report.bins.where((localBin) => localBin.id == widget.binId && localBin.date == DartFunctions.getCurrentDate() ).single;
    bin.binFilledStatus = describeEnum(binFilledStatus).replaceAll(
        RegExp("F"), binFilledStatus == BIN_STATUS.halfFilled ? '_f' : '-f');
    await binReportsBox.put(widget.locationId.toString(), report);
  }

  Future<void> saveBinAudioToLocalDb(String binAudio) async {
    Report report = binReportsBox.get(widget.locationId.toString())!;
    Bin bin = report.bins.where((localBin) => localBin.id == widget.binId && localBin.date == DartFunctions.getCurrentDate()).single;

    bin.audio = binAudio;
    await binReportsBox.put(widget.locationId.toString(), report);
    _controller.binsList[widget.index].audio = binAudio;
  }

  void getBinsBox() async {
    BIN_STATUS binStatus;
    binStatus = BIN_STATUS.empty;
    Bin? bin;
    try {
    binReportsBox = Hive.box<Report>(Constants.reportsBox);
    Report? report = binReportsBox.get(widget.locationId.toString());
    if (report != null) {
       bin =
          report.bins.firstWhereOrNull((localBin) => localBin.id == widget.binId && localBin.date == DartFunctions.getCurrentDate());
      // Bin? bin = <Bin>[].firstWhereOrNull((element) => element.id == widget.binId);
      if (bin?.binFilledStatus != null) {
          _binStatus.value = BIN_STATUS.values.firstWhere((e) =>
              e.toString() ==
              'BIN_STATUS.${bin!.binFilledStatus!.replaceAll("-f", 'F').replaceAll("_f", 'F')}');
              _finalCommentsController.text = bin?.finalComments ?? '';
        } 
      //   _binStatus = ValueNotifier<BIN_STATUS>(binStatus);
      // } else {
      //   _binStatus = ValueNotifier<BIN_STATUS>(BIN_STATUS.empty);
      }
    }
        catch (e, stackTrace) {
          await FirebaseCrashlytics.instance.recordError(e, stackTrace,
              reason: 'Why bin status not assigned? bin -> $bin , binStatus -> $binStatus, err -> $e');
        }
  }
}
