import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/input_field_decorations.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/models/addres_list_model/address.dart';
import 'package:laundry_customer/providers/address_provider.dart';
import 'package:laundry_customer/providers/settings_provider.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:laundry_customer/widgets/screen_wrapper.dart';

class AddOrEditAddress extends ConsumerStatefulWidget {
  const AddOrEditAddress({
    super.key,
    this.address,
  });
  final Address? address;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddOrEditAddressState();
}

class _AddOrEditAddressState extends ConsumerState<AddOrEditAddress> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  List postCodelist = [];
  bool isMatchFound = false;

  void postCodeValidation({required String postCode}) {
    isMatchFound = false;
    for (final e in postCodelist) {
      final code = e.toString().toLowerCase().replaceAll(' ', '');
      final int lenghtToCompare = code.length;

      if (code == postCode) {
        setState(() {
          isMatchFound = true;
        });
      } else if (postCode.length > 3 &&
          code.substring(
                0,
                lenghtToCompare,
              ) ==
              postCode.substring(
                0,
                lenghtToCompare,
              )) {
        setState(() {
          isMatchFound = true;
        });
      }
    }
    if (isMatchFound) {
      ref
          .watch(
            addAddresProvider.notifier,
          )
          .addAddress(
            address: _formkey.currentState!.value,
          )
          .then((value) {
        setState(() {
          isMatchFound = false;
        });
      });
    } else {
      EasyLoading.showError(
        "Service not Available in Your Area",
      );
    }
  }

  String validationError({required String fieldName}) {
    return '$fieldName field cannot be empty!';
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(addAddresProvider);
    ref.watch(updateAddresProvider);
    ref.watch(settingsProvider).maybeWhen(
          orElse: () {},
          loaded: (_) {
            postCodelist = _.data?.postCode ?? [];
          },
        );

    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Container(
        height: 812.h,
        width: 375.w,
        color: AppColors.grayBG,
        child: Column(
          children: [
            Container(
              color: AppColors.primary,
              height: 108.h,
              width: 375.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: Column(
                  children: [
                    AppSpacerH(44.h),
                    AppNavbar(
                      backgroundColor: AppColors.primary,
                      titleColor: AppColors.white,
                      title: widget.address == null
                          ? S.of(context).adadres
                          : S.of(context).updtadrs,
                      onBack: () {
                        context.nav.pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _formkey,
                  initialValue:
                      widget.address != null ? widget.address!.toMap() : {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        AppSpacerH(20.h),
                        FormBuilderTextField(
                          cursorColor: AppColors.primary,
                          name: 'address_name',
                          decoration:
                              AppInputDecor.loginPageInputDecor.copyWith(
                            hintText: "University Name/Area Name",
                            prefixIcon: const Icon(Icons.home),
                          ),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                errorText: validationError(fieldName: 'House'),
                              )
                            ],
                          ),
                        ),
                        AppSpacerH(20.h),
                        FormBuilderTextField(
                          cursorColor: AppColors.primary,
                          name: 'address_line',
                          decoration:
                              AppInputDecor.loginPageInputDecor.copyWith(
                            hintText: "Hostel/Boarding House/House",
                          ),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                errorText: validationError(
                                  fieldName: 'Address Line 1',
                                ),
                              )
                            ],
                          ),
                        ),
                        AppSpacerH(20.h),
                        // FormBuilderTextField(
                        //   cursorColor: AppColors.primary,
                        //   name: "address_line2",
                        //   decoration:
                        //       AppInputDecor.loginPageInputDecor.copyWith(
                        //     hintText: "Room Number/Flat/House Number",
                        //   ),
                        // ),
                    
                        FormBuilderTextField(
                          cursorColor: AppColors.primary,
                          name: 'area',
                          decoration:
                              AppInputDecor.loginPageInputDecor.copyWith(
                            hintText: "Room Number/Flat/House Number",
                          ),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                errorText: validationError(
                                  fieldName: 'Area',
                                ),
                              )
                            ],
                          ),
                        ),
                        AppSpacerH(20.h),
                        FormBuilderTextField(
                          cursorColor: AppColors.primary,
                          name: 'post_code',
                          decoration:
                              AppInputDecor.loginPageInputDecor.copyWith(
                            hintText: "Phone Number",
                          ),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                errorText: validationError(
                                  fieldName: 'Post Code',
                                ),
                              )
                            ],
                          ),
                        ),
                        // AppSpacerH(20.h),
                        // SizedBox(
                        //   width: 335.w,
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         child: FormBuilderTextField(
                        //           cursorColor: AppColors.primary,
                        //           name: 'flat_no',
                        //           decoration: AppInputDecor.loginPageInputDecor
                        //               .copyWith(
                        //             hintText: S.of(context).flat,
                        //           ),
                        //         ),
                        //       ),
                        //       AppSpacerW(5.w),
                        //       Expanded(
                        //         child: FormBuilderTextField(
                        //           cursorColor: AppColors.primary,
                        //           name: 'house_no',
                        //           decoration: AppInputDecor.loginPageInputDecor
                        //               .copyWith(
                        //             hintText: S.of(context).houseno,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // AppSpacerH(20.h),
                        // FormBuilderTextField(
                        //   cursorColor: AppColors.primary,
                        //   onTap: () {},
                        //   validator: FormBuilderValidators.compose(
                        //     [FormBuilderValidators.required()],
                        //   ),
                        //   name: 'post_code',
                        //   decoration:
                        //       AppInputDecor.loginPageInputDecor.copyWith(
                        //     hintText: S.of(context).postcode,
                        //   ),
                        // ),

                        AppSpacerH(40.h),
                        if (widget.address == null)
                          SizedBox(
                            height: 50.h,
                            child: ref.watch(addAddresProvider).map(
                                  initial: (_) => AppTextButton(
                                    title: S.of(context).adadres,
                                    onTap: () {
                                      if (_formkey.currentState!
                                          .saveAndValidate()) {
                                        // final postCodeText = _formkey
                                        //     .currentState!.value['post_code'];
                                        // final postCode = postCodeText
                                        //     .toString()
                                        //     .toLowerCase()
                                        //     .replaceAll(' ', '');

                                        // postCodeValidation(postCode: postCode);
                                        ref
                                            .watch(
                                              addAddresProvider.notifier,
                                            )
                                            .addAddress(
                                              address:
                                                  _formkey.currentState!.value,
                                            );
                                      }
                                    },
                                  ),
                                  loading: (_) => const LoadingWidget(),
                                  loaded: (_) {
                                    Future.delayed(transissionDuration)
                                        .then((value) {
                                      ref.refresh(updateAddresProvider);
                                      ref.refresh(addresListProvider);
                                      ref.refresh(addAddresProvider);
                                      Future.delayed(transissionDuration)
                                          .then((value) {
                                        context.nav.pop();
                                      });
                                    });
                                    return const MessageTextWidget(
                                      msg: 'Success',
                                    );
                                  },
                                  error: (_) {
                                    Future.delayed(transissionDuration)
                                        .then((_) {
                                      ref.refresh(addAddresProvider);
                                      ref.refresh(updateAddresProvider);
                                      ref.refresh(addresListProvider);
                                    });
                                    return ErrorTextWidget(
                                      error: _.error,
                                    );
                                  },
                                ),
                          )
                        else
                          SizedBox(
                            height: 50.h,
                            child: ref.watch(updateAddresProvider).map(
                                  initial: (_) => AppTextButton(
                                    title: S.of(context).updtadrs,
                                    onTap: () {
                                      if (_formkey.currentState!
                                          .saveAndValidate()) {
                                        ref
                                            .watch(
                                              updateAddresProvider.notifier,
                                            )
                                            .updateAddress(
                                              address:
                                                  _formkey.currentState!.value,
                                              addressID: widget.address!.id!
                                                  .toString(),
                                            );
                                      }
                                    },
                                  ),
                                  loading: (_) => const LoadingWidget(),
                                  loaded: (_) {
                                    Future.delayed(transissionDuration)
                                        .then((value) {
                                      ref.refresh(updateAddresProvider);
                                      ref.refresh(addresListProvider);
                                      ref.refresh(addAddresProvider);
                                      Future.delayed(transissionDuration)
                                          .then((value) {
                                        context.nav.pop();
                                      });
                                    });
                                    return const MessageTextWidget(
                                      msg: 'Success',
                                    );
                                  },
                                  error: (_) {
                                    Future.delayed(transissionDuration)
                                        .then((_) {
                                      ref.refresh(addAddresProvider);
                                      ref.refresh(updateAddresProvider);
                                      ref.refresh(addresListProvider);
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
      ),
    );
  }
}
