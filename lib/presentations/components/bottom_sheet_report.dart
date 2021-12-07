import 'package:blood_bank/business_logic/cubit/bloc.dart';
import 'package:blood_bank/business_logic/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants.dart';
import 'button_widget.dart';
import 'package:firebase_database/firebase_database.dart';
//translation
import 'package:get/get.dart';

class BuilBottemReport extends StatefulWidget {
  final String userId;
  const BuilBottemReport({Key? key, required this.userId}) : super(key: key);

  @override
  _BuilBottemReportState createState() => _BuilBottemReportState();
}

class _BuilBottemReportState extends State<BuilBottemReport> {
  var details = '';

  @override
  Widget build(BuildContext context) {
    final myMediaQ = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SizedBox(
        height: myMediaQ.height * 0.4,
        width: myMediaQ.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20.0),
              Text(
                'Report for this post'.tr,
                style: const TextStyle(
                  color: redColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Container(
                  //more details container
                  height: myMediaQ.height * 0.2,
                  width: myMediaQ.width * 0.7,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: const ShapeDecoration(
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
              BlocBuilder<AppBloc, AppState>(builder: (context, state) {
                return ButtonWidget(redColor, 'Report'.tr, Colors.white,
                    () async {
                  Navigator.of(context).pop();
                  await FirebaseDatabase.instance
                      .reference()
                      .child('Admin')
                      .child('Report')
                      .child(AppBloc.get(context).uid)
                      .set({'details': details, 'userID': widget.userId});
                }, myMediaQ.height * 0.05, myMediaQ.width * 0.3);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
