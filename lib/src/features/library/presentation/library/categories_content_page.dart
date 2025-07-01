import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silah_connect/src/injection_container.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/shared_components/widgets/custom_loader.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../widgets/media_list_view.dart';
import 'bloc/bloc.dart';

@RoutePage()
class CategoriesContentPage extends StatefulWidget {
  final String? type;

  const CategoriesContentPage({this.type, super.key});

  @override
  _CategoriesContentPageState createState() => _CategoriesContentPageState();
}

class _CategoriesContentPageState extends State<CategoriesContentPage> {
  late LibraryBloc _bloc;
  late GlobalKey _scaffoldKey;

  Timer? _debounce;
  String _lastQuery = '';

  late ScrollController _scrollController;
  late ValueNotifier<bool> _isLoadingNotifier;
  late int _currentPage;

  @override
  void initState() {
    super.initState();

    _bloc = getIt<LibraryBloc>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    _scrollController = ScrollController();
    _isLoadingNotifier = ValueNotifier<bool>(false);
    _currentPage = 1;

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (_currentPage + 1 < _bloc.notificationsList!.length) {
          _currentPage += 1;
          _isLoadingNotifier.value = true;
          _bloc.add(
              GetLibraryCategory(type: widget.type, currentPage: _currentPage));
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
    return VisibilityDetector(
      key: Key(widget.type ?? 'root'),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage == 100) {
          _currentPage = 1;
          _bloc.add(
              GetLibraryCategory(type: widget.type, currentPage: _currentPage));
        }
      },
      child: Scaffold(
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
                                  widget.type ?? "Library",
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
                    BlocBuilder<LibraryBloc, LibraryState>(
                      bloc: _bloc,
                      buildWhen: (previous, current) {
                        if (current is GetLibraryCategoryLoadingState ||
                            current is GetLibraryCategorySucceedState ||
                            current is GetLibraryCategoryFailedState) {
                          return true;
                        } else {
                          return false;
                        }
                      },
                      builder: (context, state) {
                        if (state is GetLibraryCategoryLoadingState) {
                          return Expanded(
                            child: Center(
                              child: CustomLoader(
                                color: AppColors.primaryColor,
                                size: 30.w,
                              ),
                            ),
                          );
                        } else if (state is GetLibraryCategorySucceedState) {
                          if (state.folders.isEmpty) {
                            return Expanded(
                              child: Center(
                                child: Text(
                                  'No matches found!',
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
                                            _bloc.add(GetLibraryCategory(
                                                type: widget.type,
                                                currentPage: _currentPage));
                                          },
                                        ),
                                        SliverToBoxAdapter(
                                          child: buildList(state),
                                        ),
                                      ],
                                    )
                                  : RefreshIndicator(
                                      onRefresh: () async {
                                        _currentPage = 1;
                                        _bloc.add(GetLibraryCategory(
                                            type: widget.type,
                                            currentPage: _currentPage));
                                      },
                                      color: AppColors.primaryColor,
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        child: buildList(state),
                                      ),
                                    ),
                            );
                          }
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
      ),
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
}
