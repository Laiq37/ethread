import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../../../services/models/voice_recoder/voice_rec_provider.dart';

class DeleteVocRecAnim extends StatefulWidget {
  const DeleteVocRecAnim({Key? key}) : super(key: key);

  @override
  State<DeleteVocRecAnim> createState() => _DeleteVocRecAnimState();
}

class _DeleteVocRecAnimState extends State<DeleteVocRecAnim>
    with SingleTickerProviderStateMixin {
  late Timer timer;

  late AnimationController _animationController;

  final VoiceRecProvider voiceRecProvider = VoiceRecProvider();

  //Mic
  late Animation<double> _micTranslateTop;
  late Animation<double> _micRotationFirst;
  late Animation<double> _micTranslateRight;
  late Animation<double> _micTranslateLeft;
  late Animation<double> _micRotationSecond;
  late Animation<double> _micTranslateDown;
  late Animation<double> _micInsideTrashOpacity;

  //Trash Can
  late Animation<double> _trashWithCoverTranslateTop;
  late Animation<double> _trashCoverRotationFirst;
  late Animation<double> _trashCoverTranslateLeft;
  late Animation<double> _trashCoverRotationSecond;
  late Animation<double> _trashCoverTranslateRight;
  late Animation<double> _trashWithCoverTranslateDown;
  late Animation<double> _trashWithCoverOutOpacity;
  late Animation<double> _trashWithCoverInOpacity;

  @override
  void initState() {
    super.initState();

    timer = Timer(const Duration(milliseconds: 3000),
        () => voiceRecProvider.isCancelled.value = false);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    //Mic

    _micTranslateTop = Tween(begin: 0.0, end: -20.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _micRotationFirst = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.2),
      ),
    );

    _micTranslateRight = Tween(begin: 0.0, end: 13.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.1),
      ),
    );

    _micTranslateLeft = Tween(begin: 0.0, end: -13.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.2),
      ),
    );

    _micRotationSecond = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.45),
      ),
    );

    _micTranslateDown = Tween(begin: 0.0, end: 24.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.45, 0.79, curve: Curves.easeInOut),
      ),
    );

    _micInsideTrashOpacity = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.8, 0.9, curve: Curves.easeInOut),
      ),
    );

    //Trash Can

    _trashWithCoverTranslateTop = Tween(begin: 25.0, end: -10.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.45, 0.6),
      ),
    );

    _trashWithCoverInOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7),
      ),
    );

    _trashWithCoverOutOpacity = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.95, 1),
      ),
    );

    _trashCoverRotationFirst = Tween(begin: 0.0, end: -pi / 3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 0.7),
      ),
    );

    _trashCoverTranslateLeft = Tween(begin: 0.0, end: -18.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 0.7),
      ),
    );

    _trashCoverRotationSecond = Tween(begin: 0.0, end: pi / 3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.8, 0.9),
      ),
    );

    _trashCoverTranslateRight = Tween(begin: 0.0, end: 18.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.8, 0.9),
      ),
    );

    _trashWithCoverTranslateDown = Tween(begin: 0.0, end: 25.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.91, 0.97, curve: Curves.easeInOut),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() { 
    _animationController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..translate(0.0, 10)
                ..translate(_micTranslateRight.value)
                ..translate(_micTranslateLeft.value)
                ..translate(0.0, _micTranslateTop.value)
                ..translate(0.0, _micTranslateDown.value),
              child: Transform.rotate(
                angle: _micRotationFirst.value,
                child: Transform.rotate(
                  angle: _micRotationSecond.value,
                  child: Opacity(opacity: _micInsideTrashOpacity.value, child: child),
                ),
              ),
            );
          },
          child: const Icon(
            Icons.mic,
            color: Color(0xFFef5552),
            size: 20,
          ),
        ),
        AnimatedBuilder(
            animation: _trashWithCoverTranslateTop,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()..translate(0.0, _trashWithCoverTranslateTop.value)..translate(0.0, _trashWithCoverTranslateDown.value),
                child: Opacity(opacity: _trashWithCoverInOpacity.value,child: Opacity(opacity: _trashWithCoverOutOpacity.value,child: child)),
              );
            },
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _trashCoverRotationFirst,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..translate(_trashCoverTranslateLeft.value)
                        ..translate(_trashCoverTranslateRight.value),
                      child: Transform.rotate(
                        angle: _trashCoverRotationSecond.value,
                        child: Transform.rotate(
                          angle: _trashCoverRotationFirst.value,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: const Image(
                    image: AssetImage('assets/images/trash_cover.png'),
                    width: 22,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 1.5),
                  child: Image(
                    image: AssetImage('assets/images/trash_container.png'),
                    width: 22,
                  ),
                ),
              ],
            )),
      ],
    );
  }
}