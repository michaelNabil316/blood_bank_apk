import 'package:flutter/material.dart';

class Dropdownlist extends StatefulWidget {
  //const DropBloodTypes({ Key? key }) : super(key: key);
  var arrList = [];
  var dropdownValue;
  var containerWidth = 70.0;
  Function fun;
  Dropdownlist(
      {this.dropdownValue, this.arrList, this.containerWidth, this.fun});
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
      padding: EdgeInsets.only(left: 5, right: 5),
      decoration: ShapeDecoration(
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
