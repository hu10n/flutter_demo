import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/HomeViewModel.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) => BottomNavigationBar(
        currentIndex: viewModel.currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) => viewModel.changeCurrentIndex(index),
      ),
    );
  }
}
