import 'package:blood_bank/business_logic/cubit/bloc.dart';
import 'package:blood_bank/business_logic/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//translation
import 'package:get/get.dart';

import 'message_bubble.dart';

final loggedInUser = FirebaseAuth.instance.currentUser;

class StreamBubble extends StatelessWidget {
  final secondUID;
  const StreamBubble(this.secondUID, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return StreamBuilder(
        stream: FirebaseDatabase()
            .reference()
            .child('Users')
            .child(AppBloc.get(context).uid)
            .child('chats')
            .child(secondUID)
            .onValue,
        builder: (context, snapshot) {
          List<MessageBubble> messageWidgetList = [];
          if (!snapshot.hasData) {
            return Column(
              children: <Widget>[Text('Start with sending new message'.tr)],
            );
          }
          var response;
          if (snapshot.hasData) {
            response = snapshot.data;
            response = response.snapshot.value;
          }
          if (snapshot.hasData && response != null) {
            for (var key in response.keys) {
              final messageText = response[key]['text'];
              final messageSender = response[key]['sender'];
              final messageTime = DateTime.parse(response[key]['time']);
              bool isMe;
              if (messageSender == loggedInUser!.uid) {
                isMe = true;
              } else {
                isMe = false;
              }
              final messageWidget =
                  MessageBubble(messageText, messageSender, messageTime, isMe);
              messageWidgetList.add(messageWidget);
              messageWidgetList.sort((a, b) => b.time.compareTo(a.time));
            }
            return Expanded(
              child: ListView(
                reverse: true,
                padding: const EdgeInsets.all(8.0),
                children: messageWidgetList,
              ),
            );
          } else {
            return Expanded(
              child: Center(
                child: Text('start chat with new message'.tr),
              ),
            );
          }
        },
      );
    });
  }
}
