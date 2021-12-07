import 'package:blood_bank/business_logic/cubit/bloc.dart';
import 'package:blood_bank/business_logic/cubit/states.dart';
import 'package:blood_bank/presentations/functions/citiesList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

//translation
import 'package:get/get.dart';

import 'button_widget.dart';
import 'dropdownlist.dart';

const url = "https://bloodbank-4d6ac-default-rtdb.firebaseio.com/Posts/";
var bloodList = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
var bloodItem = 'A+';
//var governmentList = ['Alexandera', 'Cairo', 'Al-minya', 'Aswan'];
var governmentItem = 'Alexandera';
String? city;
bool firstcity = true;
//final FirebaseMessaging _fcm = FirebaseMessaging();

//'time':DateTime.now().toIso8601String()
class ShowNewPostDialog extends StatefulWidget {
  final bool isUpdatePost;
  final String? postKey;
  const ShowNewPostDialog({Key? key, required this.isUpdatePost, this.postKey})
      : super(key: key);
  @override
  _ShowNewPostDialogState createState() => _ShowNewPostDialogState();
}

class _ShowNewPostDialogState extends State<ShowNewPostDialog> {
  //pick the date of donation
  DateTime currentDate = DateTime.now().add(const Duration(days: 1));
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
    }
  }

  //RealTime database
  final fbRefrance = FirebaseDatabase.instance.reference();
  var details = '';
  @override
  Widget build(BuildContext context) {
    var myMedia = MediaQuery.of(context).size;
    var list = cityList(governmentItem);
    var cityItem = cityList(governmentItem)[0];
    final appbloc = AppBloc.get(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ), //this right here
      child: SizedBox(
        height: myMedia.height * 0.6,
        width: myMedia.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Add Post'.tr,
                  style: addPostStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: myMedia.width * 0.1, right: myMedia.width * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'blood type:    '.tr,
                      style: bloodTypeStyle,
                    ),
                    Dropdownlist(
                      arrList: bloodList,
                      dropdownValue: bloodItem,
                      fun: (String? bloodtype) {
                        setState(() {
                          bloodItem = bloodtype!;
                        });
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(
                    left: myMedia.width * 0.1, right: myMedia.width * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Governorate: '.tr,
                      style: bloodTypeStyle,
                    ),
                    Dropdownlist(
                      arrList: governments,
                      dropdownValue: governmentItem,
                      containerWidth: 120,
                      fun: (String? bloodtype) {
                        setState(() {
                          firstcity = true;
                          governmentItem = bloodtype!;
                          cityItem = governments[0];
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(
                    left: myMedia.width * 0.1, right: myMedia.width * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'City:                '.tr,
                      style: bloodTypeStyle,
                    ),
                    Dropdownlist(
                      arrList: list,
                      dropdownValue: firstcity ? cityItem : city,
                      containerWidth: 120,
                      fun: (String? value) {
                        setState(() {
                          city = value;
                          firstcity = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: myMedia.width * 0.1, right: myMedia.width * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Donation time:'.tr,
                      style: bloodTypeStyle,
                    ),
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: redColor),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                              '${currentDate.day}-${currentDate.month}-${currentDate.year}'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  //more details container
                  height: myMedia.height * 0.2,
                  width: myMedia.width * 0.7,
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
                return ButtonWidget(
                    redColor,
                    widget.isUpdatePost ? 'Update'.tr : 'Share'.tr,
                    Colors.white, () async {
                  //upload the post to the fireebase
                  final dat = DateTime.now();
                  final fbRefrancePush = fbRefrance.child('Posts').push();
                  final post = {
                    'key': fbRefrancePush.key,
                    'name': '${appbloc.firstName} ${appbloc.lastName}',
                    'blood_type': bloodItem,
                    'government': governmentItem,
                    'city': firstcity ? cityItem : city,
                    'userID': appbloc.uid,
                    'user_email': appbloc.email,
                    'donDate': '$currentDate',
                    'user_imgURL': appbloc.imgURL,
                    'postDate': '$dat',
                    'details': details,
                  };
                  if (widget.isUpdatePost) {
                    fbRefrance
                        .child('Posts')
                        .child('${widget.postKey}')
                        .update(post); //for update
                  } else {
                    fbRefrancePush.set(post); //for new post
                    final usersWithSameBT = await fbRefrance
                        .child('Users')
                        .orderByChild('blood_type')
                        .equalTo(bloodItem)
                        .once();
                    for (var key in usersWithSameBT.value.keys) {
                      fbRefrance
                          .child('Users')
                          .child(key)
                          .child('Notification')
                          .push()
                          .set({
                        'email': appbloc.email,
                        'firstName': appbloc.firstName,
                        'phone': appbloc.phone,
                        'user_imgURL': appbloc.imgURL,
                        'time': '$dat',
                        'key': fbRefrancePush.key
                      });
                    }
                  }
                  Navigator.of(context).pop();
                }, myMedia.height * 0.05, myMedia.width * 0.3);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
