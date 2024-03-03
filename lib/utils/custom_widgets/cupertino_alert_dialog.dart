import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CustomIosDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? callback;

  const CustomIosDialog(
      {required this.title, required this.message, this.callback, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text("Ok"),
          onPressed: callback ??
              () {
                if (Get.isDialogOpen!) {
                  Get.back();
                }
              },
        ),
      ],
    );
  }
}
