import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.hint,
    required this.prefixIcon,
    required this.keyboardType,
    required this.controller,
     this.focuseBorderdColor = Colors.grey,
    this.sufficIcon,
    this.obscureText = false,
  }) : super(key: key);

  final String hint;
  final IconData prefixIcon ;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Color focuseBorderdColor;
  final Widget? sufficIcon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.cairo(),
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.cairo(fontSize: 13.sp),
        hintMaxLines: 1,
        suffixIcon: sufficIcon,
        prefixIcon: Icon(prefixIcon),
        enabledBorder: buildOutlineInputBorder(),
        contentPadding: EdgeInsets.zero,
        focusedBorder: buildOutlineInputBorder(color : focuseBorderdColor),

      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder({Color color  = Colors.grey}) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(
            color: color
        ),
      );
  }
}
