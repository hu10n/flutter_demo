import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/HomeViewModel.dart';

class TopNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return SliverAppBar(
          expandedHeight: 150.0,
          floating: true,
          pinned: false,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(['Page 1', 'Page 2', 'Page 3'][viewModel.currentIndex]),
            
          ),
        );
      },
    );
  }
}
