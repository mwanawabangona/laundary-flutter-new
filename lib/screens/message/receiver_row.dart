import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReceiverRowView extends StatelessWidget {
  const ReceiverRowView({super.key, required this.receiverMessage});

  final String receiverMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Row(
        children: [
          Flexible(
            flex: 72,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 5.0,
                        right: 8.0,
                        top: 8.0,
                        bottom: 2.0,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gray,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.sp),
                        ).copyWith(
                          bottomLeft: Radius.circular(0.sp),
                        ),
                      ),
                      child: Text(
                        receiverMessage,
                        textAlign: TextAlign.left,
                        style: AppTextDecor.osBold14black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            //
          ),
          Flexible(
            flex: 15,
            fit: FlexFit.tight,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
            ),
          ),
        ],
      ),
    );
  }
}
