import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../DataClass.dart';

class AlphabetCarousel extends StatefulWidget {
  final CarouselController controller;

  AlphabetCarousel({required this.controller});

  @override
  _AlphabetCarouselState createState() => _AlphabetCarouselState();
}

class _AlphabetCarouselState extends State<AlphabetCarousel> {
  int _current = 0; // カルーセルの選択インデックス

  final List<String> alphabetList = // 暫定リスト。あとで変更
      List.generate(3, (index) => String.fromCharCode(65 + index));

  @override
  Widget build(BuildContext context) {
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
              widget.controller.animateToPage(index);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  alphabetList[index],
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                if (_current == index)
                  Container(
                    margin: EdgeInsets.only(top: 0.0),
                    height: 4.0,
                    width: 70.0,
                    color: Colors.blue,
                  )
              ],
            ),
          );
        },
        options: CarouselOptions(
          height: 42,
          viewportFraction: 0.2,
          enlargeCenterPage: false,
          enableInfiniteScroll: false,
          initialPage: 0,
          onPageChanged: (index, reason) {
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
      Provider.of<DataNotifier>(context, listen: false).selectAlphabet(index); // 現在のスクロール位置更新
      if(!Provider.of<DataNotifier>(context, listen: false).isScrollView){ //スクロールによるカルーセル遷移では発火しない。
        Provider.of<DataNotifier>(context, listen: false).turnSelectedFlag(true); 
      }
    }); 
  }
}