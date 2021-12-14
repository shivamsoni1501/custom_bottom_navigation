library custom_bottom_navigation;

import 'package:flutter/material.dart';

class CustomBottomBoxBar extends StatefulWidget {
  final double height;
  final List<CustomBottomBoxBarItem> items;
  final double barRadius;
  final double elevation;
  final int duration;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color selectedItemBoxColor;
  final Color unselectedItemBoxColor;
  final Function(int) onIndexChange;
  final int inicialIndex;

  const CustomBottomBoxBar(
      {Key? key,
      this.height = 70.0,
      this.inicialIndex = 0,
      this.barRadius = 0.0,
      this.elevation = 10.0,
      this.duration = 500,
      required this.items,
      required this.onIndexChange,
      this.selectedItemBoxColor = Colors.black,
      this.unselectedItemBoxColor = Colors.white,
      this.unselectedItemColor = Colors.black,
      this.selectedItemColor = Colors.white})
      : super(key: key);

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
            color: Colors.black54,
            blurRadius: widget.elevation,
          )
        ],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(widget.barRadius),
        ),
      ),
      height: widget.height,
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          widget.items.length,
          (index) => Expanded(
            child: _BarItem(
              index: index,
              height: widget.height,
              duration: widget.duration,
              item: widget.items[index],
              selectedC: widget.selectedItemBoxColor,
              unselectedC: widget.unselectedItemBoxColor,
              selectedItemColor: widget.selectedItemColor,
              unselectedItemColor: widget.unselectedItemColor,
              selectedIndex: (value) {
                selectedIndex = value;
                widget.onIndexChange(selectedIndex);
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

class CustomBottomBoxBarItem {
  final IconData icondata;
  final Text text;
  CustomBottomBoxBarItem(this.icondata, this.text);
}

class _BarItem extends StatefulWidget {
  final int index;
  final double height;
  final CustomBottomBoxBarItem item;
  final Color selectedC;
  final Color unselectedC;
  final int duration;
  final Color selectedItemColor;
  final Color unselectedItemColor;

  final Function(int) selectedIndex;
  final Function selectedIndexC;

  const _BarItem(
      {required this.index,
      required this.height,
      required this.item,
      required this.duration,
      required this.selectedC,
      required this.unselectedC,
      required this.selectedIndex,
      required this.selectedIndexC,
      required this.selectedItemColor,
      required this.unselectedItemColor});

  @override
  _BarItemState createState() => _BarItemState();
}

class _BarItemState extends State<_BarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  double PI = 3.14;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration));
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
                        Icon(widget.item.icondata,
                            color: widget.unselectedItemColor),
                        FittedBox(child: widget.item.text),
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
                        scale: 1 + .3 * _animation.value,
                        child: Icon(widget.item.icondata,
                            color: widget.selectedItemColor)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
