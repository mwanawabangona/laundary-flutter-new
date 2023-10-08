import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_box_decoration.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/providers/settings_provider.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:laundry_customer/widgets/screen_wrapper.dart';

class AboutUs extends ConsumerWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(aboutUsProvider);
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Container(
        height: 812.h,
        width: 375.w,
        color: AppColors.grayBG,
        child: Stack(
          children: [
            SizedBox(
              child: Column(
                children: [
                  Container(
                    height: 222.h,
                    width: 375.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.w),
                        bottomRight: Radius.circular(15.w),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.2),
                          offset: const Offset(0, 2),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Column(
                        children: [
                          AppSpacerH(44.h),
                          AppNavbar(
                            backgroundColor: AppColors.primary,
                            titleColor: AppColors.white,
                            title: S.of(context).abtus,
                            onBack: () {
                              context.nav.pop();
                            },
                          ),
                          Expanded(
                            child: Image.asset(
                              'assets/images/logo.png',
                              color: AppColors.white,
                            ),
                          ),
                          AppSpacerH(20.h)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ref.watch(aboutUsProvider).map(
                          initial: (_) => const SizedBox(),
                          loading: (_) => const LoadingWidget(),
                          loaded: (_) => SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.0.h),
                                  child: Html(
                                    style: {
                                      '*': Style(
                                        color: AppColors.navyText,
                                        fontSize: FontSize(14.sp),
                                        fontFamily: 'Open Sans',
                                      )
                                    },
                                    data:
                                        '${_.data.data!.setting!.content!}<p></p><p></p><p></p><p></p><p></p>',
                                  ),
                                ),
                                AppSpacerH(60.h)
                              ],
                            ),
                          ),
                          error: (_) => ErrorTextWidget(error: _.error),
                        ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 375.w,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 15.h,
                ),
                decoration: AppBoxDecorations.pageCommonCard,
                child: AppTextButton(
                  title: S.of(context).cls,
                  onTap: () async {
                    context.nav.pop();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
