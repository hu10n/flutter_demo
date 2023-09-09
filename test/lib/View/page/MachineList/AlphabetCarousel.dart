import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AlphabetCarousel extends StatefulWidget {
  final Function(String) onAlphabetSelected;

  AlphabetCarousel({required this.onAlphabetSelected});


  @override
  _AlphabetCarouselState createState() => _AlphabetCarouselState();
}

class _AlphabetCarouselState extends State<AlphabetCarousel> {
  int _current = 0; 
  bool _wasTapped = false;
  final CarouselController _carouselController = CarouselController();
  
  final List<String> alphabetList = List.generate(26, (index) => String.fromCharCode(65 + index));

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      carouselController: _carouselController,
      itemCount: alphabetList.length,
      itemBuilder: (context, index, realIdx) {
        return GestureDetector(
          onTap: () {
            _wasTapped = true;

            _carouselController.animateToPage(index);

            updateCurrentIndex(index);
          },
          child: Column(
            children: [
              Text(
                alphabetList[index],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (_current == index) Container(
                margin: EdgeInsets.only(top: 8.0),
                height: 4.0,
                width: 70.0,
                color: Colors.blue,
              )
            ],
          ),
        );
      },
      options: CarouselOptions(
        height: 50, 
        viewportFraction: 0.2,
        enlargeCenterPage: false,
        enableInfiniteScroll: false,
        initialPage: 0,
        onPageChanged: (index, reason) {
          if (_wasTapped) { // タップされた場合のみ、このロジックをスキップ
            _wasTapped = false; // フラグをリセット
            return; // ここで終了
          }
          updateCurrentIndex(index);
        },
        
      ),
    );
  }
  void updateCurrentIndex(int index) {
    setState(() {
      _current = index;
    });
    widget.onAlphabetSelected(alphabetList[index]);
  }
}