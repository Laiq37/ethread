import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskLocationAddressWidget extends StatelessWidget {
  final String address;
  final bool isCompleted;
  const TaskLocationAddressWidget(
      {required this.address, this.isCompleted = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 16.r,
          color: isCompleted ? Colors.white : null,
        ),
        SizedBox(
          width: CustomWidth.width4,
        ),
        Expanded(
          child: Text(
            address,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: isCompleted ? Colors.white : null),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
