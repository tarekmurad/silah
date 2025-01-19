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
import '../../../../core/styles/app_dimens.dart';
import '../../../../core/styles/assets.dart';
import '../../data/models/folder.dart';
import '../widgets/media_list_view.dart';
import 'bloc/bloc.dart';

@RoutePage()
class LibraryPage extends StatefulWidget {
  final String? folderId;
  final String? folderName;

  const LibraryPage(
      {@PathParam('folderId') this.folderId, this.folderName, super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late LibraryBloc _bloc;
  late GlobalKey _scaffoldKey;

  Timer? _debounce;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();

    _bloc = getIt<LibraryBloc>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    _bloc.add(GetLibrary(parentId: widget.folderId));
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
                              if (widget.folderId != null)
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
                              else
                                SizedBox(
                                  width: 18.w,
                                  height: 18.w,
                                ),
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                widget.folderName ?? "Library",
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
                  if (widget.folderId == null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: SizedBox(
                        height: Dimens.buttonHeight,
                        child: TextField(
                          onChanged: (query) {
                            // Avoid redundant calls if the query is the same as the last one
                            if (query == _lastQuery) return;
                            _lastQuery = query;

                            // Clear previous search if the query is empty
                            if (query.isEmpty) {
                              _debounce?.cancel();
                              _bloc.add(GetLibrary(parentId: null));
                            } else {
                              // Cancel any ongoing debounce
                              if (_debounce?.isActive ?? false) {
                                _debounce!.cancel();
                              }

                              // Create a new debounce for the search API call
                              _debounce =
                                  Timer(const Duration(milliseconds: 500), () {
                                _bloc.add(SearchLibrary(searchText: query));
                              });
                            }
                          },
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: AppColors.primaryColor,
                                    fontSize: 14.sp,
                                  ),
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            prefixIcon: Icon(Icons.search),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 16.h),
                            fillColor: Colors.transparent,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.widgetRadius),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary300Color,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.widgetRadius),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: AppColors.primary300Color,
                                  fontSize: 14.sp,
                                ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 10.h,
                  ),
                  BlocBuilder<LibraryBloc, LibraryState>(
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
                      if (state is GetLibraryLoadingState) {
                        return Expanded(
                          child: Center(
                            child: CustomLoader(
                              color: AppColors.primaryColor,
                              size: 30.w,
                            ),
                          ),
                        );
                      } else if (state is GetLibrarySucceedState) {
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
                              isDownloadItem: false,
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
                              onFavoritesTab: (Folder file, bool) {},
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
