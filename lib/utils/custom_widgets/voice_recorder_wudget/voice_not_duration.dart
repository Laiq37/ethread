import 'package:ethread_app/utils/config/font/font_size.dart';
import 'package:flutter/material.dart';
import '../../../services/models/voice_recoder/value_notifier_timer.dart';

class VoiceNoteDuration extends StatelessWidget {
  const VoiceNoteDuration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TimerProvider timerProvider = TimerProvider();
    return ValueListenableBuilder(
      valueListenable: timerProvider.time,
      builder: (_, String time, __) => Text(
        time,
        // '00:00',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey[100], fontSize: FontSize.font15) 
      ),
    );
  }
}