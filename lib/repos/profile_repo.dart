import 'dart:io';

import 'package:dio/dio.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/models/profile_info_model/profile_info_model.dart';
import 'package:laundry_customer/offline_data/customer_detail_data.dart';
import 'package:laundry_customer/services/api_service.dart';

abstract class IProfileRepo {
  Future<ProfileInfoModel> getProfileInfo();
  Future<void> updateProfile({required Map<String, dynamic> data, File? file});
  Future<void> changePassword({
    //
    required String current_password,
    required String password,
    required String password_confirmation,
  });
}

class ProfileRepo implements IProfileRepo {
  final Dio _dio = getDio();
  @override
  Future<ProfileInfoModel> getProfileInfo() async {
    final Response reponse = await _dio.get('/customers');
    return ProfileInfoModel.fromMap(reponse.data as Map<String, dynamic>);
  }

  @override
  Future<void> updateProfile({
    required Map<String, dynamic> data,
    File? file,
  }) async {
    final ext = file?.path.split('.').last;

    if (file != null) {
      await _dio.post(
        '/users/profile-photo/update',
        data: FormData.fromMap({
          'profile_photo': await MultipartFile.fromFile(
            file.path,
            filename:
                "${DateTime.now().millisecondsSinceEpoch.toString()}.$ext",
          )
        }),
      );
    }
    await _dio.post(
      '/users/update',
      data: FormData.fromMap({
        ...data,
        'profile_photo': file != null
            ? await MultipartFile.fromFile(
                file.path,
                filename:
                    "${DateTime.now().millisecondsSinceEpoch.toString()}.$ext",
              )
            : null,
      }),
    );
  }

  @override
  Future<void> changePassword({
    required String current_password,
    required String password,
    required String password_confirmation,
  }) async {
    await _dio.post(
      '/users/change-password',
      data: FormData.fromMap({
        'current_password': current_password,
        'password': password,
        'password_confirmation': password_confirmation
      }),
    );
  }
}

class OfflineProfileRepo implements IProfileRepo {
  @override
  Future<ProfileInfoModel> getProfileInfo() async {
    await Future.delayed(apiDataDuration);
    return ProfileInfoModel.fromMap(OfflineCustomerData.userData);
  }

  @override
  Future<void> updateProfile({
    required Map<String, dynamic> data,
    File? file,
  }) async {
    await Future.delayed(apiDataDuration);
  }

  @override
  Future<void> changePassword({
    required String current_password,
    required String password,
    required String password_confirmation,
  }) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }
}
