import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String bText;
  final Function function;
  final Color colorOfBak;
  final Color txtColor;
  final double minWidth, height;
  ButtonWidget(this.colorOfBak, this.bText, this.txtColor, this.function,
      this.height, this.minWidth);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        //elevation: 5.0,
        color: colorOfBak,
        borderRadius: BorderRadius.circular(12.0),
        child: MaterialButton(
          onPressed: function,
          minWidth: minWidth,
          height: height,
          child: Text(
            bText,
            style: TextStyle(color: txtColor, fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}
