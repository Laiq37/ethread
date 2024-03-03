import 'package:ethread_app/services/models/voice_recoder/voice_rec_provider.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:flutter/material.dart';
import 'animated_mic_icon.dart';
import 'slide_to_cancel.dart';

class TimeAndSlide extends StatelessWidget {
  const TimeAndSlide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VoiceRecProvider voiceRecProvider = VoiceRecProvider();
    // print('timeslider rebuilt');
    // print(time);
    return ValueListenableBuilder(
      valueListenable: voiceRecProvider.isLongPress,
      builder: (_, bool isLongPress, ch) {
      return AnimatedContainer(
        margin: EdgeInsets.only(
            left: voiceRecProvider.margin, bottom: voiceRecProvider.margin),
        decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius:  BorderRadius.only(
                topLeft: Radius.circular(CustomRadius.customRadius15), bottomLeft: Radius.circular(CustomRadius.customRadius15))),
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInToLinear,
        width: voiceRecProvider.width,
        height: voiceRecProvider.height,
        child: isLongPress ? ch : const SizedBox(),
      );
      }, 
      child: Row(
        children: const [
          // const Expanded(flex: 1, child: AnimatedMicIcon()),
          Expanded(flex: 1, child: AnimatedMicIcon()),
          Expanded(
            flex: 1,
            child: VoiceNoteDuration(),
          ),
          SlideToCancel(),
        ],
      ),
    );
  }
}