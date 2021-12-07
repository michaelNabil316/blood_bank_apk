import 'package:flutter/material.dart';
//translation
import 'package:get/get.dart';

class AboutUsScreen extends StatelessWidget {
  static String id = 'AboutUsScreen';
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: getAboutUs(height: height),
    );
  }
}

Widget getAboutUs({height}) {
  return Scaffold(
    //backgroundColor: kMainColor,
    body: SafeArea(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  alignment: Alignment.center,
                  //padding: EdgeInsets.only(top: 30),
                  height: height * .2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      /* Image(
                          image: AssetImage('assets/icons/image.jpg'),
                          width: 120,   
                      ), */
                      CircleAvatar(
                        radius: height * 0.07,
                        backgroundImage: NetworkImage(
                            'https://googleflutter.com/sample_image.jpg'),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Text(
                          'Blood Bank',
                          style: TextStyle(
                            fontSize: 24,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1.5
                              ..color = Colors.pinkAccent,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Text(
                '1.0.0',
                style: TextStyle(fontSize: 24, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              Text('Developed By Hero Soft Company'.tr,
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  textAlign: TextAlign.center),
              /* IconButton(
                  // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                  icon: Icon(Icons.facebook), //FaIcon(FontAwesomeIcons.gamepad),
                  onPressed: () {
                    print("Pressed");
                  }), */
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "A website as well as a mobile application that provides a quick way for users who need a blood transfusion, for themselves or their families To find a donor when they need it. It also provides the opportunity for every donor who wishes to help to provide that assistance at a time when the patient needs it. This is done by registering in our system, and then the user shares a post with all the donors who are with him in this system, in which he requests the blood type he needs and the place and time he needs that type.The user can also search or communicate with other users through conversations. The system ensures that this is done as quickly as possible because delays in such a case could cost us a human life"
                        .tr),
              ),
              /*
                ),
                //SizedBox(height: height * 0.07),
              )
          */
            ],
          ),
        ),
      ),
    ),
  );
}
