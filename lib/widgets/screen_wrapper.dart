import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/misc/global_functions.dart';

class ScreenWrapper extends StatelessWidget {
  const ScreenWrapper({
    super.key,
    this.color = AppColors.white,
    required this.child,
    this.padding,
  });
  final Color color;
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    AppGFunctions.changeStatusBarColor(color: Colors.transparent);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        height: 812.h,
        width: 375.w,
        padding: padding ?? EdgeInsets.fromLTRB(20.w, 44.h, 20.w, 0),
        color: color,
        child: child,
      ),
    );
  }
}
