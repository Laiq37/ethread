import 'package:cached_network_image/cached_network_image.dart';
import 'package:ethread_app/services/models/user/user.dart';
import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:ethread_app/utils/helpers/dart_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TitleHeaderWidget extends StatefulWidget {
  final bool isHome;
  const TitleHeaderWidget({this.isHome = false, Key? key,}) : super(key: key);

  @override
  State<TitleHeaderWidget> createState() => _TitleHeaderWidgetState();
}

class _TitleHeaderWidgetState extends State<TitleHeaderWidget> {

  late Box<User> usersBox;

  @override
  void initState() {
    openBox();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:  EdgeInsets.symmetric(horizontal: CustomPadding.padding4W, vertical: CustomPadding.padding4W), // Border width
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: ClipOval(
                child: SizedBox.fromSize(
                  size:  Size.fromRadius(CustomRadius.customRadius35), // Image radius
                  child: CachedNetworkImage(
                    imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNR7FvvC_9X1l2xqi2rdkStAHaSRMmg89O_g&usqp=CAU",
                    placeholder: (context, url) =>
                        const CupertinoActivityIndicator(),
                    height: CustomHeight.height40,
                    width: CustomWidth.width40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
             SizedBox(width: CustomWidth.width8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'WELCOME ',
                          style: Theme.of(context).textTheme.headline1),
                      TextSpan(
                        text: '${usersBox.get(Constants.userBox)?.firstName ?? ''}!',
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: Theme.of(context).splashColor),
                      ),
                    ],
                  ),
                ),
                Text(
                 widget.isHome ? "Please Select Available Vehicle Below" : "Your Route for Today is Below",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w600),
                )
              ],
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(DartFunctions.getCurrentFormattedTime(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w600)),
                 SizedBox(width: CustomWidth.width8),
                const Icon(Icons.access_time_rounded, size: 20)
              ],
            ),
            Row(
              children: [
                Text(DartFunctions.getCurrentFormattedDate(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w600)),
                 SizedBox(width: CustomWidth.width8),
                const Icon(Icons.event_note_outlined, size: 20)
              ],
            ),
          ],
        )
      ],
    );
  }

  Future<void> openBox() async{
    usersBox = Hive.box<User>(Constants.userBox);
  }

}
