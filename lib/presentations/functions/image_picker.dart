import 'dart:io';
import 'package:blood_bank/business_logic/cubit/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_cropper/image_cropper.dart';

void pickProfileImage(BuildContext context, String uid) async {
  final appBloc = AppBloc.get(context);

  PickedFile? pickImage = await ImagePicker().getImage(
    source: ImageSource.gallery,
  );
  //File cropedImage = File(pickImage!.path);
  var cropedImage;
  if (pickImage != null) {
    cropedImage = await ImageCropper.cropImage(
        sourcePath: pickImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square]);
  }

  final ref = FirebaseStorage.instance.ref().child('profileImage').child(uid);
  //emit state loader for profile image
  AppBloc.get(context).changeProfileImage();
  //upload the new image
  await ref.putFile(cropedImage ?? File(pickImage!.path));
  String imageProfileUrl = await ref.getDownloadURL();
  //update profile image in realtime in user data
  appBloc.changeimgUrl(imageProfileUrl);
  FirebaseDatabase.instance.reference().child('Users').child(uid).set({
    'age': appBloc.age,
    'blood_type': appBloc.bloodType,
    'email': appBloc.email,
    'firstName': appBloc.firstName,
    'phone': appBloc.phone,
    'secondName': appBloc.lastName,
    'user_imgURL': imageProfileUrl,
    'chats': appBloc.chats,
    'Notification': appBloc.notification,
    'SavedPosts': appBloc.savedPosts,
    'government': appBloc.government,
  });
}
