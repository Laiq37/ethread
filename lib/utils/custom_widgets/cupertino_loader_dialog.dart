import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:flutter/cupertino.dart';

class CupertinoLoaderDialog extends StatelessWidget {
  const CupertinoLoaderDialog({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  CupertinoAlertDialog(
      title: const Text('Loading..'),
      content:  Padding(
        padding: EdgeInsets.symmetric(horizontal: CustomPadding.padding16W, vertical: CustomPadding.padding16H),
        child: CupertinoActivityIndicator(radius: CustomRadius.customRadius16,),
      ),
    );
  }
}

