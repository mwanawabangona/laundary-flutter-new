import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_string_const.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/models/schedule_model.dart';
import 'package:laundry_customer/models/schedules_model/schedule.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/providers/order_providers.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:laundry_customer/widgets/screen_wrapper.dart';
import 'package:table_calendar/table_calendar.dart';

class DeliverySchedulerPicker extends ConsumerStatefulWidget {
  const DeliverySchedulerPicker({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeliverySchedulerPickerState();
}

class _DeliverySchedulerPickerState
    extends ConsumerState<DeliverySchedulerPicker> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final dateSelect = ref.watch(dateProvider(AppStrConst.delivery));
    final ScheduleModel? pickSchedule = ref.watch(
      scheduleProvider(AppStrConst.pickup),
    );

    if (pickSchedule != null && dateSelect == null) {
      Future.delayed(buildDuration).then((value) {
        final autoDate = pickSchedule.dateTime.add(const Duration(days: 1));

        if (autoDate.weekday == DateTime.sunday) {
          ref.watch(dateProvider(AppStrConst.delivery).notifier).state =
              autoDate.add(const Duration(days: 1));
        } else {
          ref.watch(dateProvider(AppStrConst.delivery).notifier).state =
              autoDate;
        }
      });
    }

    ref.watch(deliveryScheduleProvider);
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Container(
        height: 812.h,
        width: 375.w,
        color: AppColors.grayBG,
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
                      title:
                          '${AppStrConst.delivery == "Delivery" ? S.of(context).dlvry : ""} ${S.of(context).schdl}',
                      onBack: () {
                        context.nav.pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: AppColors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.h),
                child: TableCalendar(
                  rowHeight: 50.h,
                  firstDay: DateTime.now(),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: dateSelect ?? DateTime.now(),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    selectedDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                  ),
                  onDaySelected: (DateTime selectDay, DateTime focusDay) {
                    if (!selectDay.isBefore(DateTime.now()) ||
                        isSameDay(
                              selectDay,
                              DateTime.now(),
                            ) &&
                            selectDay.weekday != DateTime.sunday) {
                      if (pickSchedule != null) {
                        if (!selectDay.isBefore(pickSchedule.dateTime) &&
                            !isSameDay(
                              selectDay,
                              pickSchedule.dateTime,
                            )) {
                          ref
                              .watch(
                                dateProvider(AppStrConst.delivery).notifier,
                              )
                              .state = selectDay;
                        }
                      } else {
                        EasyLoading.showError(
                          S.of(context).plsslctpckupschdl,
                        );
                      }
                    } else if (selectDay.weekday == DateTime.sunday) {
                      EasyLoading.showError(S.of(context).noslctavlbl);
                    }
                  },
                  selectedDayPredicate: (DateTime date) {
                    return isSameDay(dateSelect, date);
                  },
                ),
              ),
            ),
            Expanded(
              child: ref.watch(deliveryScheduleProvider).map(
                    initial: (_) => const SizedBox(),
                    loading: (_) => const LoadingWidget(),
                    loaded: (_) {
                      List<Schedule> schedules = _.data.data!.schedules!;

                      final ScheduleModel? pickSchedule = ref.watch(
                        scheduleProvider('Pick Up'),
                      );
                      if (pickSchedule != null &&
                          isSameDay(
                            dateSelect,
                            pickSchedule.dateTime.add(const Duration(days: 1)),
                          )) {
                        final List<Schedule> temp = [];
                        for (final element in _.data.data!.schedules!) {
                          if (int.parse(element.hour!.split('-').first) >=
                              int.parse(
                                pickSchedule.schedule.hour!.split('-').first,
                              )) {
                            temp.add(element);
                          }
                        }
                        schedules = temp;
                      }

                      return ValueListenableBuilder(
                        valueListenable:
                            Hive.box(AppHSC.appSettingsBox).listenable(),
                        builder: (
                          BuildContext context,
                          Box settingsBox,
                          Widget? child,
                        ) {
                          final selectedLocal =
                              settingsBox.get(AppHSC.appLocal);
                          return GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 2.9,
                            children: [
                              ...schedules.map(
                                (e) => GestureDetector(
                                  onTap: () {
                                    debugPrint("this is the date $dateSelect");
                                    if (pickSchedule != null) {
                                      ref
                                          .watch(
                                            scheduleProvider(
                                              AppStrConst.delivery,
                                            ).notifier,
                                          )
                                          .state = ScheduleModel(
                                        schedule: e,
                                        dateTime: dateSelect!,
                                      );

                                      context.nav.pop();
                                    } else {
                                      EasyLoading.showError(
                                        S.of(context).plsslctpckupschdl,
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      padding: EdgeInsets.all(5.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius:
                                            BorderRadius.circular(5.h),
                                      ),
                                      child: Center(
                                        child: Text(
                                          (selectedLocal == null ||
                                                  selectedLocal == '' ||
                                                  selectedLocal == 'en')
                                              ? e.title ?? ""
                                              : "${e.title!.split("-").last}- ${e.title!.split("-").first}",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                    error: (_) => ErrorTextWidget(error: _.error),
                  ),
            )
          ],
        ),
      ),
    );
  }
}
