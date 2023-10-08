import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/constants/input_field_decorations.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/providers/profile_update_provider.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:laundry_customer/widgets/screen_wrapper.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();

  File? image;

  @override
  Widget build(BuildContext context) {
    ref.watch(profileUpdateProvider);
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: ValueListenableBuilder(
        valueListenable: Hive.box(AppHSC.userBox).listenable(),
        builder: (context, Box userBox, Widget? child) {
          final Map<String, dynamic> processedData = {};
          final Map unprocessedData = userBox.toMap();

          unprocessedData.forEach((key, value) {
            processedData[key.toString()] = value;
          });
          return ValueListenableBuilder(
            valueListenable: Hive.box(AppHSC.authBox).listenable(),
            builder: (context, Box authBox, Widget? child) {
              return Container(
                height: 812.h,
                width: 375.w,
                color: AppColors.grayBG,
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
                              title: S.of(context).edtprfl,
                              onBack: () {
                                context.nav.pop();
                              },
                            ),
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
                              child: Container(
                                height: 100.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: (image != null)
                                          ? CircleAvatar(
                                              backgroundColor: AppColors.white,
                                              radius: 50,
                                              backgroundImage:
                                                  FileImage(image!),

                                              //Text
                                            )
                                          : CircleAvatar(
                                              backgroundColor: AppColors.white,
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                userBox.get(
                                                  'profile_photo_path',
                                                )! as String,
                                              ),
                                              //Text
                                            ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        height: 26.h,
                                        width: 26.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(12.w),
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
                            ),
                            AppSpacerH(10.h)
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: FormBuilder(
                          key: _formkey,
                          initialValue: processedData,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: [
                                AppSpacerH(20.h),
                                FormBuilderTextField(
                                  validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required()],
                                  ),
                                  name: 'first_name',
                                  decoration: AppInputDecor.loginPageInputDecor
                                      .copyWith(
                                    hintText: S.of(context).frstnm,
                                  ),
                                ),
                                // AppSpacerH(20.h),
                                // FormBuilderTextField(
                                //   name: 'last_name',
                                //   decoration: AppInputDecor.loginPageInputDecor
                                //       .copyWith(
                                //     hintText: 'Last Name',
                                //   ),
                                // ),
                                // AppSpacerH(20.h),
                                // FormBuilderDropdown(
                                //   name: 'gender',
                                //   decoration: AppInputDecor.loginPageInputDecor
                                //       .copyWith(
                                //     hintText: S.of(context).gndr,
                                //   ),
                                //   items: ['Male', 'Female']
                                //       .map(
                                //         (e) => DropdownMenuItem(
                                //           value: e,
                                //           child: Text(e),
                                //         ),
                                //       )
                                //       .toList(),
                                // ),
                                AppSpacerH(20.h),
                                FormBuilderTextField(
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.email()
                                  ]),
                                  name: 'email',
                                  decoration: AppInputDecor.loginPageInputDecor
                                      .copyWith(
                                    hintText: S.of(context).rmladrs,
                                  ),
                                ),
                                AppSpacerH(20.h),
                                FormBuilderTextField(
                                  name: 'mobile',
                                  decoration: AppInputDecor.loginPageInputDecor
                                      .copyWith(
                                    hintText: S.of(context).mbl,
                                  ),
                                  readOnly: true,
                                ),
                                AppSpacerH(20.h),
                                FormBuilderTextField(
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.maxLength(12),
                                  ]),
                                  name: 'alternative_phone',
                                  decoration: AppInputDecor.loginPageInputDecor
                                      .copyWith(
                                    hintText: S.of(context).altrntvphn,
                                  ),
                                ),
                                AppSpacerH(50.h),

                                AppTextButton(
                                  onTap: () {
                                    context.nav
                                        .pushNamed(Routes.changePasswordScreen);
                                  },
                                  title: "Change Password",
                                  buttonColor: AppColors.primary,
                                  titleColor: AppColors.white,
                                ),
                                AppSpacerH(20.h),
                                SizedBox(
                                  height: 50.h,
                                  child: ref.watch(profileUpdateProvider).map(
                                        initial: (_) => AppTextButton(
                                          title: S.of(context).updtaprl,
                                          onTap: () {
                                            if (_formkey.currentState!
                                                .saveAndValidate()) {
                                              ref
                                                  .watch(
                                                    profileUpdateProvider
                                                        .notifier,
                                                  )
                                                  .updateProfile(
                                                    _formkey
                                                        .currentState!.value,
                                                    image,
                                                  );
                                            }
                                          },
                                        ),
                                        loading: (_) => const LoadingWidget(),
                                        loaded: (_) {
                                          Future.delayed(transissionDuration)
                                              .then(
                                            (value) {
                                              ref.refresh(
                                                profileUpdateProvider,
                                              );
                                              ref.refresh(profileInfoProvider);
                                              Future.delayed(buildDuration)
                                                  .then((value) {
                                                context.nav.pop();
                                              });
                                            },
                                          );
                                          return MessageTextWidget(
                                            msg: S.of(context).scs,
                                          );
                                        },
                                        error: (_) {
                                          Future.delayed(transissionDuration)
                                              .then((_) {
                                            ref.refresh(profileUpdateProvider);
                                          });
                                          return ErrorTextWidget(
                                            error: _.error,
                                          );
                                        },
                                      ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
