import 'package:flutter/material.dart';

class CircleImgLoader extends StatelessWidget {
  final width;
  const CircleImgLoader({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: width,
      backgroundColor: Colors.white,
      child: Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Image.asset('assets/images/loading.gif'),
      ),
    );
  }
}
