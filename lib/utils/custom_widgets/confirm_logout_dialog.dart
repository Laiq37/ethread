import 'package:ethread_app/utils/helpers/dart_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmLogoutDialog extends StatelessWidget {
  const ConfirmLogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "Log out?",
        style: Theme.of(context).textTheme.headline3,
      ),
      content: Text(
        "Are you sure you want to log out?",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child:
                Text("Cancel", style: Theme.of(context).textTheme.bodyText2)),
        CupertinoDialogAction(
            isDefaultAction: false,
            onPressed: () {
              /* Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  const LoginScreen()), (Route<dynamic> route) => false);*/
              DartFunctions.logout();
            },
            child: Text("Log out",
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: Colors.red, fontWeight: FontWeight.bold))),
      ],
    );
  }
}
