import 'package:laundry_customer/models/notifications_model/notifications_model.dart';
import 'package:laundry_customer/repos/notification_repo.dart';
import 'package:laundry_customer/services/api_state.dart';
import 'package:laundry_customer/services/network_exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsNotifier
    extends StateNotifier<ApiState<NotificationsModel>> {
  NotificationsNotifier(this.repo) : super(const ApiState.initial()) {
    getAllNotifications();
  }

  final INotificationRepo repo;

  Future<void> getAllNotifications() async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(
        data: await repo.getAllNotifications(),
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}
