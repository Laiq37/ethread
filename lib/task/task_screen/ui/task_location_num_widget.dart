import 'package:flutter/material.dart';

class TaskLocationNumWidget extends StatelessWidget {
  final int num;
  final bool isCompleted;
  const TaskLocationNumWidget({required this.num, this.isCompleted =false, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
                      "Location ${num.toString().padLeft(2, '0')} ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(
                              color: isCompleted ? Colors.white : Theme.of(context).splashColor,
                              fontWeight: FontWeight.w600),
                       
                    );
  }
}