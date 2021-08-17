import 'package:flutter/material.dart';
import 'package:canim/constants.dart';
import 'package:canim/widgets/buttonWidget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:canim/provider/providerClass.dart';
//translation
import 'package:get/get.dart';

class BuilBottemReport extends StatefulWidget {
  final userId;
  BuilBottemReport(this.userId);

  @override
  _BuilBottemReportState createState() => _BuilBottemReportState();
}

class _BuilBottemReportState extends State<BuilBottemReport> {
  var details = '';

  @override
  Widget build(BuildContext context) {
    final myMediaQ = MediaQuery.of(context).size;
    final myProvider = Provider.of<MyData>(context);
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: myMediaQ.height * 0.4,
        width: myMediaQ.width * 0.9,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20.0),
              Text(
                'Report for this post'.tr,
                style: TextStyle(
                  color: redColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: Container(
                  //more details container
                  height: myMediaQ.height * 0.2,
                  width: myMediaQ.width * 0.7,
                  padding: EdgeInsets.only(left: 10),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      details = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'more details...'.tr,
                      border: null,
                    ),
                    maxLines: 7,
                  ),
                ),
              ),
              ButtonWidget(redColor, 'Report'.tr, Colors.white, () async {
                Navigator.of(context).pop();
                await FirebaseDatabase.instance
                    .reference()
                    .child('Admin')
                    .child('Report')
                    .child('${myProvider.uid}')
                    .set({'details': details, 'userID': widget.userId});
              }, myMediaQ.height * 0.05, myMediaQ.width * 0.3),
            ],
          ),
        ),
      ),
    );
  }
}
