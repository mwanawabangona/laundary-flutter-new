import 'package:flutter/material.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';

class AppInputDecor {
  AppInputDecor._(); // This class is not meant to be instantiated.
  static InputDecoration loginPageInputDecor = InputDecoration(
    isDense: false,
    contentPadding: const EdgeInsets.all(15),
    hintStyle: const TextStyle(color: AppColors.gray, fontSize: 16),
    filled: true,
    fillColor: AppColors.white,
    errorStyle: AppTextDecor.formErrorTextStyle,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: const BorderSide(color: AppColors.gray),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: const BorderSide(color: AppColors.gray),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: const BorderSide(color: AppColors.gray),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: const BorderSide(color: AppColors.red),
    ),
  );
}
