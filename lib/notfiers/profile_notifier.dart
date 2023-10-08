import 'dart:io';

import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/models/profile_info_model/profile_info_model.dart';
import 'package:laundry_customer/repos/profile_repo.dart';
import 'package:laundry_customer/services/api_state.dart';
import 'package:laundry_customer/services/network_exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UpdateProfileNotifier extends StateNotifier<ApiState<String>> {
  UpdateProfileNotifier(this._repo) : super(const ApiState.initial());

  final IProfileRepo _repo;
  Future<void> updateProfile(Map<String, dynamic> data, File? file) async {
    state = const ApiState.loading();
    try {
      await _repo.updateProfile(data: data, file: file);
      state = const ApiState.loaded(data: 'Success');
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class ProfileInfoNotifier extends StateNotifier<ApiState<ProfileInfoModel>> {
  ProfileInfoNotifier(this._repo) : super(const ApiState.initial()) {
    getProfile();
  }

  final IProfileRepo _repo;
  Future<void> getProfile() async {
    state = const ApiState.loading();
    try {
      final ProfileInfoModel userdata = await _repo.getProfileInfo();
      final Box userBox = Hive.box(AppHSC.userBox);
      userBox.putAll(userdata.data!.customer!.user!.toMap());
      state = ApiState.loaded(
        data: userdata,
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class ChangePassNotifier extends StateNotifier<ApiState<String>> {
  ChangePassNotifier(this.repo) : super(const ApiState.initial());

  final IProfileRepo repo;

  Future<void> changePassword(
    String currentPassword,
    String password,
    String passwordConfirmation,
  ) async {
    state = const ApiState.loading();
    try {
      await repo.changePassword(
        current_password: currentPassword,
        password: password,
        password_confirmation: passwordConfirmation,
      );
      state = const ApiState.loaded(
        data: 'Success',
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}
