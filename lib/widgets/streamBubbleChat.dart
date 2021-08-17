import 'package:flutter/material.dart';
import 'package:canim/widgets/messageBubble.dart';
//import 'package:canim/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:canim/provider/providerClass.dart';
import 'package:provider/provider.dart';
//translation
import 'package:get/get.dart';

final loggedInUser = FirebaseAuth.instance.currentUser;

class StreamBubble extends StatelessWidget {
  final secondUID;
  StreamBubble(this.secondUID);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseDatabase()
          .reference()
          .child('Users')
          .child(Provider.of<MyData>(context).uid)
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
        if (snapshot.hasData) response = snapshot.data.snapshot.value;
        if (snapshot.hasData &&
            response != null &&
            snapshot.data.snapshot != null) {
          for (var key in response.keys) {
            final messageText = response[key]['text'];
            final messageSender = response[key]['sender'];
            final messageTime = DateTime.parse(response[key]['time']);
            bool isMe;
            if (messageSender == loggedInUser.uid) {
              isMe = true;
            } else
              isMe = false;
            final messageWidget =
                MessageBubble(messageText, messageSender, messageTime, isMe);
            messageWidgetList.add(messageWidget);
            messageWidgetList.sort((a, b) => b.time.compareTo(a.time));
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.all(8.0),
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
  }
}
