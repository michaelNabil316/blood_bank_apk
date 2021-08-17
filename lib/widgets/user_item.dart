import 'package:canim/constants.dart';
import 'package:flutter/material.dart';
import 'package:canim/provider/providerClass.dart';
import 'package:provider/provider.dart';
import 'package:canim/screens/allchats.dart';
import 'package:canim/screens/singleChat.dart';

//translation
import 'package:get/get.dart';

class UserItem extends StatefulWidget {
  final img;
  final name;
  final age;
  final bloodType;
  final email;
  final userID;
  UserItem(
      {this.img, this.name, this.age, this.bloodType, this.email, this.userID});
  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side:
              BorderSide(width: 1.0, style: BorderStyle.solid, color: redColor),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Image(
              width: 100,
              height: 120,
              image: NetworkImage(widget.img),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold
                        //color: Colors.grey,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'Age: '.tr + '${widget.age}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'Blood Type:'.tr + ' ${widget.bloodType}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    width: double.infinity,
                    height: 30.0,
                    color: redColor,
                    child: MaterialButton(
                      onPressed: () {
                        if (widget.userID ==
                            Provider.of<MyData>(context, listen: false).uid)
                          Navigator.of(context).pushNamed(MessangerScreen.id);
                        else
                          Navigator.of(context).pushNamed(SingleChat.id,
                              arguments: widget.userID);
                      },
                      child: Text(
                        'Contact Now'.tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
