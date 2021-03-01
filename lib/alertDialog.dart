import 'package:flutter/material.dart';

enum DialogAction { yes, abort }

class AlertDialogs {
  static Future<DialogAction> yesAbortDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(DialogAction.abort),
                child: const Text("No"),
              ),
              RaisedButton(
                color: Colors.blue,
                onPressed: () => Navigator.of(context).pop(DialogAction.yes),
                child: const Text("Yes"),
              ),
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        });
    return (action != null) ? action : DialogAction.abort;
  }
}
