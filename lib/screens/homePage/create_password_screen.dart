import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/input_field_decorations.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/providers/profile_update_provider.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';

class CreatePasswordScreen extends ConsumerStatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends ConsumerState<CreatePasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool createObsecureText = true;
  bool confirmObsecureText = true;
  bool newObsecureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grayBG,
      height: 812.h,
      width: 375.w,
      child: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              Container(
                color: AppColors.primary,
                width: 375.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: Column(
                    children: [
                      AppSpacerH(44.h),
                      AppNavbar(
                        backgroundColor: AppColors.primary,
                        titleColor: AppColors.white,
                        title: "Change Password",
                        onBack: () {
                          context.nav.pop();
                        },
                      ),
                      AppSpacerH(20.h)
                    ],
                  ),
                ),
              ),
              AppSpacerH(30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'current_password',
                      obscureText: createObsecureText,
                      decoration: AppInputDecor.loginPageInputDecor.copyWith(
                        labelText: "Current Password",
                        labelStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        // border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.gold))
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              createObsecureText = !createObsecureText;
                            });
                          },
                          child: Icon(
                            createObsecureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()],
                      ),
                    ),
                    AppSpacerH(20.h),
                    FormBuilderTextField(
                      name: 'password',
                      obscureText: newObsecureText,
                      decoration: AppInputDecor.loginPageInputDecor.copyWith(
                        labelText: "New Password",
                        labelStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        // border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.gold))
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              newObsecureText = !newObsecureText;
                            });
                          },
                          child: Icon(
                            newObsecureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()],
                      ),
                    ),
                    AppSpacerH(20.h),
                    FormBuilderTextField(
                      name: 'password_confirmation',
                      obscureText: confirmObsecureText,
                      decoration: AppInputDecor.loginPageInputDecor.copyWith(
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        // border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.gold))
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              confirmObsecureText = !confirmObsecureText;
                            });
                          },
                          child: Icon(
                            confirmObsecureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()],
                      ),
                    ),
                    AppSpacerH(40.h),
                    // AppTextButton(
                    //   buttonColor: AppColors.white,
                    //   titleColor: Colors.black,
                    //   title: "Skip, I will Set Later",
                    //   onTap: () {},
                    // ),
                    ref.watch(changePassProvider).map(
                      loading: (_) {
                        return const LoadingWidget();
                      },
                      error: (_) {
                        Future.delayed(transissionDuration).then((value) {
                          ref.refresh(changePassProvider);
                        });
                        return ErrorTextWidget(error: _.error);
                      },
                      initial: (_) {
                        return AppTextButton(
                          buttonColor: AppColors.primary,
                          titleColor: AppColors.white,
                          title: "Change Password",
                          onTap: () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              final formData = _formKey.currentState!.fields;
                              ref
                                  .watch(changePassProvider.notifier)
                                  .changePassword(
                                    formData["current_password"]!.value
                                        as String,
                                    formData["password"]!.value as String,
                                    formData["password_confirmation"]!.value
                                        as String,
                                  );
                            }
                          },
                        );
                      },
                      loaded: (_) {
                        Future.delayed(transissionDuration).then((value) {
                          ref.refresh(
                            changePassProvider,
                          ); //Refresh This so That App Doesn't Auto Login

                          Future.delayed(buildDuration).then((value) {
                            context.nav.pop();
                          });
                        });
                        return const MessageTextWidget(
                          msg: 'Success',
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
