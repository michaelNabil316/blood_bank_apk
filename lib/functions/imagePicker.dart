import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:canim/provider/providerClass.dart';

void pickProfileImage(BuildContext context, String uid) async {
  final myProvider = Provider.of<MyData>(context, listen: false);
  final pickImage = await ImagePicker().getImage(
    source: ImageSource.gallery,
    maxHeight: 500,
    maxWidth: 500,
    imageQuality: 80,
  );
  //File image =  File(pickImage.path);
  final ref = FirebaseStorage.instance.ref().child('profileImage').child(uid);
  await ref.putFile(File(pickImage.path));
  String imageProfileUrl = await ref.getDownloadURL();
  //update profile image in realtime in user data
  myProvider.changeimgUrl(imageProfileUrl);
  FirebaseDatabase.instance.reference().child('Users').child(uid).set({
    'age': myProvider.age,
    'blood_type': myProvider.bloodType,
    'email': myProvider.email,
    'firstName': myProvider.firstName,
    'phone': myProvider.phone,
    'secondName': myProvider.lastName,
    'user_imgURL': imageProfileUrl,
    'chats': myProvider.chats,
    'Notification': myProvider.notification,
    'SavedPosts': myProvider.savedPosts,
    'government': myProvider.government,
  });
  //change provider and this not necessary
  myProvider.changeimgUrl(imageProfileUrl);
}
