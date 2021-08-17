import 'package:flutter/material.dart';
import 'package:canim/widgets/appDrawer.dart';
import 'package:canim/widgets/newPost.dart';
import 'package:canim/constants.dart';
import 'package:canim/widgets/post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:canim/functions/currentUserInf.dart';
import 'package:canim/provider/providerClass.dart';
import 'package:provider/provider.dart';
import 'package:canim/screens/allchats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:canim/widgets/notifiButton.dart';
import 'package:canim/functions/notification_api.dart';
//translation
import 'package:get/get.dart';

var uid;
final _auth = FirebaseAuth.instance;
final db = FirebaseDatabase.instance;
final FirebaseMessaging _fcm = FirebaseMessaging();
bool buildClassOnce = true;

class HomePage extends StatefulWidget {
  static String id = 'Home_page';
  //const Home_page({ Key? key }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _fcm.requestNotificationPermissions();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {},
      onLaunch: (Map<String, dynamic> message) async {},
      onResume: (Map<String, dynamic> message) async {},
    );
    //setState(() {
    // uid = _auth.currentUser.uid;
    Provider.of<MyData>(context, listen: false)
        .changeUserUID(_auth.currentUser.uid);
    //});
    NotificationApi.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myMedia = MediaQuery.of(context).size;
    final myProvider = Provider.of<MyData>(context);
    //get current user inf
    if (buildClassOnce) setCurrentUserData(context);
    setState(() => buildClassOnce = false);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        title: Text('Blood Bank'),
        actions: [
          notificButton(context),
          Padding(
            padding: EdgeInsets.only(right: 8.0, left: 8),
            child: IconButton(
              icon: CircleAvatar(
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
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: redColor,
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    ShowNewPostDialog(isUpdatePost: false));
          }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
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
                    String myUid = myProvider.uid;
                    var response;
                    if (snapshot.hasData)
                      response = snapshot.data.snapshot.value;
                    if (snapshot.hasData &&
                        response != null &&
                        response.keys != null) {
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
                            isMyPost: (response[key]['userID'] == myUid)
                                ? true
                                : false,
                            postKey: key,
                            profileName: response[key]['name'],
                            postDate: DateTime.parse(
                                response[key]['postDate'] != null
                                    ? response[key]['postDate']
                                    : '2021-12-12 10:10:00'),
                            donDate: DateTime.parse(
                                response[key]['donDate'] != null
                                    ? response[key]['donDate']
                                    : '2021-12-12 10:10:00'),
                            blodType: response[key]['blood_type'],
                            government: response[key]['government'],
                            city: response[key]['city'],
                            userID: response[key]['userID'],
                            details: response[key]['details'] != null
                                ? response[key]['details']
                                : 'no more details'.tr,
                          );
                          postsList.add(postWidget);
                          postsList
                              .sort((a, b) => a.postDate.compareTo(b.postDate));
                        }
                      }
                      return ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        reverse: true,
                        children: postsList,
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(top: myMedia.height * 0.25),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
