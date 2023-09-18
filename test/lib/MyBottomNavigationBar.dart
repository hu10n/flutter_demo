import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final Function(int) onTap;
  final int selectedIndex;

  MyBottomNavigationBar({required this.onTap, required this.selectedIndex});

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: kToolbarHeight + safePadding,
      color: Colors.grey[100],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  widget.selectedIndex == 0
                      ? Icons.home // 選択されている場合のアイコン
                      : Icons.home_outlined, // 選択されていない場合のアイコン
                  size: kToolbarHeight * .6,
                ),
                onPressed: () {
                  widget.onTap(0);
                },
              ),
              IconButton(
                icon: Icon(
                  widget.selectedIndex == 1
                      ? Icons.qr_code_scanner
                      : Icons.qr_code_scanner_rounded,
                  size: kToolbarHeight * .6,
                ),
                onPressed: () {
                  widget.onTap(1);
                },
              ),
              IconButton(
                icon: Icon(
                  widget.selectedIndex == 2
                      ? Icons.settings
                      : Icons.settings_outlined,
                  size: kToolbarHeight * .6,
                ),
                onPressed: () {
                  widget.onTap(2);
                },
              ),
            ],
          ),
          SizedBox(
            height: safePadding,
          )
        ],
      ),
    );
  }
}
