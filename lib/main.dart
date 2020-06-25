import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/animation.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: new TestPage('Test'),
    );
  }
}

class TestPage extends StatefulWidget {
  final String title;

  TestPage(this.title);

  @override
  _TestPageState createState() => new _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  Color _background;
  Color _oldBackground;
  Color _textColor;

  double _positionX;
  double _positionY;

  double _size = 1600;

  AnimationController _controller;
  Animation<double> _animation;

  changeBackground(TapDownDetails details) {
    animate();
    var rand = new Random();
    setState(() {
      _background = Color.fromARGB(255, rand.nextInt(256), rand.nextInt(256), rand.nextInt(256));
      _textColor = _background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
      _positionX = details.globalPosition.dx - _size / 2;
      _positionY = details.globalPosition.dy - 100 - _size / 2;
      print("tap down " + _positionX.toString() + ", " + _positionY.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    animate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: _oldBackground,
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: Stack(children: <Widget>[
          AnimatedPositioned(
            left: _positionX,
            top: _positionY,
            duration: Duration(seconds: 0),
            child: Container(
                color: _oldBackground,
                child: ScaleTransition(
                  scale: _animation,
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    width: _size,
                    height: _size,
                    decoration: new BoxDecoration(
                      color: _background,
                      shape: BoxShape.circle,
                    ),
                  ),
                )),
          ),
          new Center(
              child: Text(
            'Hey there',
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: _textColor),
          )),
          new GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (TapDownDetails details) => changeBackground(details),
          )
        ]));
  }

  animate() {
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _oldBackground = _background;

    _controller.forward();
  }
}
