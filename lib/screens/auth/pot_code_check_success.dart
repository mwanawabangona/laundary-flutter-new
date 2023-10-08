import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/screens/auth/login_screen_wrapper.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostCodeCheckSuccess extends ConsumerStatefulWidget {
  const PostCodeCheckSuccess({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostCodeCheckSuccessState();
}

class _PostCodeCheckSuccessState extends ConsumerState<PostCodeCheckSuccess> {
  @override
  Widget build(BuildContext context) {
    return LoginScreenWrapper(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            AppSpacerH(40.h),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  context.nav.pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
            ),
            AppSpacerH(20.h),
            SizedBox(
              height: 230.h,
              width: 375.w,
              child: const Center(
                child: Icon(
                  Icons.check,
                  color: AppColors.primary,
                  size: 120,
                ),
              ),
            ),
            AppSpacerH(40.h),
            Text(
              "We are available in your area \nYou can now get started by registering",
              style: AppTextDecor.osRegular14white
                  .copyWith(color: AppColors.primary, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            AppSpacerH(40.h),
            AppTextButton(
              onTap: () {
                context.nav.pushNamedAndRemoveUntil(
                  Routes.signUpScreen,
                  (route) {
                    return false;
                  },
                );
              },
              title: "Go to registration",
              buttonColor: AppColors.primary,
              titleColor: AppColors.primary,
            )
          ],
        ),
      ),
    );
  }
}
