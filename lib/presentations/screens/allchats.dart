import 'package:blood_bank/business_logic/cubit/bloc.dart';
import 'package:blood_bank/business_logic/cubit/states.dart';
import 'package:blood_bank/presentations/components/item_user_chat.dart';
import 'package:blood_bank/presentations/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants.dart';

//translation
import 'package:get/get.dart';

String search = '';

class MessangerScreen extends StatelessWidget {
  const MessangerScreen({Key? key}) : super(key: key);

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
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(ProfileScreen.id);
                      },
                      child: BlocBuilder<AppBloc, AppState>(
                          builder: (context, state) {
                        return CircleAvatar(
                          radius: 35.0,
                          backgroundImage:
                              NetworkImage(AppBloc.get(context).imgURL),
                        );
                      }),
                    ),
                    const SizedBox(width: 20.0),
                    Text(
                      'Chats'.tr,
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: redColor,
                  thickness: 1,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        BlocBuilder<AppBloc, AppState>(
                            builder: (context, state) {
                          return FutureBuilder(
                            future: FirebaseDatabase()
                                .reference()
                                .child('Users')
                                .child(AppBloc.get(context).uid)
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
                                  physics: const NeverScrollableScrollPhysics(),
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
                          );
                        }),
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
