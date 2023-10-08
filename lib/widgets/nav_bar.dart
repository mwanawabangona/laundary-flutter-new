import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';

class AppNavbar extends StatelessWidget {
  const AppNavbar({
    super.key,
    this.backgroundColor = AppColors.white,
    this.titleColor = AppColors.black,
    this.backButtionColor = AppColors.white,
    this.title,
    this.onBack,
    this.showBack = true,
  });
  final String? title;
  final Color titleColor;
  final Color backButtionColor;
  final Color backgroundColor;
  final Function()? onBack;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: backgroundColor,
          height: 44.h,
          width: 390.w,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: 44.h,
                    width: 260.w,
                    child: Center(
                      child: Text(
                        title ?? '',
                        style: AppTextDecor.osBold20white
                            .copyWith(fontSize: 18, color: titleColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        if (showBack)
          Positioned(
            top: 11.h,
            child: Hive.box(AppHSC.appSettingsBox)
                        .get(AppHSC.appLocal)
                        .toString() ==
                    "ar"
                ? RotatedBox(
                    quarterTurns: 2, // Rotate by 180 degrees (2 quarter turns)
                    child: GestureDetector(
                      onTap: onBack,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 34,
                        color: backButtionColor,
                      ),
                    ),
                    // AppBackButton(

                    //   size: 44.h,
                    //   onTap: onBack,
                    // ),
                  )
                : GestureDetector(
                    onTap: onBack,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: backButtionColor,
                    ),
                  ),
          )
      ],
    );
  }
}
