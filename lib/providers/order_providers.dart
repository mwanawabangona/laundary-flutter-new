import 'package:laundry_customer/constants/app_string_const.dart';
import 'package:laundry_customer/models/add_order_model/add_order_model.dart';
import 'package:laundry_customer/models/all_orders_model/all_orders_model.dart';
import 'package:laundry_customer/models/coupon_response_model/coupon_response_model.dart';
import 'package:laundry_customer/models/order_details_model/order_details_model.dart';
import 'package:laundry_customer/models/schedules_model/schedules_model.dart';
import 'package:laundry_customer/notfiers/order_notifier.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/repos/order_repo.dart';
import 'package:laundry_customer/services/api_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderRepoProvider = Provider<IOrderRepo>((ref) {
  return ref.watch(isAppLive) ? OrderRepo() : OfflineOrderRepo();
});

final orderFilterProvider = StateProvider<String>((ref) {
  return '';
});

final allOrdersProvider = StateNotifierProvider.autoDispose<AllOrdersNotifier,
    ApiState<AllOrdersModel>>((ref) {
  return AllOrdersNotifier(
    ref.watch(orderRepoProvider),
    ref.watch(orderFilterProvider),
  );
});
final orderDetailsProvider = StateNotifierProvider.autoDispose
    .family<OrderDetailsNotifier, ApiState<OrderDetailsModel>, String>(
        (ref, id) {
  return OrderDetailsNotifier(
    ref.watch(orderRepoProvider),
    id,
  );
});

final placeOrdersProvider = StateNotifierProvider.autoDispose<
    PlaceOrderNotifier, ApiState<AddOrderModel>>((ref) {
  return PlaceOrderNotifier(
    ref.watch(orderRepoProvider),
  );
});

final updateOrderProvider = StateNotifierProvider.autoDispose<
    UpdateOrderNotifier, ApiState<AddOrderModel>>((ref) {
  return UpdateOrderNotifier(ref.watch(orderRepoProvider));
});

final pickUpScheduleProvider = StateNotifierProvider.autoDispose<
    PickUpScheduleNotifier, ApiState<SchedulesModel>>((ref) {
  final DateTime date =
      ref.watch(dateProvider(AppStrConst.pickup)) ?? DateTime.now();
  return PickUpScheduleNotifier(
    ref.watch(orderRepoProvider),
    date,
  );
});

final deliveryScheduleProvider = StateNotifierProvider.autoDispose<
    DeliveryScheduleNotifier, ApiState<SchedulesModel>>((ref) {
  final DateTime date =
      ref.watch(dateProvider(AppStrConst.delivery)) ?? DateTime.now();
  return DeliveryScheduleNotifier(
    ref.watch(orderRepoProvider),
    date,
  );
});

final couponProvider =
    StateNotifierProvider<CouponNotifier, ApiState<CouponResponseModel>>((ref) {
  return CouponNotifier(
    ref.watch(orderRepoProvider),
  );
});

final discountAmountProvider = StateProvider<double>((ref) {
  return 0;
});
final orderProcessingProvider = StateProvider<bool>((ref) {
  return false;
});
