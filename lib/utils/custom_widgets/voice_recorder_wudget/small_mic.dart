import 'package:ethread_app/utils/config/theme/theme_config.dart';
import 'package:flutter/material.dart';
import '../../../services/models/voice_recoder/voice_rec_provider.dart';

class SmallMicIcon extends StatelessWidget {
  // final double radius;

  const SmallMicIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VoiceRecProvider voiceRecProvider = VoiceRecProvider();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[
                      ThemeConfig().gradientDark,
                      ThemeConfig().gradientLight
                    ],
                  ),
        borderRadius: BorderRadius.circular(voiceRecProvider.micIconRadius(context)),
      ),
      child: CircleAvatar(
        radius: voiceRecProvider.micIconRadius(context),
        child: Icon(
          Icons.settings_voice_outlined,
          color: Colors.white,
          size: voiceRecProvider.micIconRadius(context),
        ),
      ),
    );
  }
}