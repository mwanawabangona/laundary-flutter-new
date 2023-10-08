import 'package:laundry_customer/models/master_model/master_model.dart';
import 'package:laundry_customer/models/terms_of_service_model/terms_of_service_model.dart';
import 'package:laundry_customer/notfiers/settings_notfier.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/repos/settings_repo.dart';
import 'package:laundry_customer/services/api_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsRepoProvider = Provider<ISettingsRepo>((ref) {
  return ref.watch(isAppLive) ? SettingsRepo() : OfflineSettingsRepo();
});

//
//
//
final settingsProvider =
    StateNotifierProvider<MasterDataNotifier, ApiState<MasterModel>>((ref) {
  return MasterDataNotifier(ref.watch(settingsRepoProvider));
});

//
//
//
final tosProvider = StateNotifierProvider<TermsOfServiceNotifier,
    ApiState<TermsOfServiceModel>>((ref) {
  return TermsOfServiceNotifier(ref.watch(settingsRepoProvider));
});
//
//
//
final privacyProvider =
    StateNotifierProvider<PrivacyPolicyNotifier, ApiState<TermsOfServiceModel>>(
        (ref) {
  return PrivacyPolicyNotifier(ref.watch(settingsRepoProvider));
});
//
//
//
final aboutUsProvider =
    StateNotifierProvider<AboutUsNotifier, ApiState<TermsOfServiceModel>>(
        (ref) {
  return AboutUsNotifier(ref.watch(settingsRepoProvider));
});
