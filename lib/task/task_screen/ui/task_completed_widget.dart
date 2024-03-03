import 'package:ethread_app/task/task_screen/ui/task_done_start_widget.dart';
import 'package:ethread_app/task/task_screen/ui/task_location_address_widget.dart';
import 'package:ethread_app/task/task_screen/ui/task_location_num_widget.dart';
import 'package:ethread_app/task/task_screen/ui/task_location_title_status_widget.dart';
import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:ethread_app/utils/config/theme/theme_config.dart';
import 'package:flutter/material.dart';

class TaskCompletedWidget extends StatelessWidget {
  final int index;
  final String title;
  final String address;
  const TaskCompletedWidget({required this.index, required this.title, required this.address, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      // margin: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10.0),
      color: Colors.green,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CustomRadius.customRadius16),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
              horizontal: CustomPadding.padding20W,),
        height: CustomHeight.height140,
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(CustomRadius.customRadius16),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: <Color>[
              ThemeConfig().gradientDark,
              ThemeConfig().gradientLight
            ],
          ),
        ),
        child: Row(children: [
          const TaskDoneStartWidget(text: "Done"),
          SizedBox(width: CustomWidth.width20,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TaskLocationNumWidget(num: index, isCompleted: true,),
                    SizedBox(height: CustomHeight.height4),
                    TaskLocationTitleStatusWidget(title: title, isCompleted: true,),
                    SizedBox(height: CustomHeight.height4),
                    TaskLocationAddressWidget(address: address, isCompleted: true,)
                  ],
                ),
              ),
            
        ],),
      ),
    );
  }
}