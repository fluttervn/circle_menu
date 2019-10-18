import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

typedef MenuClicked(BuildContext context, MenuData menuData);

class MenuData {
  IconData icon;
  String labelText;
  MenuClicked onClick;
  bool enable;

  MenuData(this.icon, this.onClick, {this.labelText, this.enable = true})
      : assert(icon != null),
        assert(labelText != null && labelText.isNotEmpty);
}

class CircleMenu extends StatefulWidget {
  final List<MenuData> menus;

  CircleMenu({this.menus}) : assert(menus != null);

  @override
  _CircleMenuState createState() => _CircleMenuState();
}

class _CircleMenuState extends State<CircleMenu> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200))
      ..addStatusListener((state) {
        print('listener...');
        switch (state) {
          case AnimationStatus.forward:
            {
              setState(() {});
              break;
            }
          case AnimationStatus.dismissed:
            {
              setState(() {});
              break;
            }
          default:
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildButton();
  }

  _buildButton() {
    return Container(
//      color: Colors.blue,
      child: new Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: new List.generate(widget.menus.length, (int index) {
            print('index: $index');
            Widget child = new Container(
//              color: Colors.red,
              height: 60.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: new CurvedAnimation(
                  parent: _controller,
                  curve: new Interval(
                      0.0, 1.0 - index / widget.menus.length / 2.0,
                      curve: Curves.easeOut),
                ),
                child: new FloatingActionButton(
                    heroTag: 'menuFab$index',
                    backgroundColor: widget.menus[index].enable
                        ? Colors.white
                        : Colors.grey[100],
                    mini: true,
                    tooltip: widget.menus[index].labelText,
                    child: new Icon(
                      widget.menus[index].icon,
                      color: widget.menus[index].enable
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    onPressed: () {
                      print('oopen...');
                      if (!_controller.isDismissed) _controller.reverse();
                      Navigator.of(context).pop();
                      widget.menus[index].onClick(context, widget.menus[index]);
                    }),
              ),
            );
            return child;
          }).toList()
            ..add(Container(
//              color: Colors.green,
              width: 60,
              height: 60,
              child: new FloatingActionButton(
                  heroTag: 'mainFab',
                  backgroundColor: Theme.of(context).primaryColor,
                  child: new AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return new Transform(
                          transform: new Matrix4.rotationZ(
                              _controller.value * 0.5 * math.pi),
                          alignment: FractionalOffset.center,
                          child: new Icon(
                            _controller.isDismissed ? Icons.add : Icons.close,
                            color: Colors.white,
                          ),
                        );
                      }),
                  onPressed: () {
                    if (_controller.isDismissed) {
                      print('oopen1...');
                      _controller.forward();
                    } else {
                      print('oopen2...');
                      _controller.reverse();
                      Navigator.of(context).pop();
                    }
                  }),
            )),
        ),
      ),
    );
  }
}
