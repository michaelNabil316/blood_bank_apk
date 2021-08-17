import 'package:canim/constants.dart';
import 'package:flutter/material.dart';
import 'package:canim/widgets/post.dart';
import 'package:firebase_database/firebase_database.dart';
//translation
import 'package:get/get.dart';

class OnePostNotifi extends StatelessWidget {
  static String id = 'OnePostNotifi';
  //const OnePostNotifi({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final argUID = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 230, 230),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: FutureBuilder(
              future: FirebaseDatabase()
                  .reference()
                  .child('Posts')
                  .child(argUID)
                  .once(),
              builder: (context, snapshot) {
                List<Widget> postNotif = [];
                var response;
                if (snapshot.hasData) response = snapshot.data;
                if (snapshot.hasData &&
                    response != null &&
                    response.value != null) {
                  // height: MediaQuery.of(context).size.height * 0.4,
                  final postWidiget = Post(
                    isMyPost: false,
                    postKey: response.value['key'],
                    profileName: response.value['name'],
                    postDate: DateTime.parse(response.value['postDate'] != null
                        ? response.value['postDate']
                        : '2021-12-12 10:10:00'),
                    donDate: DateTime.parse(response.value['donDate'] != null
                        ? response.value['donDate']
                        : '2021-12-12 10:10:00'),
                    blodType: response.value['blood_type'],
                    government: response.value['government'],
                    city: response.value['city'],
                    userID: response.value['userID'],
                    details: response.value['details'] != null
                        ? response.value['details']
                        : 'no more details'.tr,
                  );
                  postNotif.add(postWidiget);
                  return ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    children: postNotif,
                  );
                }
                return Center(
                    child: Text(
                  'Post has been deleted'.tr,
                  style: TextStyle(color: redColor, fontSize: 20),
                ));
              }),
        ),
      ),
    );
  }
}
