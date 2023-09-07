import 'package:flutter/material.dart';

class AlphabetSlider extends StatefulWidget {
  final ValueChanged<String> onAlphabetSelected;

  AlphabetSlider({required this.onAlphabetSelected});

  @override
  _AlphabetSliderState createState() => _AlphabetSliderState();
}

class _AlphabetSliderState extends State<AlphabetSlider> {
  double _sliderValue = 0;
  final List<String> alphabets = List.generate(26, (index) => String.fromCharCode(65 + index));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _sliderValue,
          onChanged: (value) {
            setState(() {
              _sliderValue = value;
            });
            widget.onAlphabetSelected(alphabets[value.toInt()]);
          },
          divisions: alphabets.length - 1,
          min: 0,
          max: alphabets.length - 1.0,
          label: alphabets[_sliderValue.toInt()],
        ),
        Text('Selected: ${alphabets[_sliderValue.toInt()]}'),
      ],
    );
  }
}