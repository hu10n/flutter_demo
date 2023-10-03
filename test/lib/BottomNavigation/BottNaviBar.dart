import 'package:flutter/material.dart';

class BottNaviBar extends StatefulWidget {
  final Function(int) onTap;
  final int selectedIndex;

  BottNaviBar({required this.onTap, required this.selectedIndex});

  @override
  _BottNaviBarState createState() => _BottNaviBarState();
}

class _BottNaviBarState extends State<BottNaviBar> {
  late List<double> scales;

  @override
  void initState() {
    super.initState();
    scales = List.filled(3, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: kToolbarHeight + safePadding,
      color: Colors.grey[100],
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(3, (index) {
                final isSelected = widget.selectedIndex == index;
                final iconData = isSelected
                    ? [Icons.home, Icons.qr_code_scanner, Icons.settings][index]
                    : [
                        Icons.home_outlined,
                        Icons.qr_code_scanner_rounded,
                        Icons.settings_outlined
                      ][index];
                final color = isSelected ? Colors.black : Colors.grey[700];

                return GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      scales[index] = 0.8;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      scales[index] = 1.0;
                    });
                    widget.onTap(index);
                  },
                  onTapCancel: () {
                    setState(() {
                      scales[index] = 1.0;
                    });
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: scales[index],
                      child: Icon(
                        iconData,
                        size: kToolbarHeight * .6,
                        color: color,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(
            height: safePadding,
          )
        ],
      ),
    );
  }
}
