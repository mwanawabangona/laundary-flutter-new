import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/models/all_orders_model/order.dart';
import 'package:laundry_customer/providers/guest_providers.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/providers/order_providers.dart';
import 'package:laundry_customer/providers/profile_update_provider.dart';
import 'package:laundry_customer/providers/settings_provider.dart';
import 'package:laundry_customer/screens/order/my_order_home_tile.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/home_tab_card.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  List postCodelist = [];
  bool isShowText = false;
  @override
  void initState() {
    super.initState();
    // checkNewNotification();
    // notificationchck();
    // setupFirebaseMessaging();
  }

  // void setupFirebaseMessaging() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     // Handle incoming FCM message
  //     // You can perform additional processing or update UI here
  //     // For this example, we simply set the boolean variable to true
  //     ref.refresh(allOrdersProvider);
  //   });
  // }

  // void checkNewNotification() {
  //   OneSignal.shared.setNotificationOpenedHandler(
  //     (OSNotificationOpenedResult openedResult) {
  //       setState(() {
  //         hasNewNotification = true;
  //       });
  //
  //     },
  //   );
  // }

  // notificationchck() async {
  //   OneSignal.shared.setNotificationWillShowInForegroundHandler(
  //       (OSNotificationReceivedEvent event) {
  //     print('FOREGROUND HANDLER CALLED WITH: $event');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    ref.watch(profileInfoProvider);
    ref.watch(settingsProvider).maybeWhen(
          orElse: () {},
          loaded: (_) {
            postCodelist = _.data?.postCode ?? [];
          },
        );
    ref.watch(allServicesProvider);

    return SizedBox(
      height: 812.h,
      width: 375.w,
      child: ValueListenableBuilder(
        valueListenable: Hive.box(AppHSC.authBox).listenable(),
        builder: (context, Box authBox, Widget? child) {
          return ValueListenableBuilder(
            valueListenable: Hive.box(AppHSC.userBox).listenable(),
            builder: (context, Box box, Widget? child) {
              return Column(
                children: [
                  ClipRRect(
                    // borderRadius: BorderRadius.only(
                    //   bottomLeft: Radius.circular(20.h),
                    //   bottomRight: Radius.circular(20.h),
                    // ),
                    child: Container(
                      color: AppColors.white,
                      width: 375.w,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSpacerH(44.h),
                          SizedBox(
                            height: 48.h,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/icon_wave.png',
                                  height: 48.h,
                                  width: 48.w,
                                ),
                                AppSpacerW(15.w),
                                // if (authBox.get('token') != null)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).hello,
                                      style: AppTextDecor.osRegular14black,
                                      textAlign: TextAlign.start,
                                    ),
                                    Expanded(
                                      child: Text(
                                        authBox.get('token') != null
                                            ? '${box.get('name')}'
                                            : S.of(context).plslgin,
                                        style: AppTextDecor.osBold20Black,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    // Text(
                                    //   address,
                                    //   style: AppTextDecor.osRegular14white,
                                    // )
                                  ],
                                ),
                                const Expanded(child: SizedBox()),
                                if (authBox.get('token') != null)
                                  Container(
                                    // padding: const EdgeInsets.all(1),
                                    width: 39.h,
                                    height: 39.h,
                                    decoration: BoxDecoration(
                                      // border: Border.all(
                                      //   color: AppColors.gray,
                                      // ),
                                      borderRadius: BorderRadius.circular(18.r),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18.r),
                                      child: CachedNetworkImage(
                                        imageUrl: box
                                            .get('profile_photo_path')
                                            .toString(),
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  )
                                else
                                  GestureDetector(
                                    onTap: () {
                                      context.nav.pushNamed(
                                        Routes.loginScreen,
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      "assets/svgs/icon_home_login.svg",
                                      width: 39.h,
                                      height: 39.h,
                                    ),
                                  )
                              ],
                            ),
                          ),
                          AppSpacerH(20.h),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        AppSpacerH(20.h),
                        SizedBox(
                          width: 375.w,
                          height: 170.h,
                          child: Consumer(
                            builder: (context, ref, child) {
                              return ref.watch(allPromotionsProvider).map(
                                    initial: (_) => const SizedBox(),
                                    loading: (_) => const SizedBox(),
                                    loaded: (_) => CarouselSlider(
                                      options: CarouselOptions(
                                        height: 170.0.h,
                                        viewportFraction: 0.95,
                                      ),
                                      items: _.data.data!.promotions!
                                          .map(
                                            (e) => Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 9.w,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10.w,
                                                ),
                                                child: Container(
                                                  color: AppColors.white,
                                                  width: 355.w,
                                                  child: Image.network(
                                                    e.imagePath!,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    error: (_) =>
                                        ErrorTextWidget(error: _.error),
                                  );
                            },
                          ),
                        ),
                        AppSpacerH(32.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: isShowText,
                                child: Text(
                                  S.of(context).srvctgrs,
                                  style: AppTextDecor.osBold24black
                                      .copyWith(color: AppColors.black),
                                ),
                              ),
                              AppSpacerH(12.h),
                              ref.watch(allServicesProvider).map(
                                    initial: (_) => const SizedBox(),
                                    loading: (_) => const LoadingWidget(
                                      showBG: true,
                                    ),
                                    loaded: (_) {
                                      Future.delayed(Duration.zero, () {
                                        setState(() {
                                          isShowText = true;
                                        });
                                      });
                                      if (_.data.data!.services!.isNotEmpty) {
                                        final widgets = _.data.data!.services!
                                            .asMap()
                                            .entries
                                            .map(
                                              (entry) => Container(
                                                color: AppColors.white,
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 5.w,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                // padding: EdgeInsets.only(
                                                //   right: Hive.box(
                                                //             AppHSC
                                                //                 .appSettingsBox,
                                                //           )
                                                //               .get(
                                                //                 AppHSC.appLocal,
                                                //               )
                                                //               .toString() ==
                                                //           "en"
                                                //       ? 20.w
                                                //       : 0.w,
                                                //   left: Hive.box(
                                                //             AppHSC
                                                //                 .appSettingsBox,
                                                //           )
                                                //               .get(
                                                //                 AppHSC.appLocal,
                                                //               )
                                                //               .toString() ==
                                                //           "en"
                                                //       ? 0.w
                                                //       : 20.w,
                                                // ),
                                                child: Center(
                                                  child: HomeTabCard(
                                                    service: entry.value,
                                                    ontap: () {
                                                      ref.refresh(
                                                        servicesVariationsProvider(
                                                          entry.value.id
                                                              .toString(),
                                                        ),
                                                      );
                                                      ref.refresh(
                                                        productsFilterProvider,
                                                      );
                                                      ref
                                                          .watch(
                                                            itemSelectMenuIndexProvider
                                                                .notifier,
                                                          )
                                                          .state = 0;

                                                      context.nav.pushNamed(
                                                        Routes.chooseItemScreen,
                                                        arguments: entry.value,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList();
                                        if (authBox.get(AppHSC.authToken) !=
                                                null &&
                                            authBox.get(AppHSC.authToken) !=
                                                '') {
                                          return SizedBox(
                                            height: 112.h,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: widgets,
                                            ),
                                          );
                                        } else {
                                          return GridView.count(
                                            shrinkWrap: true,
                                            crossAxisSpacing: 16.w,
                                            mainAxisSpacing: 16.h,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            crossAxisCount: 3,
                                            children: widgets,
                                          );
                                        }
                                      } else {
                                        return MessageTextWidget(
                                          msg: S.of(context).nosrvcavlbl,
                                        );
                                      }
                                    },
                                    error: (_) =>
                                        ErrorTextWidget(error: _.error),
                                  ),
                              if (authBox.get('token') != null)
                                ...ref.watch(allOrdersProvider).map(
                                      initial: (_) => [const SizedBox()],
                                      loading: (_) => [const LoadingWidget()],
                                      loaded: (_) {
                                        if (_.data.data!.orders!.isEmpty) {
                                          return [
                                            AppSpacerH(100.h),
                                            MessageTextWidget(
                                              msg: S.of(context).noordrfnd,
                                            )
                                          ];
                                        } else {
                                          return [
                                            AppSpacerH(32.h),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  S.of(context).actvordr,
                                                  style: AppTextDecor
                                                      .osBold14gold
                                                      .copyWith(
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    ref
                                                        .watch(
                                                          homeScreenIndexProvider
                                                              .notifier,
                                                        )
                                                        .state = 1;
                                                    ref
                                                        .watch(
                                                          homeScreenPageControllerProvider,
                                                        )
                                                        .animateToPage(
                                                          1,
                                                          duration:
                                                              transissionDuration,
                                                          curve:
                                                              Curves.easeInOut,
                                                        );
                                                  },
                                                  child: Text(
                                                    S.of(context).vewall,
                                                    style: AppTextDecor
                                                        .osRegular14Navy
                                                        .copyWith(
                                                      color: AppColors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            AppSpacerH(16.h),
                                            ..._.data.data!.orders!
                                                .asMap()
                                                .entries
                                                .map(
                                              (entry) {
                                                final int index = entry.key;
                                                final Order data = entry.value;

                                                return Column(
                                                  children: [
                                                    HomeOrderTile(data: data),
                                                    if (index ==
                                                        _.data.data!.orders!
                                                                .length -
                                                            1) // Check if it's the last widget
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          bottom: 140.h,
                                                        ), // Add desired padding
                                                      ),
                                                  ],
                                                );
                                              },
                                            ).toList()
                                          ];
                                        }
                                      },
                                      error: (_) =>
                                          [ErrorTextWidget(error: _.error)],
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<String> images = [
    'assets/images/dim_00.png',
    'assets/images/dim_01.png',
    'assets/images/dim_02.png'
  ];
}
