import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';

class SenderRowView extends StatelessWidget {
  const SenderRowView({super.key, required this.senderMessage});

  final String senderMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            flex: 15,
            fit: FlexFit.tight,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
            ),
          ),
          Flexible(
            flex: 72,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Wrap(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.sp),
                        ).copyWith(
                          bottomRight: Radius.circular(0.sp),
                        ),
                      ),
                      child: Text(
                        senderMessage,
                        textAlign: TextAlign.left,
                        style: AppTextDecor.osBold14white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
