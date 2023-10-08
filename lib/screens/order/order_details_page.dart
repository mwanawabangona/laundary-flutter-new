import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:laundry_customer/constants/app_box_decoration.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/global_functions.dart';
import 'package:laundry_customer/models/hive_cart_item_model.dart';
import 'package:laundry_customer/models/order_details_model/product.dart';
import 'package:laundry_customer/providers/order_providers.dart';
import 'package:laundry_customer/screens/order/order_dialouges.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/widgets/buttons/order_cancel_button.dart';
import 'package:laundry_customer/widgets/dashed_line.dart';
import 'package:laundry_customer/widgets/global_functions.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:laundry_customer/widgets/screen_wrapper.dart';

class OrderDetails extends ConsumerStatefulWidget {
  const OrderDetails({
    super.key,
    required this.orderID,
    required this.orderStatus,
  });
  final String orderID;
  final String orderStatus;

  @override
  ConsumerState<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends ConsumerState<OrderDetails> {
  final Box cartsBox = Hive.box(AppHSC.cartBox);
  bool isChatAble = false;
  // late int? driverId;
  @override
  Widget build(BuildContext context) {
    final Box settingsBox = Hive.box(AppHSC.appSettingsBox);
    final userBox = Hive.box(AppHSC.userBox);
    final Map<dynamic, dynamic> userData = userBox.toMap();
    final int userId = userData['id'] as int;
    ref.watch(orderDetailsProvider(widget.orderID));
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Container(
        height: 812.h,
        width: 375.w,
        color: AppColors.grayBG,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    color: AppColors.primary,
                    width: 375.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Column(
                        children: [
                          AppSpacerH(44.h),
                          AppNavbar(
                            backgroundColor: AppColors.primary,
                            titleColor: AppColors.white,
                            title: S.of(context).ordrdtls,
                            onBack: () {
                              context.nav.pop();
                            },
                          ),
                          AppSpacerH(12.h)
                        ],
                      ),
                    ),
                  ),
                  // if (isChatAble)
                  //   Positioned(
                  //     right: 0,
                  //     top: 45.h,
                  //     child: IconButton(
                  //       color: Colors.white,
                  //       onPressed: () {
                  //         context.nav.pushNamed(
                  //           Routes.messageScreen,
                  //           arguments: MessageScreenArgument(
                  //             orderId: int.parse(widget.orderID),
                  //             senderId: userId,
                  //             receiverId: driverId!,
                  //           ),
                  //         );
                  //       },
                  //       icon: const Icon(Icons.message),
                  //     ),
                  //   )
                  // else
                  //   const SizedBox()
                ],
              ),
              Container(
                height: 724.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: ref.watch(orderDetailsProvider(widget.orderID)).map(
                      initial: (_) => const LoadingWidget(),
                      loading: (_) => const LoadingWidget(),
                      loaded: (_) {
                        Future.delayed(const Duration(milliseconds: 50), () {
                          setState(() {
                            isChatAble = _.data.data!.order!.isChatAble!;
                          });
                        });
                        // if (_.data.data!.order!.drivers!.driverId != null) {
                        //   setState(() {
                        //     driverId = _.data.data!.order!.drivers!.driverId;
                        //   });
                        // }
                        final List<OrderDetailsTile> orderWidgets = [];
                        final List<CarItemHiveModel> products = [];
                        for (var i = 0;
                            i < _.data.data!.order!.products!.length;
                            i++) {
                          var subproductprice = 0;
                          for (final subproduct
                              in _.data.data!.order!.products![i].sbproducts!) {
                            for (final orderedsubproduct
                                in _.data.data!.order!.orderSubProduct!) {
                              if (subproduct.id == orderedsubproduct.id) {
                                subproductprice = orderedsubproduct.price!;
                              }
                            }
                          }
                          orderWidgets.add(
                            OrderDetailsTile(
                              product: _.data.data!.order!.products![i],
                              qty: _.data.data!.order!.quantity!.quantity[i]
                                  .quantity,
                              subprice: subproductprice,
                            ),
                          );
                          if (_.data.data!.order!.orderStatus == 'Pending') {
                            cartsBox.clear();
                          }
                          final CarItemHiveModel product = CarItemHiveModel(
                            productsId:
                                _.data.data!.order!.products![i].id ?? 0,
                            productsName:
                                _.data.data!.order!.products![i].name ?? '',
                            productsImage:
                                _.data.data!.order!.products![i].imagePath ??
                                    '',
                            productsQTY: _.data.data!.order!.quantity!
                                .quantity[i].quantity,
                            unitPrice:
                                _.data.data!.order!.products![i].currentPrice ??
                                    0.0,
                            serviceName: _.data.data!.order!.products![i]
                                    .service!.name ??
                                '',
                          );
                          products.add(product);
                        }
                        return ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            AppSpacerH(10.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 15.h,
                              ),
                              decoration: AppBoxDecorations.pageCommonCard,
                              child: ExpandablePanel(
                                header: Text(
                                  '${S.of(context).itms} (${_.data.data!.order!.products!.length})',
                                  style: AppTextDecor.osBold14black,
                                ),
                                collapsed: const SizedBox(),
                                expanded: Column(
                                  children: orderWidgets,
                                ),
                              ),
                            ),
                            AppSpacerH(15.h),
                            Container(
                              width: 335.w,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 15.h,
                              ),
                              decoration: AppBoxDecorations.pageCommonCard,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S.of(context).shpngadrs,
                                    style: AppTextDecor.osBold14black,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_pin,
                                        size: 40.w,
                                      ),
                                      AppSpacerW(10.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _.data.data!.order!.customer!.user!
                                                .name!,
                                            style:
                                                AppTextDecor.osRegular14black,
                                          ),
                                          if (_.data.data!.order!.customer!
                                                  .user!.mobile ==
                                              null)
                                            const SizedBox()
                                          else
                                            Text(
                                              _.data.data!.order!.customer!
                                                  .user!.mobile!,
                                              style:
                                                  AppTextDecor.osRegular14black,
                                            ),
                                          Text(
                                            _.data.data!.order!.address!
                                                    .addressLine ??
                                                '',
                                            style:
                                                AppTextDecor.osRegular14black,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.6,
                                            child: Text(
                                              "${_.data.data!.order!.address!.addressName}, ${_.data.data!.order!.address!.area}, ${_.data.data!.order!.address!.addressLine2 ?? ''} - ${_.data.data!.order!.address!.postCode}",
                                              style:
                                                  AppTextDecor.osRegular14black,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            AppSpacerH(15.h),
                            Container(
                              width: 335.w,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 15.h,
                              ),
                              decoration: AppBoxDecorations.pageCommonCard,
                              child: Column(
                                children: [
                                  Table(
                                    children: [
                                      AppGFunctions.tableTitleTextRow(
                                        title: S.of(context).ordrid,
                                        data:
                                            '#${_.data.data!.order!.orderCode}',
                                      ),
                                      AppGFunctions.tableTextRow(
                                        title: S.of(context).pickupat,
                                        data:
                                            '${_.data.data!.order!.pickDate} - ${_.data.data!.order!.pickHour}',
                                      ),
                                      AppGFunctions.tableTextRow(
                                        title: S.of(context).dlvryat,
                                        data:
                                            '${_.data.data!.order!.deliveryDate} - ${_.data.data!.order!.deliveryHour}',
                                      ),
                                      AppGFunctions.tableTextRow(
                                        title: S.of(context).ordrstats,
                                        data: getLng(
                                          en: _.data.data!.order!.orderStatus,
                                          changeLang: _
                                              .data.data!.order!.orderStatusbn
                                              .toString(),
                                        ),
                                      ),
                                      AppGFunctions.tableTextRow(
                                        title: S.of(context).pymntstats,
                                        data: getLng(
                                          en: _.data.data!.order!.paymentStatus,
                                          changeLang: _
                                              .data.data!.order!.paymentStatusbn
                                              .toString(),
                                        ),
                                      ),
                                      AppGFunctions.tableTextRow(
                                        title: S.of(context).sbttl,
                                        data:
                                            '${settingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(_.data.data!.order!.amount!)}',
                                      ),
                                      AppGFunctions.tableTextRow(
                                        title: S.of(context).dlvrychrg,
                                        data:
                                            '${settingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(_.data.data!.order!.deliveryCharge!)}',
                                      ),
                                      AppGFunctions.tableDiscountTextRow(
                                        title: S.of(context).dscnt,
                                        data:
                                            '${settingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(_.data.data!.order!.discount!)}',
                                      ),
                                    ],
                                  ),
                                  const MySeparator(),
                                  AppSpacerH(8.5.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        S.of(context).ttl,
                                        style: AppTextDecor.osBold14black,
                                      ),
                                      Text(
                                        '${settingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(_.data.data!.order!.totalAmount!)}',
                                        style: AppTextDecor.osBold14black,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // AppSpacerH(15.h),
                            // MARK: Order update options

                            // if (_.data.data?.order?.orderStatus == 'Pending')
                            //   AppIconTextButton(
                            //     title: S.of(context).updateproduct,
                            //     icon: Icons.edit,
                            //     onTap: () async {
                            //       if (_.data.data!.order!.orderStatus ==
                            //           'Pending') {
                            //         for (final product in products) {
                            //           await cartsBox.add(
                            //             product.toMap(),
                            //           );
                            //         }
                            //         context.nav.pop();
                            //         ref
                            //                 .read(
                            //                   orderIdProvider.notifier,
                            //                 )
                            //                 .state =
                            //             _.data.data!.order!.id.toString();
                            //         ref
                            //             .watch(
                            //               homeScreenIndexProvider.notifier,
                            //             )
                            //             .state = 0;
                            //         ref
                            //             .watch(
                            //               homeScreenPageControllerProvider,
                            //             )
                            //             .animateToPage(
                            //               0,
                            //               duration: transissionDuration,
                            //               curve: Curves.easeInOut,
                            //             );
                            //       }
                            //     },
                            //   ),
                            if (_.data.data?.order?.orderStatus ==
                                    'Delivered' &&
                                _.data.data?.order?.rating == null)
                              CancelOrderButton(
                                title: S.of(context).rateurexprnc,
                                onTap: () {
                                  AppOrderDialouges.orderFeedBackDialouge(
                                    context: context,
                                    orderID: _.data.data!.order!.id.toString(),
                                    ref: ref,
                                  );
                                },
                              ),
                            AppSpacerH(8.h)
                          ],
                        );
                      },
                      error: (_) => ErrorTextWidget(
                        error: _.error,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailsTile extends StatelessWidget {
  const OrderDetailsTile({
    super.key,
    required this.product,
    required this.qty,
    this.subprice,
  });
  final Product product;
  final int qty;
  final int? subprice;

  @override
  Widget build(BuildContext context) {
    final Box settingsBox = Hive.box(AppHSC.appSettingsBox);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: SizedBox(
        // height: 40.h,
        width: 297.w,
        child: Row(
          children: [
            Image.network(
              product.imagePath!,
              height: 40.h,
              width: 42.w,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name!,
                          style: AppTextDecor.osBold12black,
                        ),
                      ),
                      Text(
                        '${settingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo((product.currentPrice! + (subprice != null ? subprice! : 0)) * qty)}',
                        style: AppTextDecor.osBold12gold,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.service?.name ?? '',
                          style: AppTextDecor.osRegular12navy,
                          maxLines: 3,
                        ),
                      ),
                      Text(
                        '${qty}x${settingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(product.currentPrice! + (subprice != null ? subprice! : 0))} ',
                        style: AppTextDecor.osRegular12navy,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
