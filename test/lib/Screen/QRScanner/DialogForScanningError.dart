import 'package:flutter/material.dart';

class QRErrorDialog extends StatelessWidget {
  final String errorMessage;

  QRErrorDialog({
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Text(
        'エラー',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.redAccent,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.redAccent,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "不正なQRコードをスキャン、またはスキャン時に問題が発生しました。管理者に問い合わせてください。",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "Error Message",
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
          Text(
            errorMessage,
            style: TextStyle(
              color: Colors.grey[500],
              fontFamily: 'Courier New',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            '閉じる',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
