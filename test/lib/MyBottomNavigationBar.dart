import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final Function(int) onTap;

  MyBottomNavigationBar({required this.onTap});

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
                  Icons.home_sharp,
                  size: kToolbarHeight * .6,
                ),
                onPressed: () => onTap(0),
              ),
              IconButton(
                icon: Icon(Icons.qr_code_scanner_sharp,
                    size: kToolbarHeight * .6),
                onPressed: () => onTap(1),
              ),
              IconButton(
                icon: Icon(Icons.settings_sharp, size: kToolbarHeight * .6),
                onPressed: () => onTap(2),
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
