import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canim/provider/providerClass.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:canim/constants.dart';
import 'package:canim/widgets/notificationDialog.dart';
import 'package:canim/functions/notification_api.dart';
//translation
import 'package:get/get.dart';

// void listenNotifications() =>
//     NotificationApi.onNotifications.listen(onClickedNotification);

// void onClickedNotification(String payload) => Navigator.of(context).pop();

Widget notificButton(context) {
  final myProvider = Provider.of<MyData>(context);
  return StreamBuilder(
    stream: FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(myProvider.uid)
        .child('Notification')
        .onValue,
    builder: (context, snapshot) {
      var response;
      if (snapshot.hasData) response = snapshot.data.snapshot.value;
      if (snapshot.hasData && response != null) {
        if (myProvider.oldNotificLength != response.values.length) {
          myProvider.changeNewNotification(true);
          myProvider.changeNotificationList(response.values.length);
          NotificationApi.showNotification(
            title: '${response.values.first['firstName']}',
            body: 'need a blood like your type'.tr,
            payload: 'Mahmoud Abdo',
          );
        }
      }
      return IconButton(
        icon: CircleAvatar(
          child: Icon(
            myProvider.newNotification
                ? Icons.notifications_active
                : Icons.notifications_none,
            color: myProvider.newNotification ? Colors.blue : redColor,
            size: 22.0,
          ),
          radius: 20.0,
          backgroundColor: Colors.white,
        ),
        onPressed: () {
          myProvider.changeNewNotification(false);
          showDialog(
              context: context,
              builder: (BuildContext context) => ShowNotificatopnsDialog());
        },
      );
    },
  );
}
