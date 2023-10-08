import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/providers/auth_provider.dart';
import 'package:laundry_customer/screens/auth/login_screen_wrapper.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class SignUpOtpVerification extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  final String forEmailorPhone;

  SignUpOtpVerification({super.key, required this.forEmailorPhone});

  @override
  Widget build(BuildContext context) {
    return LoginScreenWrapper(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 44.h, 20.w, 0),
          height: 812.h,
          width: 375.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppNavbar(
                onBack: () {
                  context.nav.pop();
                },
              ),
              Text(
                S.of(context).entrotp,
                style: AppTextDecor.osBold30black,
              ),
              AppSpacerH(5.h),
              Text(
                '${S.of(context).ndgtotp} $forEmailorPhone',
                style: AppTextDecor.osRegular18black,
              ),
              AppSpacerH(44.h),
              Expanded(
                child: Column(
                  children: [
                    AppSpacerH(33.h),
                    Form(
                      key: formKey,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        hintCharacter: '_',
                        animationType: AnimationType.fade,
                        validator: (v) {
                          debugPrint(v);
                          return null;
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(3.w),
                          fieldHeight: 50.w,
                          fieldWidth: 70.w,
                          inactiveFillColor: AppColors.white,
                          activeFillColor: AppColors.white,
                          activeColor: AppColors.white,
                          errorBorderColor: AppColors.white,
                          inactiveColor: AppColors.white,
                        ),
                        cursorColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        onCompleted: (v) {
                          debugPrint("Completed");
                        },
                        onChanged: (String value) {
                          debugPrint("Changed : $value");
                        },
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final int time = ref.watch(forgotPassTimerProvider);
                        ref.watch(registrationResendOtpProvider);
                        // if (time <= 0) {
                        //   ref.refresh(registrationResendOtpProvider);
                        // }
                        return SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (time > 0)
                                Text(
                                  '${S.of(context).otpwillbesnd} 00 : ${time > 9 ? time : '0$time'}',
                                  style: AppTextDecor.osRegular14black,
                                )
                              else
                                const SizedBox(),
                              if (time <= 0)
                                ref
                                    .watch(registrationResendOtpProvider)
                                    .maybeMap(
                                      orElse: () {
                                        return const SizedBox();
                                      },
                                      initial: (_) {
                                        return GestureDetector(
                                          onTap: () async {
                                            await ref
                                                .watch(
                                                  registrationResendOtpProvider
                                                      .notifier,
                                                )
                                                .resendOtp(
                                                  forEmailorPhone,
                                                )
                                                .then((value) {
                                              ref
                                                  .watch(
                                                    forgotPassTimerProvider
                                                        .notifier,
                                                  )
                                                  .startTimer();
                                              ref.refresh(
                                                registrationResendOtpProvider,
                                              );
                                            });
                                          },
                                          child: Text(
                                            S.of(context).rsndotp,
                                            style: AppTextDecor.osBold14red,
                                          ),
                                        );
                                      },
                                      loading: (_) => SizedBox(
                                        height: 10.h,
                                        width: 10.w,
                                        child: const LoadingWidget(),
                                      ),
                                      error: (_) {
                                        return const SizedBox();
                                      },
                                    )
                              else
                                const SizedBox()
                            ],
                          ),
                        );
                      },
                    ),
                    AppSpacerH(129.h),
                    SizedBox(
                      height: 50.h,
                      child: Consumer(
                        builder: (context, ref, child) {
                          return ref.watch(registrationOtpVerifyProvider).map(
                            error: (_) {
                              Future.delayed(transissionDuration).then((value) {
                                ref.refresh(registrationOtpVerifyProvider);
                              });
                              return ErrorTextWidget(error: _.error);
                            },
                            loaded: (_) {
                              Future.delayed(transissionDuration).then((value) {
                                ref.refresh(
                                  registrationOtpVerifyProvider,
                                ); //Refresh This so That App Doesn't Auto Login

                                Future.delayed(buildDuration).then((value) {
                                  context.nav.pushNamed(
                                    Routes.signUpImageUpload,
                                  );
                                });
                              });
                              return MessageTextWidget(
                                msg: S.of(context).scs,
                              );
                            },
                            initial: (_) {
                              return AppTextButton(
                                buttonColor: AppColors.primary,
                                title: S.of(context).vrfyotp,
                                titleColor: AppColors.white,
                                onTap: () {
                                  debugPrint(textEditingController.text);
                                  ref
                                      .watch(
                                        registrationOtpVerifyProvider.notifier,
                                      )
                                      .verify(
                                        forEmailorPhone,
                                        textEditingController.text,
                                      );
                                },
                              );
                            },
                            loading: (_) {
                              return const LoadingWidget();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
