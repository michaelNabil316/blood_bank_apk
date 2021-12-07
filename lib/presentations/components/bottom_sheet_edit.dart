import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
//translation
import 'package:get/get.dart';

import '../constants.dart';
import 'new_post.dart';

class BuilBottemWidget extends StatelessWidget {
  final String postKey;
  const BuilBottemWidget({Key? key, required this.postKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final myMediaQ = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      height: myMediaQ.height * 0.25,
      child: Container(
        margin: const EdgeInsets.only(top: 20.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1.0, style: BorderStyle.solid, color: redColor),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
            ),
            color: Colors.white),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: myMediaQ.width * 0.30),
              child: const Divider(
                color: redColor,
              ),
            ),
            const SizedBox(height: 10.0),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: redColor,
              ),
              title: Text(
                'Delete Post'.tr,
                style: const TextStyle(
                  color: redColor,
                ),
              ),
              onTap: () async {
                //var response = await
                await FirebaseDatabase.instance
                    .reference()
                    .child('Posts')
                    .child(postKey)
                    .remove();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: redColor,
              ),
              title: Text(
                'Edit Post'.tr,
                style: const TextStyle(
                  color: redColor,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) => ShowNewPostDialog(
                    isUpdatePost: true,
                    postKey: postKey,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
