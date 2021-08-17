import 'package:flutter/material.dart';
//import 'package:canim/widgets/post.dart';

class MyData extends ChangeNotifier {
  String uid = '5555';
  String email = 'email';
  String firstName = 'name';
  String lastName = 'name';
  String bloodType = 'A+';
  String government = 'Alexandera';
  int age = 0;
  int phone = 11111111111;
  var chats;
  var notification;
  var savedPosts;
  bool newNotification = false;
  int oldNotificLength = 0;
  String imgURL =
      'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg';

  void changeUserUID(String uID) {
    uid = uID;
    notifyListeners();
  }

  void changeBloodType(String bt) {
    bloodType = bt;
    notifyListeners();
  }

  void changeUserAge(int ag) {
    age = ag;
    notifyListeners();
  }

  void changeUserPhone(int ph) {
    phone = ph;
    notifyListeners();
  }

  void changeUserEmail(String em) {
    email = em;
    notifyListeners();
  }

  void changegovernment(String gv) {
    government = gv;
    notifyListeners();
  }

  void changefirstName(String na) {
    firstName = na;
    notifyListeners();
  }

  void changelastName(String na) {
    lastName = na;
    notifyListeners();
  }

  void changeimgUrl(String url) {
    imgURL = url;
    notifyListeners();
  }

  void changeChats(allChats) {
    chats = allChats;
    notifyListeners();
  }

  void changeNotification(notifi) {
    notification = notifi;
    notifyListeners();
  }

  void changeSavedPosts(saved) {
    savedPosts = saved;
    notifyListeners();
  }

  void changeNewNotification(bool isNew) {
    newNotification = isNew;
    notifyListeners();
  }

  void changeNotificationList(newList) {
    oldNotificLength = newList;
    notifyListeners();
  }
}
