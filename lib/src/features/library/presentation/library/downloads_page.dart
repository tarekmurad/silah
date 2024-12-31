import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:boilerplate_flutter/src/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/shared_components/widgets/custom_loader.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../widgets/media_list_view.dart';
import 'bloc/bloc.dart';

@RoutePage()
class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  _DownloadsPageState createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  late LibraryBloc _bloc;
  late GlobalKey _scaffoldKey;

  Timer? _debounce;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();

    _bloc = getIt<LibraryBloc>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    _bloc.add(GetDownloadsList());
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
                                width: 18.w,
                                height: 18.w,
                                child: GestureDetector(
                                  onTap: () {
                                    context.router.maybePop();
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: AppColors.whiteColor,
                                    size: 18.w,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Downloads",
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
                          SizedBox(width: 38.w),
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
                  BlocBuilder<LibraryBloc, LibraryState>(
                    bloc: _bloc,
                    buildWhen: (previous, current) {
                      if (current is GetDownloadListLoadingState ||
                          current is GetDownloadListSucceedState ||
                          current is GetDownloadListFailedState) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    builder: (context, state) {
                      if (state is GetDownloadListLoadingState) {
                        return Expanded(
                          child: Center(
                            child: CustomLoader(
                              color: AppColors.primaryColor,
                              size: 30.w,
                            ),
                          ),
                        );
                      } else if (state is GetDownloadListSucceedState) {
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
                            child: MediaListView(
                              items: state.folders,
                              onTab: (item) {
                                switch (item.type) {
                                  case 'FOLDER':
                                    context.pushRoute(LibraryRoute(
                                        folderId: item.id,
                                        folderName: item.name));

                                  case 'VIDEO':
                                    context.router.push(
                                      VideoPlayerRoute(
                                        file: item,
                                        isDownloadedFile: true,
                                      ),
                                    );

                                  case 'AUDIO':
                                    context.router.push(
                                      AudioPlayerRoute(
                                        file: item,
                                        isDownloadedFile: true,
                                      ),
                                    );

                                  case 'PDF':
                                    context.router.push(
                                      PdfViewerRoute(
                                        file: item,
                                        isDownloadedFile: true,
                                      ),
                                    );
                                }
                              },
                              onDownloadTab: (file) async {
                                if (await Permission.storage
                                        .request()
                                        .isGranted ||
                                    await Permission
                                        .manageExternalStorage.isGranted ||
                                    await Permission.mediaLibrary
                                        .request()
                                        .isGranted) {
                                  _bloc.add(DownloadFile(file: file));
                                } else {
                                  print('Permission denied');
                                }
                              },
                              isDownloadItem: true,
                              onFavoritesTab: (Folder, bool) {},
                            ),
                          );
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
          ],
        ),
      ),
    );
  }
}
