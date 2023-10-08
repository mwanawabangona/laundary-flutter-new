import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/global_functions.dart';
import 'package:laundry_customer/models/addres_list_model/address.dart';
import 'package:laundry_customer/providers/address_provider.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:laundry_customer/widgets/screen_wrapper.dart';

class ManageAddressScreen extends ConsumerStatefulWidget {
  const ManageAddressScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManageAddressScreenState();
}

class _ManageAddressScreenState extends ConsumerState<ManageAddressScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(addresListProvider);
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Container(
        height: 812.h,
        width: 375.w,
        color: AppColors.grayBG,
        child: Stack(
          children: [
            SizedBox(
              height: 812.h,
              width: 375.w,
              child: Column(
                children: [
                  Container(
                    color: AppColors.primary,
                    height: 108.h,
                    width: 375.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Column(
                        children: [
                          AppSpacerH(44.h),
                          AppNavbar(
                            backgroundColor: AppColors.primary,
                            titleColor: AppColors.white,
                            title: S.of(context).mngadrs,
                            onBack: () {
                              context.nav.pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ref.watch(addresListProvider).map(
                          initial: (_) => const SizedBox(),
                          loading: (_) => const LoadingWidget(),
                          loaded: (_) => SingleChildScrollView(
                            child: Column(
                              children: [
                                ..._.data.data!.addresses!
                                    .map(
                                      (e) => AddressCard(address: e),
                                    )
                                    .toList()
                              ],
                            ),
                          ),
                          error: (_) => ErrorTextWidget(error: _.error),
                        ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 34.h,
              child: SizedBox(
                width: 375.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: AppTextButton(
                    title: S.of(context).adadres,
                    onTap: () {
                      context.nav.pushNamed(Routes.addOrUpdateAddressScreen);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddressCard extends ConsumerStatefulWidget {
  const AddressCard({
    super.key,
    required this.address,
  });
  final Address address;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressCardState();
}

class _AddressCardState extends ConsumerState<AddressCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Container(
        height: 93.h,
        width: 335.w,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5.h),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.location_pin,
              color: AppColors.black,
              size: 24.h,
            ),
            AppSpacerW(8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: widget.address.addressName != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  Text(
                    widget.address.addressLine.toString(),
                    style: AppTextDecor.osBold14black,
                  ),
                  Text(
                    processAddess(),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 58.w,
              height: 24.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.nav.pushNamed(
                        Routes.addOrUpdateAddressScreen,
                        arguments: widget.address,
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: AppColors.primary,
                      size: 24.h,
                    ),
                  ),
                  // Icon(
                  //   Icons.delete_forever,
                  //   color: AppColors.red,
                  //   size: 24.h,
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String processAddess() {
    String address = '';

    if (widget.address.addressLine2 == null) {
      address =
          "${widget.address.addressName}, ${widget.address.area}, ${widget.address.postCode}";
    } else {
      address =
          "${widget.address.addressName}, ${widget.address.area}, ${widget.address.addressLine2 ?? ''}, ${widget.address.postCode}";
    }
    return address;
  }
}

class AddressCardv2 extends ConsumerWidget {
  const AddressCardv2({
    super.key,
    required this.address,
    required this.isSelected,
  });
  final Address address;
  final bool isSelected;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Container(
        height: 93.h,
        width: 335.w,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5.h),
          border: Border.all(color: AppColors.gray),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.location_pin,
              color: AppColors.black,
              size: 24.h,
            ),
            AppSpacerW(8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: address.addressName != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  if (address.addressName != null)
                    Text(
                      address.addressName.toString(),
                      style: AppTextDecor.osBold14black,
                    ),
                  Text(
                    AppGFunctions.processAdAddess(address),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 15.h,
              )
          ],
        ),
      ),
    );
  }
}
