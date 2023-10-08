//開始報告用入力フォーム

import 'package:flutter/material.dart';

import 'package:test/GlobalWidget/BuildTitleForModal.dart';

class ModalContentForClosed extends StatefulWidget {
  final Function onScrollUp;
  final Map stepInfoMap;

  const ModalContentForClosed({
    Key? key,
    required this.stepInfoMap,
    required this.onScrollUp,
  }) : super(key: key);

  @override
  _ModalContentForClosedState createState() => _ModalContentForClosedState();
}

class _ModalContentForClosedState extends State<ModalContentForClosed> {
  List<FocusNode> _focuses = [FocusNode()];

  void _unfocus() {
    for (var focus in _focuses) {
      if (focus.hasFocus) {
        focus.unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            BuildTitleForModal(context, widget.onScrollUp, "全ての工程が完了済み"),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 70.0,
                ),
                child: ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 25.0,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Name: ${widget.stepInfoMap['machine_name']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              bottom: 20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(
                          MediaQuery.of(context).size.width * 0.9,
                          40.0,
                        ),
                      ),
                    ),
                    child: Text('閉じる'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
