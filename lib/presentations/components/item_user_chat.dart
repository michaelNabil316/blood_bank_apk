import 'package:flutter/material.dart';
import '../screens/single_chat.dart';
import 'package:firebase_database/firebase_database.dart';
//translation
import 'package:get/get.dart';

class OneItemChat extends StatelessWidget {
  const OneItemChat({Key? key, required this.uidOfItemUser}) : super(key: key);
  final String uidOfItemUser;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseDatabase()
            .reference()
            .child('Users')
            .child(uidOfItemUser)
            .once(),
        builder: (context, snap) {
          var resp;
          if (snap.hasData) resp = snap.data;
          if (snap.hasData && resp != null) {
            return item(context, resp.value['user_imgURL'],
                resp.value['firstName'], uidOfItemUser);
          } else {
            return Text('No Chats!'.tr);
          }
        });
  }
}

Widget item(context, imgUrl, nam, seconUID) {
  return Padding(
    padding: const EdgeInsets.only(top: 12.0),
    child: InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(SingleChat.id, arguments: seconUID);
      },
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(radius: 30.0, backgroundImage: NetworkImage(imgUrl)),
              const Padding(
                padding: EdgeInsetsDirectional.only(
                  bottom: 3.0,
                  end: 3.0,
                ),
                child: CircleAvatar(
                  radius: 7.0,
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nam,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5.0),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
