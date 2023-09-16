import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alphabet Carousel',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AlphabetCarousel(),
    );
  }
}

class AlphabetCarousel extends StatefulWidget {
  @override
  _AlphabetCarouselState createState() => _AlphabetCarouselState();
}

class _AlphabetCarouselState extends State<AlphabetCarousel> {
  CarouselController _carouselController = CarouselController();
  ScrollController _listController = ScrollController();
  List<String> _alphabets = List.generate(26, (i) => String.fromCharCode(65 + i));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 50.0,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              _listController.jumpTo(index * 50.0); // 50.0 is the height of each list item
            },
          ),
          items: _alphabets.map((char) => Text(char)).toList(),
        ),
      ),
      body: ListView.builder(
        controller: _listController,
        itemCount: _alphabets.length,
        itemBuilder: (context, index) => ListTile(
          title: Text('Item ${_alphabets[index]}'),
        ),
        itemExtent: 50.0, // set the height of each list item
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _listController.addListener(() {
      int currentIndex = (_listController.offset / 50.0).round();
      _carouselController.animateToPage(currentIndex);
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }
}
