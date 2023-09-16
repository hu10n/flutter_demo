import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../DataClass.dart';

class AlphabetCarousel extends StatefulWidget {
  final Function(int) onAlphabetSelected;

  final CarouselController controller;

  AlphabetCarousel({required this.onAlphabetSelected,required this.controller});

  @override
  _AlphabetCarouselState createState() => _AlphabetCarouselState();
}

class _AlphabetCarouselState extends State<AlphabetCarousel> {
  int _current = 0; // カルーセルの選択インデックス
  bool _wasTapped = false; // カルーセルをタップ時の動作制御用

  //final CarouselController _carouselController = CarouselController();

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
              _wasTapped = true;

              widget.controller.animateToPage(index);

              updateCurrentIndex(index);
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
            if (_wasTapped) {
              // タップされた場合のみ、このロジックをスキップ
              _wasTapped = false; // フラグをリセット
              return; // ここで終了
            }
            print(index);
            updateCurrentIndex(index);
          },
        ),
      ),
    );
  }

  void updateCurrentIndex(int index) {
    setState(() {
      _current = index;
    });

    //WidgetsBinding.instance.addPostFrameCallback((_) {
            //Provider.of<DataNotifier>(context, listen: false).selectAlphabet(index);
            //print("start");
          //});
    //widget.onAlphabetSelected(alphabetList[index]);
    widget.onAlphabetSelected(index);
  }
}
