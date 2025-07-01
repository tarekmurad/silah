import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silah_connect/src/injection_container.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/navigation/app_router.dart';
import '../../../../core/shared_components/widgets/custom_loader.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../../library/presentation/widgets/media_list_view.dart';
import 'bloc/bloc.dart';

@RoutePage()
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late NotificationBloc _bloc;
  late GlobalKey _scaffoldKey;

  late ScrollController _scrollController;
  late ValueNotifier<bool> _isLoadingNotifier;
  late int _currentPage;

  @override
  void initState() {
    super.initState();

    _bloc = getIt<NotificationBloc>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    _scrollController = ScrollController();
    _isLoadingNotifier = ValueNotifier<bool>(false);
    _currentPage = 1;

    _bloc.add(GetNotification(currentPage: _currentPage));
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels ) {
        if (_currentPage + 1 < _bloc.notificationsList!.length) {
          _currentPage += 1;
          _isLoadingNotifier.value = true;
          _bloc.add(GetNotification(currentPage: _currentPage));
        }
      }
    });
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 20.w),
                              SizedBox(
                                width: 30.w,
                                height: 30.w,
                                child: GestureDetector(
                                  onTap: () {
                                    context.router.maybePop();
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: AppColors.whiteColor,
                                    size: 20.w,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Notifications",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: AppColors.whiteColor,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(width: 50.w),
                        ],
                      )
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
                  BlocListener<NotificationBloc, NotificationState>(
                    bloc: _bloc,
                    listenWhen: (previous, current) =>
                        current is GetNotificationSucceedState,
                    listener: (context, state) {
                      if (state is GetNotificationSucceedState) {
                        if (_currentPage == 1) _bloc.add(MarkAllAsRead());
                      }
                    },
                    child: BlocBuilder<NotificationBloc, NotificationState>(
                      bloc: _bloc,
                      buildWhen: (previous, current) {
                        if (current is GetNotificationLoadingState ||
                            current is GetNotificationSucceedState ||
                            current is GetNotificationFailedState) {
                          return true;
                        } else {
                          return false;
                        }
                      },
                      builder: (context, state) {
                        if (state is GetNotificationLoadingState) {
                          return Expanded(
                            child: Center(
                              child: CustomLoader(
                                color: AppColors.primaryColor,
                                size: 30.w,
                              ),
                            ),
                          );
                        } else if (state is GetNotificationSucceedState) {
                          if (state.notifications.isEmpty) {
                            return Expanded(
                              child: Center(
                                child: Text(
                                  'There are no notifications yet.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: AppColors.neutral300Color,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ),
                            );
                          } else {
                            return Expanded(
                              child: Platform.isIOS
                                  ? CustomScrollView(
                                controller: _scrollController,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      slivers: [
                                        CupertinoSliverRefreshControl(
                                          onRefresh: () async {
                                            _currentPage = 1;
                                            _bloc.add(GetNotification(
                                                currentPage: _currentPage));
                                          },
                                        ),
                                        SliverToBoxAdapter(
                                          child: buildNotification(state),
                                        ),
                                      ],
                                    )
                                  : RefreshIndicator(
                                      onRefresh: () async {
                                        _currentPage = 1;
                                        _bloc.add(GetNotification(
                                            currentPage: _currentPage));
                                      },
                                      color: AppColors.primaryColor,
                                      child: SingleChildScrollView(
                                        controller: _scrollController,

                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        child: buildNotification(state),
                                      ),
                                    ),
                            );
                          }
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildNotification(GetNotificationSucceedState state) {
    return ListView.builder(
      itemCount: state.notifications.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemBuilder: (context, index) {
        final item = state.notifications[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: item.readAt != null
                ? AppColors.whiteColor
                : AppColors.primary100Color,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              if (item.readAt != null)
                BoxShadow(
                  color: Color(0x447E92F4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.title ?? '',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Text(
                      timeago.format(DateTime.parse(item.scheduledAt ?? '')),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  item.body ?? '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.blackColor,
                  ),
                ),
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
