import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:test/providers/DataProvider.dart';

class AlphabetCarousel extends StatefulWidget {
  final CarouselController controller;

  AlphabetCarousel({required this.controller});

  @override
  _AlphabetCarouselState createState() => _AlphabetCarouselState();
}

class _AlphabetCarouselState extends State<AlphabetCarousel> {
  int _current = 0; // カルーセルの選択インデックス

  @override
  Widget build(BuildContext context) {
    // ProviderのCount MapからAkphabetListを取得 ---------------------------
    final machineCardCount =
        Provider.of<DataNotifier>(context).machineCardCount;
    // print("object");
    final List<String> alphabetList = machineCardCount.keys.toList();
    // -------------------------------------------------------------------

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width, // スクリーンの幅を制約として使用
      ),
      child: CarouselSlider.builder(
        carouselController: widget.controller,
        itemCount: alphabetList.length,
        itemBuilder: (context, index, realIdx) {
          return GestureDetector(
            onTap: () {
              //print(DateTime.now());
              widget.controller.animateToPage(index);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  alphabetList[index],
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                if (_current == index)
                  Container(
                    margin: EdgeInsets.only(top: 0.0),
                    height: 4.0,
                    width: 50.0,
                    color: Theme.of(context).colorScheme.secondary,
                  )
              ],
            ),
          );
        },
        options: CarouselOptions(
          height: 42,
          viewportFraction: 0.175,
          enlargeCenterPage: false,
          enableInfiniteScroll: false,
          initialPage: 0,
          onPageChanged: (index, reason) {
            //print("pagechange:$index");
            _updateCurrentIndex(index);
          },
        ),
      ),
    );
  }

  void _updateCurrentIndex(int index) {
    setState(() {
      _current = index; //カルーセルバー更新
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataNotifier>(context, listen: false)
          .selectAlphabet(index); // 現在のスクロール位置更新
      //print("update");
      if (!Provider.of<DataNotifier>(context, listen: false).isScrollView) {
        //スクロールによるカルーセル遷移では発火しない。
        //print("do");
        Provider.of<DataNotifier>(context, listen: false)
            .turnSelectedFlag(true);
      }
    });
  }
}
