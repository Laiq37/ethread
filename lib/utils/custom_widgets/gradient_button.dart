import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  const GradientButton({
    required Key key,
    required this.child,
    required this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CustomRadius.customRadius32),
      ),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(gradient: gradient,boxShadow: [
          BoxShadow(
            color: Colors.grey[500]!,
            offset: const Offset(0.0, 1.5),
            blurRadius: CustomRadius.customRadius1_5,
          ),
        ],),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap:() => onPressed(),
              child: Center(
                child: child,
              )),
        ),
      ),
    );
  }
}