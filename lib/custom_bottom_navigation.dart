library custom_bottom_navigation;

import 'package:flutter/material.dart';
import 'dart:math';

class CustomBottomBoxBar extends StatefulWidget {
  final double height;
  final List<Widget> items;
  final double barRadius;
  final List<Text> itemText;
  final Color selectedItemBoxColor;
  final Color unselectedItemBoxColor;
  final Function(int) selectedIndex;
  final int inicialIndex;

  CustomBottomBoxBar(
      {this.height = 70,
      this.inicialIndex = 0,
      this.barRadius = 20.0,
      required this.items,
      required this.itemText,
      required this.selectedIndex,
      this.selectedItemBoxColor = Colors.purpleAccent,
      this.unselectedItemBoxColor = Colors.deepPurpleAccent});

  @override
  _CustomBottomBoxBarState createState() => _CustomBottomBoxBarState();
}

class _CustomBottomBoxBarState extends State<CustomBottomBoxBar> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.inicialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.unselectedItemBoxColor,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            offset: const Offset(0, -5),
            spreadRadius: 5,
            blurRadius: 10,
          )
        ],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(widget.barRadius),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: List.generate(
          widget.items.length,
          (index) => Expanded(
            child: BarItem(
              index: index,
              height: widget.height,
              item: widget.items[index],
              text: widget.itemText[index],
              selectedC: widget.selectedItemBoxColor,
              unselectedC: widget.unselectedItemBoxColor,
              selectedIndex: (value) {
                selectedIndex = value;
                widget.selectedIndex(selectedIndex);
                setState(() {});
              },
              selectedIndexC: () => selectedIndex,
            ),
          ),
        ),
      ),
    );
  }
}

class BarItem extends StatefulWidget {
  final int index;
  final double height;
  final Widget item;
  final Text text;
  final Color selectedC;
  final Color unselectedC;

  final Function(int) selectedIndex;
  final Function selectedIndexC;

  const BarItem(
      {Key? key,
      required this.index,
      required this.height,
      required this.item,
      required this.text,
      required this.selectedC,
      required this.unselectedC,
      required this.selectedIndex,
      required this.selectedIndexC})
      : super(key: key);

  @override
  _BarItemState createState() => _BarItemState();
}

class _BarItemState extends State<BarItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  double PI = pi;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeInCirc);
    _controller.addListener(() {
      setState(() {});
    });
    if (widget.selectedIndexC() == widget.index) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isCompleted) {
      if (widget.selectedIndexC() != widget.index) {
        _controller.reverse();
      }
    }
    return GestureDetector(
      onTap: () {
        widget.selectedIndex(widget.index);
        _controller.forward();
      },
      child: SizedBox(
        height: widget.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Transform.translate(
              offset: Offset(0, (widget.height) * _animation.value),
              child: Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, .001)
                  ..rotateX(PI / 2 * (_animation.value)),
                child: Opacity(
                  opacity: .9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.unselectedC,
                      // border: Border.all(color: widget.selectedC)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.item,
                        FittedBox(child: widget.text),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_animation.value >= 0)
              Transform.translate(
                offset: Offset(0, (-widget.height) * (1 - _animation.value)),
                child: Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, .001)
                    ..rotateX(-(PI / 2) * (1 - _animation.value)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: widget.selectedC,
                        border: Border.all(color: widget.selectedC)),
                    child: Transform.scale(
                        scale: 1 + .3 * _animation.value, child: widget.item),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
