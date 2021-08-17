import 'package:flutter/material.dart';
import 'package:canim/constants.dart';
import 'package:canim/widgets/bottomSheetEdit.dart';
import 'package:canim/widgets/bottomSheetReport.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:canim/screens/singleChat.dart';
import 'package:canim/screens/profile.dart';
import 'package:canim/screens/userProfile.dart';
import 'package:canim/provider/providerClass.dart';
import 'package:provider/provider.dart';
import 'package:canim/screens/allchats.dart';
//translation
import 'package:get/get.dart';

String fixedImgUrl =
    'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg';

class Post extends StatefulWidget {
  //const Post({ Key? key }) : super(key: key);
  final isMyPost;
  final postKey;
  final profileName;
  final donDate;
  final postDate;
  final blodType;
  final government;
  final city;
  final userID;
  final details;
  Post(
      {this.isMyPost,
      this.postKey,
      this.profileName,
      this.donDate,
      this.postDate,
      this.blodType,
      this.government,
      this.city,
      this.userID,
      this.details});
  @override
  _PostState createState() => _PostState();
}

var isLike = false;

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    final myMedia = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child('Users')
                    .child(widget.userID)
                    .onValue,
                builder: (context, snapshot) {
                  bool isLoaded = false;
                  var response;

                  if (snapshot.hasData) response = snapshot.data.snapshot.value;
                  if (snapshot.hasData && response != null) {
                    isLoaded = true;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1.0,
                                style: BorderStyle.solid,
                                color: redColor),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0)),
                          ),
                        ),
                        child: ListTile(
                          leading: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  UserProfileScreen.id,
                                  arguments: widget.userID);
                            },
                            child: CircleAvatar(
                              radius: myMedia.width * 0.07,
                              backgroundImage: NetworkImage(isLoaded
                                  ? response['user_imgURL']
                                  : fixedImgUrl),
                            ),
                          ),
                          title: InkWell(
                            onTap: () {
                              if (widget.userID ==
                                  Provider.of<MyData>(context, listen: false)
                                      .uid)
                                Navigator.of(context)
                                    .pushNamed(ProfileScreen.id);
                              else
                                Navigator.of(context).pushNamed(
                                    UserProfileScreen.id,
                                    arguments: widget.userID);
                            },
                            child: Text(
                              isLoaded
                                  ? '${response['firstName']} ${response['secondName']}'
                                  : widget.profileName,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          subtitle: Text(
                            '${widget.postDate.day}-${widget.postDate.month}-${widget.postDate.year}',
                            style: TextStyle(color: Colors.white),
                          ),
                          tileColor: Color.fromARGB(255, 237, 103, 97),
                          trailing: (widget.isMyPost)
                              ? IconButton(
                                  icon: Icon(Icons.keyboard_control),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          BuilBottemWidget(widget.postKey),
                                    );
                                  },
                                  color: Colors.white,
                                )
                              : IconButton(
                                  icon: Icon(Icons.report),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            BuilBottemReport(widget.userID));
                                  },
                                  color: Colors.white,
                                ),
                        ),
                      ),
                      Container(
                          margin:
                              EdgeInsets.only(top: 8.0, left: 50, right: 50),
                          child: Text(
                            'Hi, I need'.tr,
                            style: postTxtBodyStyle,
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 50, right: 50),
                          child: Text(
                            'blood type:'.tr + ' ${widget.blodType} ',
                            style: postTxtBodyStyle,
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 50, right: 50),
                          child: Text(
                            'in '.tr +
                                '${widget.government}' +
                                ' at '.tr +
                                '${widget.city}',
                            style: postTxtBodyStyle,
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 50, right: 50),
                          child: Text(
                            'before '.tr +
                                '${widget.donDate.day}-${widget.donDate.month}-${widget.donDate.year}',
                            style: postTxtBodyStyle,
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 50, right: 50),
                        child: Text(
                          'phone: 0'.tr +
                              '${isLoaded ? response['phone'] : 0000000000}',
                          style: postTxtBodyStyle,
                        ),
                      ),
                    ],
                  );
                }),
            Container(
                margin: EdgeInsets.only(bottom: 8.0, left: 50, right: 50),
                child: Text(
                  '${widget.details}',
                  style: postTxtBodyStyle,
                )),
            Divider(
              color: Colors.grey,
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: FlatButton(
                        onPressed: () {
                          if (widget.userID ==
                              Provider.of<MyData>(context, listen: false).uid)
                            Navigator.of(context).pushNamed(MessangerScreen.id);
                          else
                            Navigator.of(context).pushNamed(SingleChat.id,
                                arguments: widget.userID);
                        },
                        child: Text(
                          'Chat'.tr,
                          style: postTxtBodyStyle,
                        )),
                  ),
                  Container(
                    height: 35,
                    color: Colors.grey,
                    width: 1,
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          isLike = !isLike;
                        });
                      },
                      child: Icon(
                        isLike
                            ? Icons.favorite_outlined
                            : Icons.favorite_border_outlined,
                        color: redColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5)
          ],
        ),
      ),
    );
  }
}
