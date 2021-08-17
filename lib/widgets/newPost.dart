import 'package:flutter/material.dart';
import 'package:canim/widgets/buttonWidget.dart';
import 'package:canim/constants.dart';
import 'package:canim/widgets/dropdownlist.dart';
import 'package:canim/functions/citiesList.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:canim/provider/providerClass.dart';
import 'package:provider/provider.dart';

//translation
import 'package:get/get.dart';

const url = "https://bloodbank-4d6ac-default-rtdb.firebaseio.com/Posts/";
var bloodList = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
var bloodItem = 'A+';
//var governmentList = ['Alexandera', 'Cairo', 'Al-minya', 'Aswan'];
var governmentItem = 'Alexandera';
var city;
bool firstcity = true;
//final FirebaseMessaging _fcm = FirebaseMessaging();

//'time':DateTime.now().toIso8601String()
class ShowNewPostDialog extends StatefulWidget {
  //const ShowNewPostDialog({ Key? key }) : super(key: key);
  final isUpdatePost;
  final postKey;
  ShowNewPostDialog({this.isUpdatePost, this.postKey});
  @override
  _ShowNewPostDialogState createState() => _ShowNewPostDialogState();
}

class _ShowNewPostDialogState extends State<ShowNewPostDialog> {
  //pick the date of donation
  DateTime currentDate = DateTime.now().add(Duration(days: 1));
  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
  }

  //RealTime database
  final fbRefrance = FirebaseDatabase.instance.reference();
  var details = '';
  @override
  Widget build(BuildContext context) {
    var myMedia = MediaQuery.of(context).size;
    var list = cityList(governmentItem);
    var cityItem = cityList(governmentItem)[0];
    var myProvider = Provider.of<MyData>(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ), //this right here
      child: Container(
        height: myMedia.height * 0.6,
        width: myMedia.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.0),
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
                      fun: (String bloodtype) {
                        setState(() {
                          bloodItem = bloodtype;
                        });
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
                      fun: (String bloodtype) {
                        setState(() {
                          firstcity = true;
                          governmentItem = bloodtype;
                          cityItem = governments[0];
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
                      fun: (String value) {
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
                    FlatButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: Text(
                          '${currentDate.day}-${currentDate.month}-${currentDate.year}'),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  //more details container
                  height: myMedia.height * 0.2,
                  width: myMedia.width * 0.7,
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
              ButtonWidget(
                  redColor,
                  widget.isUpdatePost ? 'Update'.tr : 'Share'.tr,
                  Colors.white, () async {
                //upload the post to the fireebase
                final dat = DateTime.now();
                final fbRefrancePush = fbRefrance.child('Posts').push();
                final post = {
                  'key': fbRefrancePush.key,
                  'name': '${myProvider.firstName} ${myProvider.lastName}',
                  'blood_type': bloodItem,
                  'government': governmentItem,
                  'city': firstcity ? cityItem : city,
                  'userID': myProvider.uid,
                  'user_email': myProvider.email,
                  'donDate': '$currentDate',
                  'user_imgURL': myProvider.imgURL,
                  'postDate': '$dat',
                  'details': details,
                };
                if (widget.isUpdatePost) {
                  fbRefrance
                      .child('Posts')
                      .child(widget.postKey)
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
                      'email': myProvider.email,
                      'firstName': myProvider.firstName,
                      'phone': myProvider.phone,
                      'user_imgURL': myProvider.imgURL,
                      'time': '$dat',
                      'key': fbRefrancePush.key
                    });
                  }
                }
                Navigator.of(context).pop();
              }, myMedia.height * 0.05, myMedia.width * 0.3),
            ],
          ),
        ),
      ),
    );
  }
}
