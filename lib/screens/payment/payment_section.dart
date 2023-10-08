import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:laundry_customer/constants/app_box_decoration.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/global_functions.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/models/hive_cart_item_model.dart';
import 'package:laundry_customer/models/order_place_model/order_place_model.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/providers/order_providers.dart';
import 'package:laundry_customer/providers/settings_provider.dart';
import 'package:laundry_customer/screens/payment/payment_controller.dart';
import 'package:laundry_customer/screens/payment/payment_screen.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

// ignore: must_be_immutable
class PaymentSection extends ConsumerStatefulWidget {
  const PaymentSection({
    super.key,
    required this.instruction,
    required this.selectedPaymentType,
  });
  final TextEditingController instruction;
  final PaymentType selectedPaymentType;

  @override
  ConsumerState<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends ConsumerState<PaymentSection> {
  final Box appSettingsBox = Hive.box(AppHSC.appSettingsBox);

  int? couponID;

  bool isMakingPayment = false;

  bool isPaid = false;

  @override
  Widget build(BuildContext context) {
    ref.watch(couponProvider).maybeWhen(
          orElse: () {},
          loaded: (_) {
            couponID = _.data?.coupon?.id;
          },
        );
    late int? minimum;
    double? dlvrychrg;
    double? free;
    ref.watch(settingsProvider).whenOrNull(
      loaded: (data) {
        minimum = data.data!.minimumCost;
        dlvrychrg = data.data!.deliveryCost!.toDouble();
        free = data.data!.feeCost!.toDouble();
      },
    );
    return ValueListenableBuilder(
      valueListenable: Hive.box(AppHSC.cartBox).listenable(),
      builder: (
        BuildContext context,
        Box cartBox,
        Widget? child,
      ) {
        final List<CarItemHiveModel> cartItems = [];
        for (var i = 0; i < cartBox.length; i++) {
          final Map<String, dynamic> processedData = {};
          final Map<dynamic, dynamic> unprocessedData =
              cartBox.getAt(i) as Map<dynamic, dynamic>;

          unprocessedData.forEach((key, value) {
            processedData[key.toString()] = value;
          });

          cartItems.add(
            CarItemHiveModel.fromMap(
              processedData,
            ),
          );
        }
        return Container(
          width: 375.w,
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 25.h,
          ),
          decoration: AppBoxDecorations.pageCommonCard.copyWith(),
          child: SizedBox(
            // height: 70.h,
            child: Consumer(
              builder: (context, ref, child) {
                return ref.watch(placeOrdersProvider).map(
                      initial: (_) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.of(context).ttlpybl,
                                style: AppTextDecor.osSemiBold18black,
                              ),
                              if (AppGFunctions.calculateTotal(
                                    cartItems,
                                  ).toInt() <
                                  free!) ...[
                                Text(
                                  '${appSettingsBox.get('currency') ?? '\$'}${(AppGFunctions.calculateTotal(cartItems) + dlvrychrg! - ref.watch(discountAmountProvider)).toStringAsFixed(2)}',
                                  style: AppTextDecor.osBold14black,
                                ),
                              ] else ...[
                                Text(
                                  '${appSettingsBox.get('currency') ?? '\$'}${(AppGFunctions.calculateTotal(cartItems) - ref.watch(discountAmountProvider)).toStringAsFixed(2)}',
                                  style: AppTextDecor.osSemiBold18black,
                                ),
                              ],
                              // Text(
                              //   '${appSettingsBox.get('currency') ?? '\$'}${(calculateTotal(cartItems) + dlvrychrg! - ref.watch(discountAmountProvider)).toStringAsFixed(2)}',
                              //   style: AppTextDecor.osSemiBold18black,
                              // ),
                            ],
                          ),
                          if (isMakingPayment)
                            const Center(
                              child: CircularProgressIndicator(),
                            )
                          else
                            AppTextButton(
                              title: S.of(context).pynw,
                              onTap: () async {
                                /*
                                      Order Placement Data Validation and Logic Processed Here
                                      */
                                final DateFormat formatter = DateFormat(
                                  'yyyy-MM-dd',
                                );
                                final isOrderProcessing =
                                    ref.watch(orderProcessingProvider);

                                if (!isOrderProcessing) {
                                  ref
                                      .watch(
                                        orderProcessingProvider.notifier,
                                      )
                                      .state = true;
                                  final pickUp = ref.watch(
                                    scheduleProvider('Pick Up'),
                                  );
                                  final delivery = ref.watch(
                                    scheduleProvider(
                                      'Delivery',
                                    ),
                                  );
                                  final address = ref.watch(
                                    addressIDProvider,
                                  );

                                  //Cheks All Reguired Data Is AvailAble
                                  if (pickUp != null &&
                                      delivery != null &&
                                      address != '' &&
                                      cartItems.isNotEmpty) {
                                    //Has All Data

                                    await ref
                                        .watch(
                                          placeOrdersProvider.notifier,
                                        )
                                        .addOrder(
                                          OrderPlaceModel(
                                            address_id: address,
                                            pick_date:
                                                "${pickUp.dateTime.year}-${pickUp.dateTime.month}-${pickUp.dateTime.day}",
                                            pick_hour:
                                                pickUp.schedule.hour.toString(),
                                            delivery_date:
                                                "${delivery.dateTime.year}-${delivery.dateTime.month}-${delivery.dateTime.day}",
                                            delivery_hour: delivery
                                                .schedule.hour
                                                .toString(),
                                            coupon_id:
                                                couponID?.toString() ?? '',
                                            instruction:
                                                widget.instruction.text,
                                            products: cartItems
                                                .map(
                                                  (e) => OrderProductModel(
                                                    id: e.productsId.toString(),
                                                    quantity: e.productsQTY
                                                        .toString(),
                                                    subid: e.subProduct != null
                                                        ? e.subProduct!.id
                                                            .toString()
                                                        : null,
                                                  ),
                                                )
                                                .toList(),
                                            additional_service_id: [],
                                          ),
                                        );
                                  } else {
                                    //Missing Data
                                    EasyLoading.showError(
                                      S.of(context).plsslctalflds,
                                    );
                                  }
                                  ref
                                      .watch(orderProcessingProvider.notifier)
                                      .state = false;
                                } else {
                                  EasyLoading.showError(
                                    S.of(context).wrprcsngprvsdlvry,
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                      loading: (_) => const LoadingWidget(),
                      loaded: (_) {
                        final String amount = (calculateTotal(cartItems) -
                                ref.watch(
                                  discountAmountProvider,
                                ))
                            .toStringAsFixed(2);

                        Future.delayed(buildDuration).then((value) async {
                          // EasyLoading.showSuccess(
                          //   S.of(context).ordrplcd,
                          // );

                          await cartBox.clear();
                          ref.refresh(placeOrdersProvider);
                          ref.refresh(couponProvider);
                          ref.refresh(
                            discountAmountProvider,
                          );
                          ref
                              .watch(
                                dateProvider('Pick Up').notifier,
                              )
                              .state = null;
                          ref
                              .watch(
                                dateProvider('Delivery').notifier,
                              )
                              .state = null;
                          // context.nav.pushNamedAndRemoveUntil(
                          //   Routes.orderSuccessScreen,
                          //   arguments: {
                          //     'id': _.data.data!.order!.orderCode,
                          //     'amount': amount,
                          //     'couponID': couponID.toString(),
                          //     'isCOD': selectedPaymentType == PaymentType.cod
                          //   },
                          //   (route) => false,
                          // );

                          if (widget.selectedPaymentType == PaymentType.cod ||
                              isPaid) {
                            context.nav.pushNamedAndRemoveUntil(
                              Routes.orderSuccessScreen,
                              arguments: {
                                'id': _.data.data!.order!.orderCode,
                                'amount': amount,
                                'couponID': couponID.toString(),
                                'isCOD': widget.selectedPaymentType ==
                                    PaymentType.cod
                              },
                              (route) => false,
                            );
                          } else {
                            if (!isMakingPayment) {
                              isMakingPayment = true;
                              final PaymentController pay = PaymentController();

                              isPaid = await pay.makePayment(
                                amount: amount,
                                currency: 'GBP',
                                couponID: couponID.toString(),
                                orderID: _.data.data!.order!.orderCode!,
                              );

                              isMakingPayment = false;
                              setState(() {});

                              if (isPaid) {
                                context.nav.pushNamedAndRemoveUntil(
                                  Routes.orderSuccessScreen,
                                  arguments: {
                                    'id': _.data.data!.order!.orderCode,
                                    'amount': amount,
                                    'couponID': couponID.toString(),
                                    'isCOD': widget.selectedPaymentType ==
                                        PaymentType.cod,
                                    "isPaidOnline": true,
                                  },
                                  (route) => false,
                                );
                              } else {
                                context.nav.pushNamedAndRemoveUntil(
                                  Routes.orderSuccessScreen,
                                  arguments: {
                                    'id': _.data.data!.order!.orderCode,
                                    'amount': amount,
                                    'couponID': couponID.toString(),
                                    'isCOD': widget.selectedPaymentType ==
                                        PaymentType.cod,
                                    "isPaidOnline": false,
                                  },
                                  (route) => false,
                                );
                              }
                            }
                            print("Paid : $isPaid");
                          }
                        });
                        return MessageTextWidget(
                          msg: S.of(context).ordrplcd,
                        );
                        // return Text("Text");
                      },
                      error: (_) {
                        Future.delayed(
                          const Duration(seconds: 2),
                        ).then((value) {
                          ref.refresh(placeOrdersProvider);
                        });
                        return ErrorTextWidget(
                          error: _.error,
                        );
                      },
                    );
              },
            ),
          ),
        );
      },
    );
  }

  double calculateTotal(List<CarItemHiveModel> cartItems) {
    double amount = 0;
    for (final element in cartItems) {
      if (element.subProduct != null) {
        amount += element.productsQTY *
            (element.unitPrice + element.subProduct!.price!);
      } else {
        amount += element.productsQTY * element.unitPrice;
      }
    }

    return amount;
  }
}
