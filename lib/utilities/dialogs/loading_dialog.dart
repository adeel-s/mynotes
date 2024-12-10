import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

typedef CloseDialog = void Function();

CloseDialog showLogOutDialog({
  required BuildContext context,
  required String text,
}) {
  final dialog = AlertDialog(
      content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const CircularProgressIndicator(),
      const SizedBox(height: 10.0),
      Text(text),
    ],
  ));

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => dialog,
  );
  return () => Navigator.of(context).pop();
}
