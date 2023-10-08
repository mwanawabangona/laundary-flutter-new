import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/global_functions.dart';
import 'package:laundry_customer/models/addres_list_model/address.dart';
import 'package:laundry_customer/models/all_orders_model/order.dart';
import 'package:laundry_customer/providers/order_providers.dart';
import 'package:laundry_customer/screens/order/my_order_home_tile.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/global_functions.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

class MyOrdersSignedIn extends ConsumerWidget {
  const MyOrdersSignedIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(allOrdersProvider);

    return SizedBox(
      height: 606.h,
      width: 335.w,
      child: ref.watch(allOrdersProvider).map(
            initial: (_) => const SizedBox(),
            loading: (_) => const LoadingWidget(),
            loaded: (_) {
              if (_.data.data!.orders!.isEmpty) {
                return MessageTextWidget(
                  msg: S.of(context).noordrfnd,
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _.data.data!.orders!.length +
                      1, // Add 1 to account for the additional padding
                  itemBuilder: (context, index) {
                    if (index < _.data.data!.orders!.length) {
                      final Order data = _.data.data!.orders![index];
                      return OrderTile(data: data);
                    } else {
                      // Add the desired padding widget after the last index
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 140.0),
                        child: SizedBox(), // Placeholder widget
                      );
                    }
                  },
                );
              }
            },
            error: (_) => ErrorTextWidget(error: _.error),
          ),
    );
  }
}

class OrderTile extends StatelessWidget {
  OrderTile({
    super.key,
    required this.data,
  });

  final Order data;
  final Box settingsBox = Hive.box(AppHSC.appSettingsBox);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.nav.pushNamed(
          Routes.orderDetails,
          arguments: DetailsArg(
            orderId: data.id.toString(),
            orderStatus: data.orderStatus ?? '',
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Container(
          // height: 219.h,
          width: 335.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.w),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 15.h,
          ),
          child: Column(
            children: [
              Table(
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          S.of(context).ordrid,
                          style: AppTextDecor.osBold14black,
                          textAlign: Hive.box(AppHSC.appSettingsBox)
                                      .get(AppHSC.appLocal)
                                      .toString() ==
                                  "ar"
                              ? TextAlign.right
                              : TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          '#${data.orderCode}',
                          style: AppTextDecor.osBold14black,
                          textAlign: Hive.box(AppHSC.appSettingsBox)
                                      .get(AppHSC.appLocal)
                                      .toString() ==
                                  "ar"
                              ? TextAlign.right
                              : TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          S.of(context).date,
                          style: AppTextDecor.osRegular14black,
                          textAlign: Hive.box(AppHSC.appSettingsBox)
                                      .get(AppHSC.appLocal)
                                      .toString() ==
                                  "ar"
                              ? TextAlign.right
                              : TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          DateFormat("dd MMM, yyyy").format(
                            DateTime.parse(data.orderedAt!.split(" ").first),
                          ),
                          style: AppTextDecor.osRegular14black,
                          textAlign: Hive.box(AppHSC.appSettingsBox)
                                      .get(AppHSC.appLocal)
                                      .toString() ==
                                  "ar"
                              ? TextAlign.right
                              : TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  // AppGFunctions.tableTextRow(
                  //   title: 'Pick Up At',
                  //   data: '${data.pickDate} - ${data.pickHour}',
                  // ),
                  // AppGFunctions.tableTextRow(
                  //   title: 'Delivery At',
                  //   data: '${data.deliveryDate} - ${data.deliveryHour}',
                  // ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          S.of(context).dlvryoptn,
                          style: AppTextDecor.osRegular14black,
                          textAlign: Hive.box(AppHSC.appSettingsBox)
                                      .get(AppHSC.appLocal)
                                      .toString() ==
                                  "ar"
                              ? TextAlign.right
                              : TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          data.paymentType ?? '',
                          // getLng(
                          //   en: data.paymentType,
                          //   changeLang: data.paymentTypebn,
                          // ),
                          style: AppTextDecor.osRegular14black,
                          textAlign: Hive.box(AppHSC.appSettingsBox)
                                      .get(AppHSC.appLocal)
                                      .toString() ==
                                  "ar"
                              ? TextAlign.right
                              : TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          S.of(context).pyblamnt,
                          style: AppTextDecor.osRegular14black,
                          textAlign: Hive.box(AppHSC.appSettingsBox)
                                      .get(AppHSC.appLocal)
                                      .toString() ==
                                  "ar"
                              ? TextAlign.right
                              : TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          '${settingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(data.totalAmount!)}',
                          style: AppTextDecor.osRegular14black,
                          textAlign: Hive.box(AppHSC.appSettingsBox)
                                      .get(AppHSC.appLocal)
                                      .toString() ==
                                  "ar"
                              ? TextAlign.right
                              : TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          S.of(context).status,
                          style: AppTextDecor.osRegular14black,
                          textAlign: Hive.box(AppHSC.appSettingsBox)
                                      .get(AppHSC.appLocal)
                                      .toString() ==
                                  "ar"
                              ? TextAlign.right
                              : TextAlign.left,
                        ),
                      ),
                      AppTextButton(
                        title: getLng(
                          en: data.orderStatus,
                          changeLang: data.orderStatusbn.toString(),
                        ),
                        height: 25.h,
                        width: 122.w,
                        buttonColor: getOrderStatusColor(),
                        titleColor: AppColors.white,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          S.of(context).pymntstats,
                          style: AppTextDecor.osRegular14black,
                          textAlign: Hive.box(AppHSC.appSettingsBox)
                                      .get(AppHSC.appLocal)
                                      .toString() ==
                                  "ar"
                              ? TextAlign.right
                              : TextAlign.left,
                        ),
                      ),
                      Text(
                        getLng(
                          en: data.paymentStatus,
                          changeLang: data.paymentStatusbn,
                        ),
                        style: data.paymentStatus?.toLowerCase() == 'paid'
                            ? AppTextDecor.osBold14gold
                            : AppTextDecor.osBold14red,
                        textAlign: Hive.box(AppHSC.appSettingsBox)
                                    .get(AppHSC.appLocal)
                                    .toString() ==
                                "ar"
                            ? TextAlign.right
                            : TextAlign.right,
                      ),
                    ],
                  ),
                ],
              ),
              AppSpacerH(10.h),
              SizedBox(
                height: 5.h,
                child: Divider(
                  color: AppColors.gray.withOpacity(0.4),
                  thickness: 3,
                ),
              ),
              AppSpacerH(10.h),
              SizedBox(
                height: 32.h,
                width: 335.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 18.h,
                    ),
                    Expanded(
                      child: Text(
                        AppGFunctions.processAdAddess(
                          Address.fromMap(data.address!.toMap()),
                        ),
                        style: AppTextDecor.osRegular12black,
                      ),
                    ),
                    Icon(
                      Hive.box(AppHSC.appSettingsBox)
                                  .get(AppHSC.appLocal)
                                  .toString() ==
                              "ar"
                          ? Icons.keyboard_arrow_left
                          : Icons.keyboard_arrow_right,
                      size: 18.h,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color getOrderStatusColor() {
    if (data.orderStatus!.toLowerCase() == 'pending') {
      return const Color.fromARGB(255, 75, 224, 172);
    } else if (data.orderStatus!.replaceAll(' ', '').toLowerCase() ==
        'pickedYourOrder'.toLowerCase()) {
      return const Color(0xFF3AD0FF);
    } else {
      return const Color(0xFF3AD0FF);
    }
  }
}
