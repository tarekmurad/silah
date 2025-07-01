import 'package:auto_route/auto_route.dart';
import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silah_connect/src/injection_container.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/shared_components/widgets/button_widget.dart';
import '../../../../core/shared_components/widgets/custom_loader.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../../../core/utils/global_config.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/utils.dart';
import '../../../library/presentation/widgets/media_list_view.dart';
import 'bloc/bloc.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainBloc _bloc;
  late GlobalKey _scaffoldKey;

  int? count;
  // bool isAnnouncementEmpty = true;

  @override
  void initState() {
    super.initState();

    _bloc = getIt<MainBloc>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    _bloc.add(GetAnnouncements());
    _bloc.add(GetLibrary());
    _bloc.add(GetUnreadNotificationsCount());
    _bloc.add(GetCalendarSchedules());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('MainPage'),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage == 100) {
          _bloc.add(GetWatchedHistoryLibrary());
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              SizedBox(
                height: 295.h,
                child: Stack(
                  children: [
                    Container(
                      height: 225.h,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 225.h,
                      width: double.infinity,
                      child: SvgPicture.asset(
                        Assets.background,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: 225.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0x0004075F),
                            Color(0x1104075F),
                            Color(0xdd04075F)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(16.r),
                          bottomRight: Radius.circular(16.r),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 54,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (getIt<GlobalConfig>().currentUser?.name !=
                                    null)
                                  Row(
                                    children: [
                                      Text(
                                        "Salam ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: AppColors.whiteColor,
                                              fontSize: 16.sp,
                                            ),
                                      ),
                                      Text(
                                        "${Helper.capitalizeEachWord(getIt<GlobalConfig>().currentUser?.name ?? '') ?? ''}!",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: AppColors.whiteColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  )
                                else
                                  SizedBox(),
                                BlocBuilder<MainBloc, MainState>(
                                  bloc: _bloc,
                                  buildWhen: (previous, current) =>
                                      current is GetUnreadNotificationsCountLoadingState ||
                                      current
                                          is GetUnreadNotificationsCountSucceedState ||
                                      current
                                          is GetUnreadNotificationsCountFailedState,
                                  builder: (context, state) {
                                    final showBadge = state
                                        is GetUnreadNotificationsCountSucceedState;
                                    count = showBadge ? state.count : 0;

                                    final iconButton = IconButton(
                                      color: AppColors.whiteColor,
                                      icon: const Icon(
                                          Icons.notifications_outlined),
                                      iconSize: 26.w,
                                      onPressed: () {
                                        _bloc.add(
                                            ResetUnreadNotificationsCount());
                                        context.pushRoute(NotificationRoute());
                                      },
                                    );

                                    if (!showBadge || count == 0)
                                      return iconButton;

                                    return badges.Badge(
                                      badgeContent: Text(
                                        '$count',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: AppColors.whiteColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                      position: badges.BadgePosition.topEnd(
                                          top: -5, end: 0),
                                      child: iconButton,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          EasyDateTimeLinePicker.itemBuilder(
                            firstDate:
                                DateTime.now().subtract(Duration(days: 3)),
                            lastDate: DateTime.now().add(Duration(days: 26)),
                            focusedDate: DateTime.now(),
                            timelineOptions: TimelineOptions(),
                            monthYearPickerOptions: MonthYearPickerOptions(),
                            headerOptions: HeaderOptions(
                                headerType: HeaderType.viewOnly,
                                headerBuilder: (
                                  BuildContext context,
                                  DateTime date,
                                  VoidCallback onTap,
                                ) {
                                  return Text(
                                    '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          color: Colors.transparent,
                                          fontSize: 0.sp,
                                        ),
                                  );
                                }),
                            itemExtent: 40.w,
                            itemBuilder: (context, date, isSelected, isDisabled,
                                isToday, onTap) {
                              return InkResponse(
                                onTap: onTap,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      DateFormat('EEE')
                                          .format(date)
                                          .substring(0, 2)
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: isToday
                                                ? Color(0xffFFD466)
                                                : AppColors.primary300Color,
                                            fontSize: 15.sp,
                                            fontWeight: isToday
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      date.day.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: isToday
                                                ? Color(0xffFFD466)
                                                : AppColors.primary300Color,
                                            fontSize: 15.sp,
                                            fontWeight: isToday
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDateChange: (date) {
                              context.router.push(
                                CalendarRoute(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: BlocBuilder<MainBloc, MainState>(
                        bloc: _bloc,
                        buildWhen: (previous, current) {
                          if (current is GetAnnouncementsLoadingState ||
                              current is GetAnnouncementsSucceedState ||
                              current is GetAnnouncementsFailedState) {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        builder: (context, state) {
                          if (state is GetAnnouncementsLoadingState) {
                            return Center(
                              child: CustomLoader(
                                color: AppColors.primaryColor,
                                size: 30.w,
                              ),
                            );
                          } else if (state is GetAnnouncementsSucceedState) {
                            if (state.announcements.isEmpty) {
                              return const SizedBox();
                            } else {
                              // setState(() {
                              //   isAnnouncementEmpty = false;
                              // });
                              return buildMain(state);
                            }
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<MainBloc, MainState>(
                        bloc: _bloc,
                        buildWhen: (previous, current) {
                          if (current is GetCalendarSchedulesLoadingState ||
                              current is GetCalendarSchedulesSucceedState ||
                              current is GetCalendarSchedulesFailedState) {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        builder: (context, state) {
                          if (state is GetCalendarSchedulesSucceedState) {
                            if (state.schedules.isNotEmpty) {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // if (isAnnouncementEmpty)
                                    //   SizedBox(
                                    //     height: 20.h,
                                    //   ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Text(
                                        'Today Session',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: AppColors.primaryColor,
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 14.h,
                                    ),
                                    buildCalendar(state),
                                  ]);
                            }
                            return const SizedBox();
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      BlocBuilder<MainBloc, MainState>(
                        bloc: _bloc,
                        buildWhen: (previous, current) {
                          if (current is GetWatchedHistorySucceedState ||
                              current is GetWatchedHistoryFailedState) {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        builder: (context, state) {
                          // if (state is GetWatchedHistoryLoadingState) {
                          //   return Center(
                          //     child: CustomLoader(
                          //       color: AppColors.primaryColor,
                          //       size: 30.w,
                          //     ),
                          //   );
                          // } else
                          if (state is GetWatchedHistorySucceedState) {
                            if (state.folders.isNotEmpty) {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Text(
                                        'Continue Learning',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: AppColors.primaryColor,
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    buildList(state)
                                  ]);
                            } else {
                              return const SizedBox();
                            }
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      BlocBuilder<MainBloc, MainState>(
                        bloc: _bloc,
                        buildWhen: (previous, current) {
                          if (current is GetLibraryLoadingState ||
                              current is GetLibrarySucceedState ||
                              current is GetLibraryFailedState) {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        builder: (context, state) {
                          // if (state is GetLibraryLoadingState) {
                          //   return Center(
                          //     child: CustomLoader(
                          //       color: AppColors.primaryColor,
                          //       size: 30.w,
                          //     ),
                          //   );
                          // } else
                          if (state is GetLibrarySucceedState) {
                            if (state.folders.isNotEmpty) {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Text(
                                        'New Content!',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: AppColors.primaryColor,
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    buildList(state)
                                  ]);
                            } else {
                              return const SizedBox();
                            }
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _currentIndex = 0;

  buildMain(GetAnnouncementsSucceedState state) {
    return Column(
      children: [
        SizedBox(
          height: 110.h,
          child: CarouselSlider.builder(
            itemCount: state.announcements.length,
            itemBuilder: (context, index, realIdx) {
              final item = state.announcements[index];
              return Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD466),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                child: SvgPicture.asset(
                                  Assets.yellowTexture,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item.title ?? '',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    item.body ?? '',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              viewportFraction: 0.92,
              autoPlayInterval: const Duration(seconds: 3),
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            state.announcements.length,
            (index) => Container(
              width: 7.w,
              height: 7.w,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? AppColors.primaryColor
                    : AppColors.primary300Color,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  buildCalendar(GetCalendarSchedulesSucceedState state) {
    return ListView.builder(
      itemCount: state.schedules.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        final item = state.schedules[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.primary100Color,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.title ?? '',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      '${DateFormat.jm().format(DateTime.parse(item.start ?? ''))}'
                      ' - '
                      '${DateFormat.jm().format(DateTime.parse(item.end ?? ''))}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.primary300Color,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                if (item.desc != null && item.desc!.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    item.desc ?? '',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: AppColors.neutral1000Color,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: 8.h),
                ],
                if (item.link != null && item.link!.isNotEmpty) ...[
                  SizedBox(height: 20.h),
                  Container(
                    height: 52.h,
                    child: ButtonWidget(
                      onPressed: () async {
                        if (item.link != null && item.link!.isNotEmpty) {
                          final Uri url = Uri.parse(item.link!);
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        } else {
                          showSnackBar(
                            context,
                            'No link available for this meeting.',
                            AppColors.warningColor,
                          );
                        }
                      },
                      labelText: "Join on Zoom",
                      labelColor: AppColors.whiteColor,
                      color: AppColors.primaryColor,
                      labelTextFontSize: 15.sp,
                    ),
                  )
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  buildList(state) {
    return MediaListView(
      items: state.folders,
      isDownloadItem: false,
      onTab: (item) {
        switch (item.type) {
          case 'FOLDER':
            context.pushRoute(
                LibraryRoute(folderId: item.id, folderName: item.name));
          case 'VIDEO':
            context.router.push(
              VideoPlayerRoute(
                file: item,
              ),
            );
          case 'AUDIO':
            context.router.push(
              AudioPlayerRoute(
                file: item,
              ),
            );
          case 'PDF':
            context.router.push(
              PdfViewerRoute(
                file: item,
              ),
            );
        }
      },
    );
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th'; // Handle special cases
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
