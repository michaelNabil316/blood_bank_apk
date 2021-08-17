import 'package:canim/provider/providerClass.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

void setCurrentUserData(context) async {
  var myProvider = Provider.of<MyData>(context);
  FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(myProvider.uid)
      .once()
      .then((DataSnapshot snapshot) {
    myProvider.changefirstName(snapshot.value['firstName']);
    myProvider.changelastName(snapshot.value['secondName']);
    myProvider.changeUserEmail(snapshot.value['email']);
    myProvider.changegovernment(snapshot.value['government']);
    myProvider.changeBloodType(snapshot.value['blood_type']);
    myProvider.changeUserAge(snapshot.value['age']);
    myProvider.changeUserPhone(snapshot.value['phone']);
    myProvider.changeimgUrl(snapshot.value['user_imgURL']);
    myProvider.changeChats(snapshot.value['chats']);
    myProvider.changeNotification(snapshot.value['Notification']);
    myProvider.changeSavedPosts(snapshot.value['SavedPosts']);
  }).catchError((err) => print(err));
}
