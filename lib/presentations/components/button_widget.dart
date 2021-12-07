import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class ButtonWidget extends StatelessWidget {
  final String? bText;
  final Callback? function;
  final Color? colorOfBak;
  final Color? txtColor;
  final double? minWidth, height;
  const ButtonWidget(this.colorOfBak, this.bText, this.txtColor, this.function,
      this.height, this.minWidth,
      {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        //elevation: 5.0,
        color: colorOfBak,
        borderRadius: BorderRadius.circular(12.0),
        child: MaterialButton(
          onPressed: function,
          minWidth: minWidth,
          height: height,
          child: Text(
            '$bText',
            style: TextStyle(color: txtColor, fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}
