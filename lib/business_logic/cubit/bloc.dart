import 'package:blood_bank/business_logic/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Cubit<AppState> {
  AppBloc() : super(AppInitialState());
  static AppBloc get(context) => BlocProvider.of(context);
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

  void changeNewNotification(bool value) {
    newNotification = value;
    emit(UpdateNotificationState());
  }

  void changeNotificationList(int value) {
    oldNotificLength = value;
    emit(UpdateNotificationState());
  }

  void changeimgUrl(String value) {
    imgURL = value;
    emit(UpdateUrlState());
  }

  void changefirstName(String value) {
    firstName = value;
    emit(UpdateUserState());
  }

  void changelastName(String value) {
    lastName = value;
    emit(UpdateUserState());
  }

  void changeUserEmail(String value) {
    email = value;
    emit(UpdateUserState());
  }

  void changegovernment(String value) {
    government = value;
    emit(UpdateUserState());
  }

  void changeBloodType(String value) {
    bloodType = value;
    emit(UpdateUserState());
  }

  void changeUserAge(int value) {
    age = value;
    emit(UpdateUserState());
  }

  void changeUserPhone(int value) {
    phone = value;
    emit(UpdateUserState());
  }

  void changeChats(var value) {
    chats = value;
    emit(UpdateUserState());
  }

  void changeNotification(var value) {
    notification = value;
    emit(UpdateUserState());
  }

  void changeSavedPosts(var value) {
    savedPosts = value;
    emit(UpdateUserState());
  }

  void changeUserUID(String value) {
    uid = value;
    emit(UpdateUserState());
  }

  void changeProfileImage() {
    emit(ChangeProfileImageState());
  }
}
