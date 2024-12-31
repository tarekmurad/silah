import 'package:auto_route/auto_route.dart';
import 'package:boilerplate_flutter/src/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/shared_components/widgets/custom_loader.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../widgets/calendar_widget.dart';
import 'bloc/bloc.dart';

@RoutePage()
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarBloc _bloc;
  late GlobalKey _scaffoldKey;

  @override
  void initState() {
    super.initState();

    _bloc = getIt<CalendarBloc>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    _bloc.add(GetCalendarSchedules());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 105.h,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: SvgPicture.asset(
                    Assets.background,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Center(
                        child: Text(
                          "Calendar",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  BlocBuilder<CalendarBloc, CalendarState>(
                    bloc: _bloc,
                    builder: (context, state) {
                      if (state is GetCalendarSchedulesLoadingState) {
                        return Expanded(
                          child: Center(
                            child: CustomLoader(
                              color: AppColors.primaryColor,
                              size: 30.w,
                            ),
                          ),
                        );
                      } else if (state is GetCalendarSchedulesSucceedState) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: SizedBox(
                              height: 600.h,
                              child: CustomCalendarWidget(
                                dataSource: state.schedules,
                                onTap: (details) async {
                                  if (details.targetElement ==
                                      CalendarElement.appointment) {
                                    final appointment =
                                        details.appointments!.first;
                                    final zoomLink = appointment.link;

                                    if (zoomLink != null &&
                                        zoomLink.isNotEmpty) {
                                      final Uri url = Uri.parse(zoomLink);
                                      await launchUrl(url,
                                          mode: LaunchMode.externalApplication);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "No link available for this meeting.")),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
