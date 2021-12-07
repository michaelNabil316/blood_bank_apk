import 'package:blood_bank/business_logic/cubit/bloc.dart';
import 'package:blood_bank/presentations/components/stream_bubble_chat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../constants.dart';

final rFirebaseD = FirebaseDatabase.instance.reference().child('Users');

class SingleChat extends StatefulWidget {
  static String id = 'singleChat';
  const SingleChat({Key? key}) : super(key: key);

  @override
  _SingleChatState createState() => _SingleChatState();
}

@override
class _SingleChatState extends State<SingleChat> {
  String? messages;
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatUserUID = ModalRoute.of(context)!.settings.arguments;
    final Size myMedia = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(myMedia.height * 0.08),
        child: FutureBuilder(
            future: FirebaseDatabase()
                .reference()
                .child('Users')
                .child('$chatUserUID')
                .once(),
            builder: (context, snap) {
              var resp;
              if (snap.hasData) {
                resp = snap.data;
              }
              if (snap.hasData && resp != null) {
                return myAppBar(context, resp.value['user_imgURL'],
                    '${resp.value['firstName']} ${resp.value['secondName']}');
              } else {
                return myAppBar(
                    context,
                    "https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg",
                    'loading..');
              }
            }),
      ),
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBubble(chatUserUID),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        onChanged: (value) {
                          messages = value;
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: kMessageTextFieldDecoration,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Container(
                      width: myMedia.width * 0.13,
                      color: const Color.fromARGB(100, 255, 255, 255),
                      child: IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: redColor,
                          ),
                          onPressed: () {
                            textEditingController.clear();
                            final dat = DateTime.now();
                            if (messages != null) {
                              var msg = {
                                'text': messages,
                                'sender': AppBloc.get(context).uid,
                                'time': '$dat'
                              };
                              //send to my user data
                              rFirebaseD
                                  .child(AppBloc.get(context).uid)
                                  .child('chats')
                                  .child('$chatUserUID')
                                  .push()
                                  .set(msg);
                              //send to the other user
                              rFirebaseD
                                  .child('$chatUserUID')
                                  .child('chats')
                                  .child(AppBloc.get(context).uid)
                                  .push()
                                  .set(msg);
                            }
                            messages = null;
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget myAppBar(context, imgUrl, nam) {
  return AppBar(
    backgroundColor: redColor,
    leading: Padding(
      padding: const EdgeInsets.all(3.0),
      child: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }),
    ),
    title: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: CircleAvatar(
            maxRadius: 27,
            backgroundImage: NetworkImage(imgUrl),
          ),
        ),
        Text('   $nam'),
      ],
    ),
  );
}
