import 'package:blood_bank/business_logic/cubit/bloc.dart';
import 'package:blood_bank/presentations/components/app_drawer.dart';
import 'package:blood_bank/presentations/components/new_post.dart';
import 'package:blood_bank/presentations/components/notifi_button.dart';
import 'package:blood_bank/presentations/components/post.dart';
import 'package:blood_bank/presentations/functions/current_user_info.dart';
import 'package:blood_bank/presentations/functions/notification_api.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';
import 'allchats.dart';
//translation
import 'package:get/get.dart';

var uid;
final _auth = FirebaseAuth.instance;
final db = FirebaseDatabase.instance;
final FirebaseMessaging _fcm = FirebaseMessaging.instance;
bool buildClassOnce = true;

class HomePage extends StatefulWidget {
  static String id = 'Home_page';
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _fcm.requestPermission();
    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {},
    //   onLaunch: (Map<String, dynamic> message) async {},
    //   onResume: (Map<String, dynamic> message) async {},
    // );
    if (_auth.currentUser != null) {
      AppBloc.get(context).changeUserUID(_auth.currentUser!.uid);
    }
    NotificationApi.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myMedia = MediaQuery.of(context).size;
    final appbloc = AppBloc.get(context);
    //get current user inf
    if (buildClassOnce) setCurrentUserData(context);
    setState(() => buildClassOnce = false);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        title: const Text('Blood Bank'),
        backgroundColor: redColor,
        actions: [
          notificButton(context),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8),
            child: IconButton(
              icon: const CircleAvatar(
                child: Icon(
                  Icons.chat_outlined,
                  color: redColor,
                  size: 22.0,
                ),
                radius: 20.0,
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(MessangerScreen.id);
              },
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: redColor,
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    const ShowNewPostDialog(isUpdatePost: false));
          }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder(
                stream: FirebaseDatabase()
                    .reference()
                    .child('Posts')
                    .orderByChild('postDate')
                    .onValue,
                builder: (context, snapshot) {
                  List<Post> postsList = [];
                  String myUid = appbloc.uid;
                  var response;
                  if (snapshot.hasData) {
                    response = snapshot.data;
                  }
                  if (snapshot.hasData && response != null) {
                    response = response.snapshot.value;
                    for (var key in response.keys) {
                      //delete old posts automatic
                      if (DateTime.parse(response[key]['donDate'])
                          .isBefore(DateTime.now())) {
                        FirebaseDatabase.instance
                            .reference()
                            .child('Posts')
                            .child(key)
                            .remove();
                      } else {
                        var postWidget = Post(
                          isMyPost:
                              (response[key]['userID'] == myUid) ? true : false,
                          postKey: key,
                          profileName: response[key]['name'],
                          postDate: DateTime.parse(response[key]['postDate'] ??
                              '2021-12-12 10:10:00'),
                          donDate: DateTime.parse(response[key]['donDate'] ??
                              '2021-12-12 10:10:00'),
                          blodType: response[key]['blood_type'],
                          government: response[key]['government'],
                          city: response[key]['city'],
                          userID: response[key]['userID'],
                          details:
                              response[key]['details'] ?? 'no more details'.tr,
                        );
                        postsList.add(postWidget);
                        postsList
                            .sort((a, b) => a.postDate.compareTo(b.postDate));
                      }
                    }
                    return ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      reverse: true,
                      children: postsList,
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(top: myMedia.height * 0.25),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
