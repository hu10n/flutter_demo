import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/HomeViewModel.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) =>
            Text(['Page A', 'Page B', 'Page C'][viewModel.currentIndex]),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
