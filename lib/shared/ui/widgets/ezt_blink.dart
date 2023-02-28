import 'package:flutter/material.dart';

class EZTBlink extends StatefulWidget {
  final List<Widget> children;
  final int interval;
  const EZTBlink({required this.children, this.interval = 500, super.key});

  @override
  State<EZTBlink> createState() => _EZTBlinkState();
}

class _EZTBlinkState extends State<EZTBlink>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentWidget = 0;

  @override
  initState() {
    super.initState();

    _controller = AnimationController(
        duration: Duration(milliseconds: widget.interval), vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          if (++_currentWidget == widget.children.length) {
            _currentWidget = 0;
          }
        });

        _controller.forward(from: 0.0);
      }
    });

    _controller.forward();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.children[_currentWidget],
    );
  }
}
