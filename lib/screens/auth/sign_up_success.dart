import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/config.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

class SignUpComplete extends StatelessWidget {
  const SignUpComplete({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 88.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/firework@2x.png',
              width: 310.w,
              height: 265.h,
            ),
            AppSpacerH(30.h),
            Text(
              S.of(context).cngrts,
              style:
                  AppTextDecor.osBold24black.copyWith(color: AppColors.black),
            ),
            AppSpacerH(10.h),
            Text(
              'You have successfully signed up on ${AppConfig.appName}',
              style: AppTextDecor.osRegular18black
                  .copyWith(color: AppColors.black),
              textAlign: TextAlign.center,
            ),
            AppSpacerH(111.h),
            AppTextButton(
              buttonColor: AppColors.primary,
              titleColor: AppColors.white,
              title: S.of(context).grt,
              onTap: () {
                context.nav.pushNamedAndRemoveUntil(
                  Routes.homeScreen,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
