import 'package:flutter/material.dart';

class ToggleButtonsWidget extends StatefulWidget {
  final Function(int) onToggleSelected;
  ToggleButtonsWidget({required this.onToggleSelected});

  @override
  _ToggleButtonsWidgetState createState() => _ToggleButtonsWidgetState();
}

class _ToggleButtonsWidgetState extends State<ToggleButtonsWidget> {
  List<bool> isSelected = [true, false, false, false]; // 初期選択状態

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      children: [
        Text("すべて"),
        Text("稼働中"),
        Text("未稼働"),
        Text("その他"),
      ],
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
            if (isSelected[i]) {
              switch (i) {
                case 0:
                  // iが0のときの処理: status=-1(All)
                  widget.onToggleSelected(-1);
                  break;
                case 1:
                  // iが1のときの処理: status=0(稼働中)
                  widget.onToggleSelected(0);
                  break;
                case 2:
                  // iが2のときの処理: status=1(未稼働)
                  widget.onToggleSelected(1);
                  break;
                case 3:
                  // iが3のときの処理
                  widget.onToggleSelected(2);
                  break;
                default:
                  // それ以外の場合の処理（必要な場合のみ)
                  widget.onToggleSelected(-1);
                  break;
              }
            }
          }
        });
      },
      isSelected: isSelected,
      color: Theme.of(context).canvasColor, // 2. 非選択時のアイコン色
      selectedColor: Theme.of(context).canvasColor, // 2. 選択時のアイコン色
      fillColor: Theme.of(context).disabledColor, // 2. 選択時の背景色
      borderWidth: 2, // 2. 非選択時のボーダーの幅
      constraints: BoxConstraints(minHeight: 30, minWidth: 70),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
