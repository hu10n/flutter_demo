import 'package:flutter/material.dart';

class ModalContentInQR extends StatefulWidget {
  const ModalContentInQR(
      {super.key, required this.stepStatus, required this.resumeScan});

  final Map stepStatus;
  final Function resumeScan;

  @override
  State<ModalContentInQR> createState() => _ModalContentInQRState();
}

class _ModalContentInQRState extends State<ModalContentInQR> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 100),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (widget.stepStatus['stepToStart'] != null)
              _createStartSheet(widget.stepStatus, () {
                Navigator.pop(context);
                widget.resumeScan();
              }, () {
                //Button Action (開始)
              }),
            if (widget.stepStatus['stepOnGoing'] != null)
              _createCompleteSheet(widget.stepStatus, () {
                Navigator.pop(context);
                widget.resumeScan();
              }, () {
                //Button Action (完了)
              }),
            if (widget.stepStatus['stepToStart'] == null &&
                widget.stepStatus['stepOnGoing'] == null)
              _createCompletedSheet(widget.stepStatus, () {
                Navigator.pop(context);
                widget.resumeScan();
              }, () {
                widget.resumeScan();
              }),
          ],
        ),
      ),
    );
  }

  Widget _createCompletedSheet(Map<dynamic, dynamic> stepStatus,
      VoidCallback closeAction, VoidCallback proceedAction) {
    // Adjust the information shown here since stepStatus['stepOnGoing'] will be null
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "完了済プロジェクト",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: closeAction,
              ),
            ],
          ),
          Text(
            '全てのステップが完了しました。',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700]),
          ),
          Center(
            child: ElevatedButton(
              onPressed: proceedAction,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: Text(
                  '閉じる',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  foregroundColor: MaterialStateProperty.all(Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createCompleteSheet(Map<dynamic, dynamic> stepStatus,
          VoidCallback closeAction, VoidCallback proceedAction) =>
      Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "完了報告を作成",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: closeAction,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STEP ${stepStatus['stepOnGoing']['step_num']}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                Text(
                  '担当工程: ${stepStatus['stepOnGoing']['step_name']}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]),
                ),
              ],
            ),
            Text(
              '作業者名: ${stepStatus['stepOnGoing']['worker']}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700]),
            ),
            // InputField("備考", ScrollController()),  // Need to be fixed
            Center(
              child: ElevatedButton(
                onPressed: proceedAction,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Text(
                    '作業完了',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
              ),
            ),
          ],
        ),
      );

  Widget _createStartSheet(Map<dynamic, dynamic> stepStatus,
          VoidCallback closeAction, VoidCallback proceedAction) =>
      Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "開始報告を作成",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: closeAction,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STEP ${stepStatus['stepToStart']['step_num']}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                Text(
                  '担当工程: ${stepStatus['stepToStart']['step_name']}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]),
                ),
              ],
            ),
            // InputField("作業者名", ScrollController()),  // Need to be fixed
            Center(
              child: ElevatedButton(
                onPressed: proceedAction,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Text(
                    '作業開始',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
              ),
            ),
          ],
        ),
      );
}
