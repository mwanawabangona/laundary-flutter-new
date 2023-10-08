import 'package:laundry_customer/models/notifications_model/notifications_model.dart';
import 'package:laundry_customer/notfiers/notification_notifiers.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/repos/notification_repo.dart';
import 'package:laundry_customer/services/api_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationRepoProvider = Provider<INotificationRepo>((ref) {
  return ref.watch(isAppLive) ? NotificationsRepo() : NotificationsRepo();
});

//
//Login
final notificationListProvider =
    StateNotifierProvider<NotificationsNotifier, ApiState<NotificationsModel>>(
        (ref) {
  return NotificationsNotifier(
    ref.watch(notificationRepoProvider),
  );
});
