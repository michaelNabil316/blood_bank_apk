import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final time;
  MessageBubble(this.text, this.sender, this.time, this.isMe);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.all(Radius.circular(12.0)
                // bottomLeft: Radius.circular(12.0),
                // bottomRight: Radius.circular(12.0),
                // topLeft: isMe ? Radius.circular(12.0) : Radius.circular(0.0),
                // topRight: isMe ? Radius.circular(0.0) : Radius.circular(12.0)
                ),
            elevation: 5.0,
            color: isMe ? (Color.fromARGB(255, 255, 255, 199)) : (Colors.white),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                '$text',
                style: TextStyle(fontSize: 18.0, color: Colors.black),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
