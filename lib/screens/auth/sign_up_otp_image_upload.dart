import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/providers/auth_provider.dart';
import 'package:laundry_customer/providers/profile_update_provider.dart';
import 'package:laundry_customer/screens/auth/login_screen_wrapper.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/button_with_icon_righ.dart';
import 'package:laundry_customer/widgets/buttons/rounder_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

class SignUpImageUpload extends ConsumerStatefulWidget {
  const SignUpImageUpload({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SignUpImageUploadState();
}

class _SignUpImageUploadState extends ConsumerState<SignUpImageUpload> {
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();

  File? image;

  @override
  Widget build(BuildContext context) {
    return LoginScreenWrapper(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 44.h, 20.w, 0),
          height: 812.h,
          width: 375.w,
          child: Column(
            children: [
              // const AppNavbar(
              //   showBack: false,
              // ),
              Text(
                S.of(context).upldaphto,
                style:
                    AppTextDecor.osBold30black.copyWith(color: AppColors.black),
                textAlign: TextAlign.center,
              ),
              AppSpacerH(5.h),
              Text(
                "You can upload an image as your Profile Photo",
                style: AppTextDecor.osRegular18black
                    .copyWith(color: AppColors.black),
                textAlign: TextAlign.center,
              ),
              AppSpacerH(44.h),
              SizedBox(
                height: 300.h,
                width: 335.w,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 33.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (image == null) {
                            final ImagePicker picker = ImagePicker();
                            // Pick an image
                            final XFile? images = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (images != null) {
                              setState(() {
                                image = File(images.path);
                              });
                            }
                          } else {
                            setState(() {
                              image = null;
                            });
                          }
                        },
                        child: Stack(
                          children: [
                            if (image != null)
                              Image.file(
                                image!,
                                height: 100.h,
                                width: 100.w,
                              )
                            else
                              SvgPicture.asset(
                                'assets/svgs/icon_user_image.svg',
                                color: AppColors.primary,
                                semanticsLabel: 'Top Logo',
                                height: 100.h,
                                width: 100.w,
                              ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 26.h,
                                width: 26.w,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12.w),
                                ),
                                child: Icon(
                                  image != null
                                      ? Icons.close
                                      : Icons.photo_camera,
                                  color: AppColors.primary,
                                  size: 18.h,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 60.h,
                        child: ref.watch(imageUploadProvider).map(
                              initial: (_) => AppRountedTextButton(
                                buttonColor: AppColors.primary,
                                titleColor: AppColors.white,
                                title: "Upload a profile photo",
                                onTap: () {
                                  if (image != null) {
                                    ref
                                        .watch(imageUploadProvider.notifier)
                                        .addProfilePhoto(image!);
                                  } else {
                                    EasyLoading.showError(
                                      S.of(context).plslctanimg,
                                    );
                                  }
                                },
                              ),
                              loading: (_) => const LoadingWidget(),
                              loaded: (_) {
                                Future.delayed(transissionDuration)
                                    .then((value) {
                                  ref.refresh(
                                    imageUploadProvider,
                                  );
                                  ref.refresh(
                                    profileInfoProvider,
                                  ); //Refresh This so That App Doesn't Auto Login

                                  Future.delayed(buildDuration).then((value) {
                                    context.nav.pushNamedAndRemoveUntil(
                                      Routes.signUpComeplete,
                                      (route) => false,
                                    );
                                  });
                                });
                                return MessageTextWidget(
                                  msg: S.of(context).scs,
                                );
                              },
                              error: (_) {
                                Future.delayed(transissionDuration)
                                    .then((value) {
                                  ref.refresh(imageUploadProvider);
                                });
                                return ErrorTextWidget(error: _.error);
                              },
                            ),
                      )
                    ],
                  ),
                ),
              ),
              AppSpacerH(106.h),
              AppRightIconTextButton(
                buttonColor: AppColors.primary,
                titleColor: AppColors.white,
                icon: Icons.arrow_forward,
                title: S.of(context).skipiwluldltr,
                onTap: () {
                  context.nav.pushNamed(
                    Routes.signUpComeplete,
                  );
                  // context.nav.pushNamedAndRemoveUntil(
                  //     Routes.signUpComeplete, (route) => false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
