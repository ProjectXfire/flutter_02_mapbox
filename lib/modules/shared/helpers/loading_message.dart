import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showLoadingMessage(
    {required BuildContext context, String message = "message"}) {
  if (Platform.isAndroid) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
            title: Text(message),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(strokeWidth: 3, color: Colors.black)
              ],
            )));
  }
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CupertinoAlertDialog(
            title: Text(message), content: const CupertinoActivityIndicator()));
  }
}
