import 'dart:convert';

import 'package:blood_bank/business_logic/cubit/bloc.dart';
import 'package:blood_bank/business_logic/cubit/states.dart';
import 'package:blood_bank/presentations/functions/notification_api.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants.dart';
//translation
import 'package:get/get.dart';

import 'notification_dialog.dart';

Widget notificButton(context) {
  final appBloc = AppBloc.get(context);
  return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child('Users')
          .child(appBloc.uid)
          .child('Notification')
          .onValue,
      builder: (context, snapshot) {
        var response;
        if (snapshot.hasData) {
          response = snapshot.data;
          response = response.snapshot.value;
        }
        if (snapshot.hasData && response != null) {
          //&& response.values != null
          if (appBloc.oldNotificLength != response.values.length) {
            appBloc.changeNewNotification(true);
            appBloc.changeNotificationList(response.values.length);
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
              appBloc.newNotification
                  ? Icons.notifications_active
                  : Icons.notifications_none,
              color: appBloc.newNotification ? Colors.blue : redColor,
              size: 22.0,
            ),
            radius: 20.0,
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            appBloc.changeNewNotification(false);
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    const ShowNotificatopnsDialog());
          },
        );
      },
    );
  });
}
