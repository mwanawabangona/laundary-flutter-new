import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/widgets/busy_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacerH extends StatelessWidget {
  const AppSpacerH(
    this.height, {
    super.key,
  });
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class AppSpacerW extends StatelessWidget {
  const AppSpacerW(
    this.width, {
    super.key,
  });
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}

// ignore: must_be_immutable
class CustomSeprator extends StatelessWidget {
  CustomSeprator({super.key, this.color, this.height, this.width});
  Color? color;
  double? height;
  double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 1.h,
      width: width ?? double.infinity,
      color: color ?? AppColors.grayBG,
    );
  }
}

class ErrorTextWidget extends StatelessWidget {
  const ErrorTextWidget({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error,
        style: AppTextDecor.osRegular14red,
      ),
    );
  }
}

class MessageTextWidget extends StatelessWidget {
  const MessageTextWidget({super.key, required this.msg});
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        msg,
        style:
            AppTextDecor.osSemiBold14black.copyWith(color: AppColors.primary),
      ),
    );
  }
}

// class LoadingWidget extends StatelessWidget {
//   const LoadingWidget({Key? key, this.showBG = false}) : super(key: key);
//   final bool showBG;

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: CircularProgressIndicator(
//         color: AppColors.gold,
//       ),
//     );
//   }
// }

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.showBG = false});
  final bool showBG;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BusyLoader(showbackground: showBG),
    );
  }
}
