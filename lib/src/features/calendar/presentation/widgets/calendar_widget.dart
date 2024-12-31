import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../core/styles/app_colors.dart';
import '../../data/models/calendar_model.dart';

class CustomCalendarWidget extends StatelessWidget {
  final List<CalendarModel> dataSource;
  final Function(CalendarTapDetails)? onTap;

  const CustomCalendarWidget({
    super.key,
    required this.dataSource,
    required this.onTap,
  });

  Widget _appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final appointment = details.appointments.first;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.title,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      DateFormat('hh:mm a')
                          .format(DateTime.parse(appointment.start)),
                      style: TextStyle(
                        color: AppColors.neutral300Color,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (appointment.link != null && appointment.link.isNotEmpty)
                      Text(
                        " - Join on Zoom",
                        style: TextStyle(
                          color: AppColors.neutral300Color,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                Icons.link,
                color: AppColors.whiteColor,
                size: 18.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      selectionDecoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primaryColor,
          width: 1.5,
        ),
      ),
      view: CalendarView.month,
      todayHighlightColor: AppColors.primaryColor,
      cellBorderColor: AppColors.whiteColor,
      backgroundColor: AppColors.whiteColor,
      dataSource: MeetingDataSource(dataSource),
      onTap: (details) {
        if (onTap != null) onTap!(details);
      },
      appointmentBuilder: _appointmentBuilder,
      headerHeight: 50.h,
      viewHeaderHeight: 50.h,
      cellEndPadding: 10.h,
      headerStyle: CalendarHeaderStyle(
        backgroundColor: AppColors.whiteColor,
        textStyle: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
      ),
      viewHeaderStyle: ViewHeaderStyle(
        backgroundColor: AppColors.whiteColor,
        dayTextStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.primary400Color,
        ),
      ),
      monthViewSettings: MonthViewSettings(
        showAgenda: true,
        agendaStyle: AgendaStyle(
          appointmentTextStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.primaryColor,
          ),
          dateTextStyle: TextStyle(
            fontSize: 16.sp,
            color: AppColors.primaryColor,
          ),
          dayTextStyle: TextStyle(
            fontSize: 20.sp,
            color: AppColors.primaryColor,
          ),
          placeholderTextStyle: TextStyle(
            fontSize: 16.sp,
            color: AppColors.neutral300Color,
          ),
        ),
        dayFormat: 'EE',
        agendaItemHeight: 56.h,
        navigationDirection: MonthNavigationDirection.vertical,
        appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
        monthCellStyle: MonthCellStyle(
          textStyle: TextStyle(fontSize: 14.sp),
          trailingDatesTextStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.neutral300Color,
          ),
          leadingDatesTextStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.neutral300Color,
          ),
        ),
        numberOfWeeksInView: 6,
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<CalendarModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return DateTime.parse(appointments![index].start);
  }

  @override
  DateTime getEndTime(int index) {
    return DateTime.parse(appointments![index].end);
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    return AppColors.primary500Color;
  }
}
