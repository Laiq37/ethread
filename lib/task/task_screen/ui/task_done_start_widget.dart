import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:ethread_app/utils/config/theme/theme_config.dart';
import 'package:flutter/material.dart';

class TaskDoneStartWidget extends StatelessWidget {
  final String text;
  const TaskDoneStartWidget({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CustomWidth.width80,
      height: CustomHeight.height80,
      decoration: const BoxDecoration(
        // border color
        shape: BoxShape.circle,
      ),
      child: Container(
        // or ClipRRect if you need to clip the content
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: text == "Done" ? Colors.white : null,
          gradient: text == "Start"
              ? LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[
                    ThemeConfig().gradientDark,
                    ThemeConfig().gradientLight
                  ],
                )
              : null, // inner circle color
        ),
        child: Center(
          child: Text(text,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: text == "Start" ? Colors.white : null)),
        ),
      ),
    );
  }
}
