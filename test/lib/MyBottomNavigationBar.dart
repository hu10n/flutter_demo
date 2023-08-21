import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final Function(int) onTap;

  MyBottomNavigationBar({required this.onTap});

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0; // 選択されているアイコンのインデックス

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
                  _selectedIndex == 0
                      ? Icons.home_sharp // 選択されている場合のアイコン
                      : Icons.home_outlined, // 選択されていない場合のアイコン
                  size: kToolbarHeight * .6,
                ),
                onPressed: () {
                  widget.onTap(0);
                  _handleIconSelection(0);
                },
              ),
              IconButton(
                icon: Icon(
                  _selectedIndex == 1
                      ? Icons.qr_code_scanner_sharp
                      : Icons.qr_code_scanner_rounded,
                  size: kToolbarHeight * .6,
                ),
                onPressed: () {
                  widget.onTap(1);
                  _handleIconSelection(1);
                },
              ),
              IconButton(
                icon: Icon(
                  _selectedIndex == 2
                      ? Icons.settings_sharp
                      : Icons.settings_outlined,
                  size: kToolbarHeight * .6,
                ),
                onPressed: () {
                  widget.onTap(2);
                  _handleIconSelection(2);
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

  void _handleIconSelection(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
