import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/button_with_icon_righ.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/journey_dot.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/on_boarding_slider.dart';
import 'package:laundry_customer/widgets/screen_wrapper.dart';

// ignore: must_be_immutable
class OnBoardingScreen extends ConsumerWidget {
  OnBoardingScreen({super.key});
  bool shouldAnimate = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(onBoardingSliderIndexProvider);
    final imgPageController =
        ref.watch(onBoardingSliderControllerProvider('image'));
    shouldAnimate = true;
    return ScreenWrapper(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 165.h,
                  width: 195.w,
                ),
              ),
              AnimatedScale(
                duration: transissionDuration,
                scale: shouldAnimate ? 1 : 0,
                child: const OnBoadringImageSlider(),
              ),
              AppSpacerH(20.h),
              SizedBox(
                width: 335.w,
                height: 6.h,
                child: CustomJourneyDot(activeIndex: index, count: 3),
              ),
              AppSpacerH(20.h),
              const OnBoadringTextSlider(),
              AppSpacerH(20.h),
              AppTextButton(
                buttonColor: AppColors.primary,
                title: 'Let`s Get Started',
                titleColor: AppColors.white,
                onTap: () {
                  if (index < 2) {
                    ref
                        .watch(onBoardingSliderIndexProvider.notifier)
                        .update((state) {
                      imgPageController.animateToPage(
                        state + 1,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                      return state + 1;
                    });
                  } else {
                    final Box appSettingsBox = Hive.box(AppHSC.appSettingsBox);
                    appSettingsBox.put(AppHSC.hasSeenSplashScreen, true);
                    context.nav.pushNamedAndRemoveUntil(
                      Routes.homeScreen,
                      (route) => false,
                    );
                  }
                },
              )
            ],
          ),
          if (index < 2)
            Positioned(
              right: 0,
              top: 0,
              child: AppRightIconTextButton(
                buttonColor: AppColors.primary,
                icon: Icons.arrow_right,
                title: 'Skip',
                titleColor: AppColors.white,
                height: 30.h,
                width: 65.w,
                onTap: () {
                  final Box appSettingsBox = Hive.box(AppHSC.appSettingsBox);
                  appSettingsBox.put(AppHSC.hasSeenSplashScreen, true);
                  context.nav.pushNamedAndRemoveUntil(
                    Routes.homeScreen,
                    (route) => false,
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}

final List<ObSliderData> slideData = [
  ObSliderData(
    image: 'assets/images/01.tutoral.png',
    text: 'Order online or via our app',
  ),
  ObSliderData(
    image: 'assets/images/02.tutorial.png',
    text: 'We Collect at a time that suits you and work our magic',
  ),
  ObSliderData(
    image: 'assets/images/03.tutorial.png',
    text: 'We return your clean clothes back to you',
  ),
];

class ObSliderData {
  String image;
  String text;
  ObSliderData({
    required this.image,
    required this.text,
  });
}
