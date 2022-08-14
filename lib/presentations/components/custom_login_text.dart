import 'package:flutter/material.dart';
import '../constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController ctrl;
  final String? hintTitle;
  final String? Function(String?)? validFun;
  final bool havePerfixIcon;
  final void Function(String)? onChange;
  const CustomTextField({
    Key? key,
    required this.ctrl,
    this.validFun,
    this.hintTitle,
    this.onChange,
    required this.havePerfixIcon,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isSecure = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.havePerfixIcon ? isSecure : false,
      controller: widget.ctrl,
      decoration: kTextFieldDecoration.copyWith(
        hintText: widget.hintTitle,
        prefixIcon: widget.havePerfixIcon
            ? GestureDetector(
                child: Icon(isSecure
                    ? Icons.visibility_off
                    : Icons.remove_red_eye_outlined),
                onTap: () {
                  setState(() {
                    isSecure = !isSecure;
                  });
                },
              )
            : null,
      ),
      validator: widget.validFun,
      onChanged: widget.onChange,
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get_utils/src/extensions/internacionalization.dart';

// import '../constants.dart';

// class CustomTextFiled extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final String? Function(String?)? validationFunc;
//   const CustomTextFiled({
//     Key? key,
//     required this.controller,
//     required this.hintText,
//     this.validationFunc,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       onChanged: (value) {},
//       decoration: KTextFieldDecoration.copyWith(
//         hintText: hintText.tr,
//         //  errorText: errorText.tr,
//       ),
//       validator: validationFunc,
//     );
//   }
// }
