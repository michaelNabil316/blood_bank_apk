import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final time;
  const MessageBubble(this.text, this.sender, this.time, this.isMe, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            elevation: 5.0,
            color: isMe
                ? (const Color.fromARGB(255, 255, 255, 199))
                : (Colors.white),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                text,
                style: const TextStyle(fontSize: 18.0, color: Colors.black),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
