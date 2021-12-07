import 'package:blood_bank/business_logic/cubit/bloc.dart';
import 'package:firebase_database/firebase_database.dart';

void setCurrentUserData(context) async {
  var appBloc = AppBloc.get(context);
  FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(appBloc.uid)
      .once()
      .then((DataSnapshot snapshot) {
    appBloc.changefirstName(snapshot.value['firstName']);
    appBloc.changelastName(snapshot.value['secondName']);
    appBloc.changeUserEmail(snapshot.value['email']);
    appBloc.changegovernment(snapshot.value['government']);
    appBloc.changeBloodType(snapshot.value['blood_type']);
    appBloc.changeUserAge(snapshot.value['age']);
    appBloc.changeUserPhone(snapshot.value['phone']);
    appBloc.changeimgUrl(snapshot.value['user_imgURL']);
    appBloc.changeChats(snapshot.value['chats']);
    appBloc.changeNotification(snapshot.value['Notification']);
    appBloc.changeSavedPosts(snapshot.value['SavedPosts']);
  }).catchError((err) => print(err));
}
