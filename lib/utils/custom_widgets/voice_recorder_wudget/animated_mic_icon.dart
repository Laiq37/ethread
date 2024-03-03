import 'package:flutter/material.dart';

class AnimatedMicIcon extends StatefulWidget {
  const AnimatedMicIcon({Key? key}) : super(key: key);

  @override
  State<AnimatedMicIcon> createState() => _AnimatedMicIconState();
}

class _AnimatedMicIconState extends State<AnimatedMicIcon>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // print("initstate");
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    // print('in dispose');
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: const Icon(Icons.mic, color: Colors.red, size: 24),
    );
  }
}