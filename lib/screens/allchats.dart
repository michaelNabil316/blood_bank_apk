import 'package:canim/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:canim/provider/providerClass.dart';
import 'package:provider/provider.dart';
import 'package:canim/widgets/ItemUserChat.dart';
import 'package:canim/screens/profile.dart';

//translation
import 'package:get/get.dart';

String search = '';

class MessangerScreen extends StatelessWidget {
  static String id = 'chatScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(ProfileScreen.id);
                      },
                      child: CircleAvatar(
                        radius: 35.0,
                        backgroundImage:
                            NetworkImage(Provider.of<MyData>(context).imgURL),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      'Chats'.tr,
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: redColor,
                  thickness: 1,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        FutureBuilder(
                          future: FirebaseDatabase()
                              .reference()
                              .child('Users')
                              .child(Provider.of<MyData>(context, listen: false)
                                  .uid)
                              .child('chats')
                              .once(),
                          builder: (context, snapshot) {
                            List<Widget> myChats = [];
                            var response;
                            if (snapshot.hasData) response = snapshot.data;
                            if (snapshot.hasData &&
                                response != null &&
                                response.value != null) {
                              for (var key in response.value.keys) {
                                var chat = OneItemChat(
                                  uidOfItemUser: key,
                                );
                                myChats.add(chat);
                              }
                              return ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                reverse: true,
                                children: myChats,
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.18),
                                child: Center(child: Text('No Chats!'.tr)),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
