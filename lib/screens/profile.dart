import 'package:canim/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canim/provider/providerClass.dart';
import 'package:canim/widgets/post.dart';
import 'package:canim/widgets/editUserInf.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:canim/functions/currentUserInf.dart';
import 'package:canim/functions/imagePicker.dart';
//translation
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  static String id = 'ProfileScreen';
  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyData>(context);
    String myUid = myProvider.uid;
    setCurrentUserData(context);
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
                          image: AssetImage('images/giver.jpg')),
                      Positioned(
                          bottom: myMedia.height * -0.12,
                          child: CircleAvatar(
                            radius: myMedia.width * 0.25,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(myProvider.imgURL),
                          )),
                      // Positioned(
                      //   bottom: myMedia.height * -0.115,
                      //   right: myMedia.height * 0.127,
                      //   child:
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: myMedia.height * 0.13,
              ),
              StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .reference()
                      .child('Users')
                      .child(myProvider.uid)
                      .onValue,
                  builder: (context, snapshot) {
                    bool isLoaded = false;
                    var response;
                    if (snapshot.hasData)
                      response = snapshot.data.snapshot.value;
                    if (snapshot.hasData && response != null) {
                      isLoaded = true;
                    }
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                isLoaded
                                    ? '         ${response['firstName']} ${response['secondName']}  '
                                    : '         ${myProvider.firstName} ${myProvider.lastName}  ',
                                style: TextStyle(fontSize: 25)),
                            IconButton(
                                icon: CircleAvatar(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 19.0,
                                  ),
                                  radius: 15.0,
                                  backgroundColor: redColor,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          EditUserData());
                                }),
                            IconButton(
                              icon: CircleAvatar(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                                radius: 15.0,
                                backgroundColor: redColor,
                              ),
                              onPressed: () {
                                pickProfileImage(context, myProvider.uid);
                              },
                            ),
                          ],
                        ),
                        Text(isLoaded ? response['email'] : myProvider.email),
                        Text(isLoaded
                            ? '${'Blood Type:'.tr} ${response['blood_type']}'
                            : '${'Blood Type:'.tr} ${myProvider.bloodType}'),
                        Text(isLoaded
                            ? '${'phone:'.tr} 0${response['phone']}'
                            : '${'phone:'.tr} 0${myProvider.phone}'),
                        Text(isLoaded
                            ? '${'age:'.tr} ${response['age']}'
                            : '${'age:'.tr} ${myProvider.age}'),
                      ],
                    );
                  }),
              Padding(
                padding: EdgeInsets.only(
                    left: 30.0, right: 30.0, top: 20.0, bottom: 10),
                child: Divider(
                  color: redColor,
                ),
              ),
              FutureBuilder(
                future: FirebaseDatabase()
                    .reference()
                    .child('Posts')
                    .orderByChild('userID')
                    .equalTo(myUid)
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
                        isMyPost: (response.value[key]['userID'] == myUid)
                            ? true
                            : false,
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

                      //if (response[key]['userID'] == myUid)
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
