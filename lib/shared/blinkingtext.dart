import 'package:flutter/material.dart';

class BlinkingTextAnimation extends StatefulWidget {
  final String text;
   Color colour;
  BlinkingTextAnimation({
    this.text,
    this.colour,
    Key key,
  }):super(key:key);
  @override
  _BlinkingAnimationState createState() => _BlinkingAnimationState();
}

class _BlinkingAnimationState extends State<BlinkingTextAnimation>
  with SingleTickerProviderStateMixin {
  Animation<Color> animation;
  AnimationController controller;
 
  initState() {
    super.initState();
 
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
 
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.ease);
 
    animation =
        ColorTween(begin: Colors.white, end: widget.colour).animate(curve);
 
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
      setState(() {});
    });
 
    controller.forward();
  }
 
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          return new Container(
            child: Text(widget.text,
                style: TextStyle(color: animation.value, fontSize: 40)),
          );
        });
  }
 
  dispose() {
    controller.dispose();
    super.dispose();
  }
}