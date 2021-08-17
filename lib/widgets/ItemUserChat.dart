import 'package:flutter/material.dart';
import 'package:canim/screens/singleChat.dart';
import 'package:firebase_database/firebase_database.dart';
//translation
import 'package:get/get.dart';

class OneItemChat extends StatelessWidget {
  //const OneItemChat({ Key? key }) : super(key: key);
  final uidOfItemUser;
  OneItemChat({@required this.uidOfItemUser});
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
            //var lastTime = [];
            //for (var i in resp.value['chats'].values) print(i);
            //كل واحد كلمته جواه مسجات فالمفروض اعمل 2 فور لوب لحد ما اطلع اخر تاريخ
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
    padding: EdgeInsets.only(top: 12.0),
    child: FlatButton(
      onPressed: () {
        Navigator.of(context).pushNamed(SingleChat.id, arguments: seconUID);
      },
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(radius: 30.0, backgroundImage: NetworkImage(imgUrl)),
              Padding(
                padding: const EdgeInsetsDirectional.only(
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
          SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nam,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5.0,
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Text(
                //         'hello, My name is ',
                //         maxLines: 2,
                //         overflow: TextOverflow.ellipsis,
                //         style: TextStyle(
                //           color: Colors.grey,
                //         ),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: 8.0,
                //       ),
                //       child: Container(
                //         width: 5.0,
                //         height: 5.0,
                //         decoration: BoxDecoration(
                //           color: Colors.blue,
                //           shape: BoxShape.circle,
                //         ),
                //       ),
                //     ),
                //     Text(
                //       '10:44 PM',
                //       style: TextStyle(
                //         color: Colors.grey,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
