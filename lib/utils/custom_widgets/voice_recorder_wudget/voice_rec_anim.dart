import 'dart:async';
import 'dart:io';
import 'package:ethread_app/services/models/permission/mic_permission.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../helpers/sound_recorder.dart';
// import '../../helpers/sound_player.dart';
import 'small_mic.dart';
import 'big_mic_icon.dart';
import './delete_voc_rec_anim.dart';
import './time_and_slide.dart';
import '../../../services/models/voice_recoder/value_notifier_timer.dart';
import '../../../services/models/voice_recoder/voice_rec_provider.dart';

class VoiceReco extends StatefulWidget {
  final SoundRecorder recorder;
  final Function(String) saveBinAudioToLocalDB;
  const VoiceReco(
      {required this.recorder, required this.saveBinAudioToLocalDB, Key? key})
      : super(key: key);

  @override
  State<VoiceReco> createState() => _VoiceRecoState();
}

class _VoiceRecoState extends State<VoiceReco> {
  String formatTime(int seconds) {
    int m, s;

    m = (seconds) ~/ 60;

    s = seconds - (m * 60);

    return "${m < 10 ? '0$m' : m}:${s < 10 ? '0$s' : s}";
  }

  Future<String> getAudioPath() async {
    final String? path = await widget.recorder.stop();
    return path!;
    // path != null
    //     ? await widget.player.togglePlaying(
    //         whenFinished: () => print("audio has been played"), path: path)
    //     : print('Nothing to play');
  }

  bool getPermissionStatus() {
    final bool status = MicPermission().getStatus();
    return status;
  }

  Future requestPermission() async {
    final PermissionStatus status = await Permission.microphone.request();
    return status == PermissionStatus.granted ? true : false;
  }

  double longPressStart = 0;

  Timer? timer;
  String? time;
  late TimerProvider timerProvider;
  late VoiceRecProvider voiceRecProvider;
  ValueNotifier<bool> isGrantedNotifier =
      ValueNotifier(MicPermission().getStatus());

  @override
  void initState() {
    timerProvider = TimerProvider();
    voiceRecProvider = VoiceRecProvider();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void reset([bool resettingValue = true]) {
      voiceRecProvider.reset(resettingValue);
      timerProvider.resetDuration();
      timer?.cancel();
    }

    // print('stack built');
    return Stack(
      children: [
        const Positioned(bottom: 0, left: 0, right: 0, child: TimeAndSlide()),
        ValueListenableBuilder<Offset>(
          valueListenable: voiceRecProvider.offset,
          builder: ((context, Offset offset, child) {
            return ValueListenableBuilder(
                valueListenable: isGrantedNotifier,
                builder: (context, bool isGranted, _) => Positioned(
                    right: offset.dx,
                    bottom: offset.dy,
                    child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          // print("Have Session ${await widget.recorder.haveSession()}");
                        },
                        onLongPress: !isGranted
                            ? () async {
                                // print('inPermission');
                                final status = await requestPermission();
                                if (status) {
                                  isGrantedNotifier.value = status;
                                  MicPermission().setStatus();
                                  // setState(() {});
                                } else {
                                  Get.snackbar(
                                      'Required', "Mic Permission is required",
                                      snackPosition: SnackPosition.BOTTOM,
                                      colorText: Colors.black);
                                }
                              }
                            : () async {
                                if (voiceRecProvider.isReset) {
                                  voiceRecProvider.isReset = false;
                                }
                                timer = Timer.periodic(
                                    const Duration(milliseconds: 1000),
                                    (timer) async {
                                  voiceRecProvider.timeInSec += 1;
                                  time = formatTime(voiceRecProvider.timeInSec);
                                  timerProvider.setDuration(time!);
                                  if (voiceRecProvider.timeInSec == 60) {
                                    widget.saveBinAudioToLocalDB(
                                        await getAudioPath());
                                    reset();
                                  }
                                  // });
                                });
                                await widget.recorder.record();
                                voiceRecProvider.onLongPressValue(context);
                              },
                        onLongPressStart: (startDetails) {
                          longPressStart = startDetails.globalPosition.dx;
                        },
                        onLongPressMoveUpdate: (details) async {
                          if (!isGranted) return;
                          if (voiceRecProvider.isReset) return;
                          if (details.globalPosition.dx > longPressStart)return;
                          if (MediaQuery.of(context).size.width * 0.30 <=
                              -details.offsetFromOrigin.dx) {
                            final String? path = await widget.recorder.stop();
                            try {
                              final audioFile = File(path!);
                              await audioFile.delete();
                            } catch (err) {
                              // print('File not found');
                            }
                            voiceRecProvider.isCancelled.value = true;
                            reset();
                            return;
                          }
                          voiceRecProvider.changeIconOffset(details, context);
                        },
                        onLongPressEnd: (details) async {
                          if (!isGranted || voiceRecProvider.isReset) return;
                          widget.saveBinAudioToLocalDB(await getAudioPath());
                          reset(false);
                        },
                        child: !voiceRecProvider.isLongPress.value
                            ? const SmallMicIcon()
                            : const BigMicIcon())));
          }),
        ),
        ValueListenableBuilder<bool>(
            valueListenable: voiceRecProvider.isCancelled,
            builder: (_, bool isCancelled, __) {
              return Positioned(
                  left: MediaQuery.of(context).size.width * 0.05,
                  bottom: 2,
                  child: ValueListenableBuilder<bool>(
                      valueListenable: voiceRecProvider.isCancelled,
                      builder: (_, bool isCancelled, __) => isCancelled
                          ? const DeleteVocRecAnim()
                          : const SizedBox()));
            })
      ],
    );
  }
}
