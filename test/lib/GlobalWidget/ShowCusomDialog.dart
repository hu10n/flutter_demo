import 'package:flutter/material.dart';

void showCustomDialog(
    BuildContext mainContext, Function onScrollUp, String title, String text) {
  showDialog(
    context: mainContext,
    builder: (BuildContext context) {
      Color secondaryColor = Theme.of(context).colorScheme.secondary;

      return AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.pop(mainContext); // Close the modal
              onScrollUp(100); // Return the bottom navigation
            },
            style: TextButton.styleFrom(
                foregroundColor: secondaryColor), // Set the text color
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
