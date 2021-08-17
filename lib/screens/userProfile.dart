import 'package:canim/constants.dart';
import 'package:flutter/material.dart';
import 'package:canim/widgets/post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:canim/widgets/buttonWidget.dart';
import 'package:canim/screens/singleChat.dart';

//translation
import 'package:get/get.dart';

class UserProfileScreen extends StatelessWidget {
  static String id = 'userProfileScreen';
  @override
  Widget build(BuildContext context) {
    final argUID = ModalRoute.of(context).settings.arguments;
    final myMedia = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 230, 230),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    overflow: Overflow.visible,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image(
                        height: myMedia.height * 0.28,
                        fit: BoxFit.cover,
                        image: AssetImage('images/giver.jpg'),
                      ),
                      Positioned(
                          bottom: myMedia.height * -0.12,
                          child: FutureBuilder(
                              future: FirebaseDatabase()
                                  .reference()
                                  .child('Users')
                                  .child(argUID)
                                  .once(),
                              builder: (context, snapshot) {
                                bool isLoaded = false;
                                var response;
                                if (snapshot.hasData) response = snapshot.data;
                                if (snapshot.hasData && response != null) {
                                  isLoaded = true;
                                  //print(response.value);
                                }

                                return CircleAvatar(
                                  radius: myMedia.width * 0.25,
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(isLoaded
                                      ? '${response.value['user_imgURL']}'
                                      : "https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg"),
                                );
                              })),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: myMedia.height * 0.13,
              ),
              FutureBuilder(
                future: FirebaseDatabase()
                    .reference()
                    .child('Users')
                    .child(argUID)
                    .once(),
                builder: (context, snapshot) {
                  bool isLoaded = false;
                  var response;
                  if (snapshot.hasData) response = snapshot.data;
                  if (snapshot.hasData && response != null) {
                    isLoaded = true;
                    //print(response.value);
                  }
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              isLoaded
                                  ? '${response.value['firstName']} ${response.value['secondName']}'
                                  : '',
                              style: TextStyle(fontSize: 25)),
                        ],
                      ),
                      Text(isLoaded ? response.value['email'] : ''),
                      Text(isLoaded
                          ? '${'Blood Type:'.tr} ${response.value['blood_type']}'
                          : '${'Blood Type:'.tr} '),
                      Text(isLoaded
                          ? '${'phone:'.tr} 0${response.value['phone']}'
                          : '${'phone:'.tr} 0'),
                      Text(isLoaded
                          ? '${'age:'.tr} ${response.value['age']}'
                          : '${'age:'.tr} 0'),
                    ],
                  );
                },
              ),
              ButtonWidget(redColor, 'Chat'.tr, Colors.white, () async {
                Navigator.of(context)
                    .pushNamed(SingleChat.id, arguments: argUID);
              }, myMedia.height * 0.05, myMedia.width * 0.25),
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 5.0),
                child: Divider(
                  color: redColor,
                ),
              ),
              FutureBuilder(
                future: FirebaseDatabase()
                    .reference()
                    .child('Posts')
                    .orderByChild('userID')
                    .equalTo(argUID)
                    .once(),
                builder: (context, snapshot) {
                  List<Post> mypostsList = [];

                  var response;
                  if (snapshot.hasData) response = snapshot.data;
                  if (snapshot.hasData &&
                      response != null &&
                      response.value != null) {
                    //print(response.value.keys);
                    for (var key in response.value.keys) {
                      var postWidget = Post(
                        isMyPost: false,
                        postKey: key,
                        profileName: response.value[key]['name'],
                        postDate:
                            DateTime.parse(response.value[key]['postDate']),
                        donDate: DateTime.parse(
                            response.value[key]['donDate'] != null
                                ? response.value[key]['donDate']
                                : '2021-12-12 10:10:00'),
                        blodType: response.value[key]['blood_type'],
                        government: response.value[key]['government'],
                        city: response.value[key]['city'],
                        userID: response.value[key]['userID'],
                        details: response.value[key]['details'] != null
                            ? response.value[key]['details']
                            : 'no more details'.tr,
                      );
                      mypostsList.add(postWidget);
                    }
                    return ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      reverse: true,
                      children: mypostsList,
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(top: myMedia.height * 0.18),
                      child: Center(child: Text('No posts shared!'.tr)),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
