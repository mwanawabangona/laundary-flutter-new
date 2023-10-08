import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/input_field_decorations.dart';
import 'package:laundry_customer/providers/settings_provider.dart';
import 'package:laundry_customer/screens/auth/login_screen_wrapper.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostCodeCheckScreen extends ConsumerStatefulWidget {
  const PostCodeCheckScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostCodeCheckScreenState();
}

class _PostCodeCheckScreenState extends ConsumerState<PostCodeCheckScreen> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  final TextEditingController textEditingController = TextEditingController();
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
      context.nav.pushNamedAndRemoveUntil(
        Routes.postcodesuccessScreen,
        (route) => true,
      );
      // ref
      //     .watch(
      //       addAddresProvider.notifier,
      //     )
      //     .addAddress(
      //       address: _formkey.currentState!.value,
      //     )
      //     .then((value) {
      //   setState(() {
      //     isMatchFound = false;
      //   });
      // });
    } else {
      EasyLoading.showError(
        "Service not Available in Your Area",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(settingsProvider).maybeWhen(
          orElse: () {},
          loaded: (_) {
            postCodelist = _.data?.postCode ?? [];
          },
        );
    return FormBuilder(
      key: _formkey,
      child: LoginScreenWrapper(
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
                child: Center(
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 200.h,
                      width: 200.w,
                    ),
                  ),
                ),
              ),
              AppSpacerH(40.h),
              Text(
                "Before you get started, we need to check that our services are available in your area. Please enter the first half of your postcode",
                style: AppTextDecor.osRegular14white
                    .copyWith(color: AppColors.primary, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              AppSpacerH(20.h),
              Text(
                "For example either AB1 or AB12",
                style: AppTextDecor.osRegular14white
                    .copyWith(color: AppColors.primary, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              AppSpacerH(20.h),
              FormBuilderTextField(
                controller: textEditingController,
                name: 'post_code',
                decoration: AppInputDecor.loginPageInputDecor.copyWith(
                  hintText: "AB1 or AB12 only",
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),
              AppSpacerH(20.h),
              AppTextButton(
                onTap: () {
                  final userInput = textEditingController.text
                      .toLowerCase()
                      .replaceAll(' ', '');
                  postCodeValidation(postCode: userInput);
                },
                title: "Check Availability",
                buttonColor: AppColors.primary,
                titleColor: AppColors.primary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
