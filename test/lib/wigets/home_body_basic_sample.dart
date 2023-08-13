import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/HomeViewModel.dart';
import '../ui/body_ui_basic_sample.dart';

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) =>
          bodyUI(title: ['Page 1', 'Page 2', 'Page 3'][viewModel.currentIndex]),
    );
  }
}
