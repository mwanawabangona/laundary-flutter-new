import 'package:laundry_customer/models/profile_info_model/profile_info_model.dart';
import 'package:laundry_customer/notfiers/profile_notifier.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/repos/profile_repo.dart';
import 'package:laundry_customer/services/api_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepoProvider = Provider<IProfileRepo>(
  (ref) => ref.watch(isAppLive) ? ProfileRepo() : OfflineProfileRepo(),
);
final profileUpdateProvider =
    StateNotifierProvider<UpdateProfileNotifier, ApiState<String>>((ref) {
  return UpdateProfileNotifier(ref.watch(profileRepoProvider));
});
final profileInfoProvider =
    StateNotifierProvider<ProfileInfoNotifier, ApiState<ProfileInfoModel>>(
        (ref) {
  return ProfileInfoNotifier(ref.watch(profileRepoProvider));
});

final changePassProvider =
    StateNotifierProvider<ChangePassNotifier, ApiState<String>>((ref) {
  return ChangePassNotifier(ref.watch(profileRepoProvider));
});
