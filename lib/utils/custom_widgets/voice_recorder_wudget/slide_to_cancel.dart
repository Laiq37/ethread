

import 'package:ethread_app/utils/config/font/font_size.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../services/models/voice_recoder/value_notifier_timer.dart';

class VoiceNoteDuration extends StatelessWidget {
  const VoiceNoteDuration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TimerProvider timerProvider = TimerProvider();
    // print('rebuit VoiceNoteDuration');
    return ValueListenableBuilder(
      valueListenable: timerProvider.time,
      builder: (_, String time, __) => Text(
        time,
        // '00:00',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey[100], fontSize: FontSize.font15),
      ),
    );
  }
}

class SlideToCancel extends StatelessWidget {
  const SlideToCancel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('rebuit SlideToCancel');
    return Expanded(
      flex: 3,
      child: Shimmer.fromColors(
        direction: ShimmerDirection.rtl,
        highlightColor: Colors.grey[100]!,
        baseColor: Colors.grey[700]!,
        child: Text(
          '<    Slide to cancel',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey[100], fontSize: FontSize.font19) ,
        ),
      ),
    );
  }
}