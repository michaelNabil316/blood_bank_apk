import 'package:blood_bank/business_logic/cubit/bloc.dart';
import 'package:blood_bank/business_logic/cubit/states.dart';
import 'package:blood_bank/presentations/components/edit_user_inf.dart';
import 'package:blood_bank/presentations/components/post.dart';
import 'package:blood_bank/presentations/components/profile_img_loader.dart';
import 'package:blood_bank/presentations/functions/current_user_info.dart';
import 'package:blood_bank/presentations/functions/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
//translation
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  static String id = 'ProfileScreen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appbloc = AppBloc.get(context);
    String myUid = appbloc.uid;
    setCurrentUserData(context);
    final myMedia = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  overflow: Overflow.visible,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image(
                      height: myMedia.height * 0.28,
                      fit: BoxFit.cover,
                      image: const AssetImage('assets/images/giver.jpg'),
                    ),
                    Positioned(
                      bottom: myMedia.height * -0.12,
                      child: BlocBuilder<AppBloc, AppState>(
                          builder: (context, state) {
                        if (state is ChangeProfileImageState) {
                          return CircleImgLoader(width: myMedia.width * 0.25);
                        } else {
                          return CircleAvatar(
                            radius: myMedia.width * 0.25,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              appbloc.imgURL,
                            ),
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: myMedia.height * 0.13,
              ),
              StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .reference()
                      .child('Users')
                      .child(appbloc.uid)
                      .onValue,
                  builder: (context, snapshot) {
                    bool isLoaded = false;
                    var response;
                    if (snapshot.hasData) {
                      response = snapshot.data;
                      response = response.snapshot.value;
                    }
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
                                    : '         ${appbloc.firstName} ${appbloc.lastName}  ',
                                style: const TextStyle(fontSize: 25)),
                            IconButton(
                                icon: const CircleAvatar(
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
                                          const EditUserData());
                                }),
                            IconButton(
                              icon: const CircleAvatar(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                                radius: 15.0,
                                backgroundColor: redColor,
                              ),
                              onPressed: () {
                                pickProfileImage(context, appbloc.uid);
                              },
                            ),
                          ],
                        ),
                        Text(isLoaded ? response['email'] : appbloc.email),
                        Text(isLoaded
                            ? '${'Blood Type:'.tr} ${response['blood_type']}'
                            : '${'Blood Type:'.tr} ${appbloc.bloodType}'),
                        Text(isLoaded
                            ? '${'phone:'.tr} 0${response['phone']}'
                            : '${'phone:'.tr} 0${appbloc.phone}'),
                        Text(isLoaded
                            ? '${'age:'.tr} ${response['age']}'
                            : '${'age:'.tr} ${appbloc.age}'),
                      ],
                    );
                  }),
              const Padding(
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
                        donDate: DateTime.parse(response.value[key]
                                ['donDate'] ??
                            '2021-12-12 10:10:00'),
                        blodType: response.value[key]['blood_type'],
                        government: response.value[key]['government'],
                        city: response.value[key]['city'],
                        userID: response.value[key]['userID'],
                        details: response.value[key]['details'] ??
                            'no more details'.tr,
                      );

                      //if (response[key]['userID'] == myUid)
                      mypostsList.add(postWidget);
                    }
                    return ListView(
                      physics: const NeverScrollableScrollPhysics(),
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
