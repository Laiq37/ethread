import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:ethread_app/utils/config/font/font_size.dart';
import 'package:ethread_app/utils/config/theme/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ServiceTitleWidget extends StatelessWidget {
  final int index;
  final String? title;
  final String? address;
  const ServiceTitleWidget({Key? key,required this.index,required this.title, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin:  EdgeInsets.symmetric(horizontal: CustomPadding.padding16W,vertical: CustomPadding.padding10H),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CustomRadius.customRadius8),
      ),
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: CustomPadding.padding20H, horizontal: CustomPadding.padding32W),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Container(
                width: CustomWidth.width100,
                height: CustomHeight.height100,
                decoration: const BoxDecoration(
                  color: Colors.white, // border color
                  shape: BoxShape.circle,
                ),
                child: Container( // or ClipRRect if you need to clip the content
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).splashColor,
                    gradient:LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[
                        ThemeConfig().gradientDark,
                        ThemeConfig().gradientLight
                      ],
                    ),// inner circle color
                  ),
                  child: const Center(child: Icon(Icons.location_on,color: Colors.white,size: 70,)), // inner content
                ),
                ),
                 SizedBox(width: CustomWidth.width20,),
                Expanded(
                  child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Location ${index.toString().padLeft(2, '0')} ",
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).splashColor),
                        ),
                        SvgPicture.asset(
                      'assets/images/ic_progress.svg',
                      fit: BoxFit.contain,
                      height: CustomHeight.height20,
                  ),
                      ],
                    ),
                     SizedBox(height: CustomHeight.height4),
                    Text(
                      title ?? "",
                      style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: FontSize.font26),
                      maxLines: 1,
                    ),
                    Text(
                  address ?? "",
                  style:Theme.of(context).textTheme.subtitle2,
                  ),
                  ],
                  ),
                ),
          ],
        ),
      )
    );
  }
}
// Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
//         child: Column(
//           children: [
//             ListTile(       
//               leading: Container(
//                 width: 100,
//                 height: 100,
//                 decoration: const BoxDecoration(
//                   color: Colors.white, // border color
//                   shape: BoxShape.circle,
//                 ),
//                 child: Container( // or ClipRRect if you need to clip the content
//                   decoration:  BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Theme.of(context).splashColor,
//                     gradient:LinearGradient(
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter,
//                       colors: <Color>[
//                         ThemeConfig().gradientDark,
//                         ThemeConfig().gradientLight
//                       ],
//                     ),// inner circle color
//                   ),
//                   child: const Center(child: Icon(Icons.location_on,color: Colors.white,size: 40,)), // inner content
//                 ),
//               ),
//               title: Column(
//                 // mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Location ${index.toString().padLeft(2, '0')} ",
//                     style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).splashColor),
//                   ),
//                   const SizedBox(height: 4.0),
//                   Text(
//                     title ?? "",
//                     style: Theme.of(context).textTheme.headline2,
//                     maxLines: 1,
//                   )
//                 ],
//               ),
//               subtitle:  Text(
//                 address ?? "",
//                 style:Theme.of(context).textTheme.subtitle2,
//               ),
//               trailing: SvgPicture.asset(
//                   'assets/images/ic_progress.svg',
//                   fit: BoxFit.contain,
//                   height: 20,
//               ),
//             ),
//              if(notes != "")
//             Padding(
//               padding: const EdgeInsets.only(left:22.0),
//               child: Text("NOTE: $notes", style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.red, fontSize: 10),),
//             ),
//           ],
//         ),
//       ),