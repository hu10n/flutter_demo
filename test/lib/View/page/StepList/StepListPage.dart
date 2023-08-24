import 'package:flutter/material.dart';
import 'StepListSliverList.dart';

class StepListPage extends StatefulWidget {
  final String machineNumber;

  StepListPage({required this.machineNumber});

  @override
  _StepListPageState createState() => _StepListPageState();
}

class _StepListPageState extends State<StepListPage> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      child: Container(
        color: Colors.grey[200],
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Machine ${widget.machineNumber} Step List'),
              ),
            ),
            StepListSliverList(machineNumber: widget.machineNumber)
          ],
        ),
      ),
    );
  }
}
