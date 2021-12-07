import 'package:flutter/material.dart';

class Dropdownlist extends StatefulWidget {
  var arrList = [];
  var dropdownValue;
  double containerWidth;
  final void Function(String?) fun;
  Dropdownlist(
      {this.dropdownValue,
      required this.arrList,
      this.containerWidth = 70.0,
      required this.fun,
      Key? key})
      : super(key: key);
  @override
  _DropBloodTypesState createState() => _DropBloodTypesState();
}

class _DropBloodTypesState extends State<Dropdownlist> {
  @override
  Widget build(BuildContext context) {
    //widget.dropdownValue = widget.arrList[0];
    return Container(
      height: 30,
      width: widget.containerWidth,
      padding: const EdgeInsets.only(left: 5, right: 5),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.0, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          items: widget.arrList.map<DropdownMenuItem<String>>((selectedItem) {
            return DropdownMenuItem<String>(
              value: selectedItem,
              child: Text(selectedItem),
            );
          }).toList(),
          onChanged: widget.fun,
          value: widget.dropdownValue,
          dropdownColor: Colors.white,
        ),
      ),
    );
  }
}
