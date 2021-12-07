import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

Future<dynamic> errorAlertMessage(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('An error'.tr),
      content: Text(message),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'.tr))
      ],
    ),
  );
}
