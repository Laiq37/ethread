import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaskLocationTitleStatusWidget extends StatelessWidget {
  final String title;
  final bool isCompleted;
  const TaskLocationTitleStatusWidget(
      {required this.title, this.isCompleted = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: isCompleted ? CustomWidth.width270 : CustomWidth.width250,
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: isCompleted ? Colors.white : null),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            isCompleted
                ? const Icon(Icons.check_circle, color: Colors.white)
                : SvgPicture.asset(
                    "assets/images/ic_pending.svg",
                    height: CustomHeight.height20,
                    fit: BoxFit.scaleDown,
                  ),
            SizedBox(width: CustomWidth.width10),
            Text(
              isCompleted ? "Completed" : "Pending",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: isCompleted ? Colors.white : Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}