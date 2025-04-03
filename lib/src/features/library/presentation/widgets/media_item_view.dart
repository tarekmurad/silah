import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/shared_components/widgets/custom_loader.dart';
import '../../../../core/shared_components/widgets/divider.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../../../core/utils/utils.dart';
import '../../../../injection_container.dart';
import '../../data/models/folder.dart';
import '../library/bloc/bloc.dart';

class MediaItemView extends StatefulWidget {
  final Folder item;
  final bool? isDownloadItem;
  final Function(Folder) onTab;

  const MediaItemView({
    super.key,
    required this.item,
    this.isDownloadItem,
    required this.onTab,
  });

  @override
  State<MediaItemView> createState() => _MediaItemViewState();
}

class _MediaItemViewState extends State<MediaItemView> {
  late LibraryBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = getIt<LibraryBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                widget.onTab(widget.item);
              },
              child: Container(
                color: const Color(0x00000000),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _getIconForType(widget.item.type),
                          SizedBox(width: 12.w),
                          Text(
                            widget.item.name ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          if (widget.item.type == 'FOLDER') ...{
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: 14.w,
                            )
                          }
                        ],
                      ),
                      if (widget.item.desc?.isNotEmpty == true) ...[
                        SizedBox(height: 12.h),
                        Text(
                          widget.item.desc!,
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            /// fav
            if (widget.item.type != 'FOLDER') ...[
              const DividerWidget(
                color: AppColors.primary200Color,
              ),
              BlocListener(
                bloc: _bloc,
                listenWhen: (previous, current) =>
                    current is InteractFavoritesSucceedState ||
                    current is DownloadFileSucceedState,
                listener: (context, state) {
                  if (state is InteractFavoritesSucceedState) {
                    widget.item.isFavorite = !widget.item.isFavorite!;
                    if (widget.item.isFavorite ?? true) {
                      showSnackBar(
                        context,
                        "Added to favorites successfully.",
                        AppColors.greenColor,
                      );
                    } else {
                      showSnackBar(
                        context,
                        "Removed from favorites successfully.",
                        AppColors.greenColor,
                      );
                    }
                  } else if (state is DownloadFileSucceedState) {
                    showSnackBar(
                      context,
                      "Download complete.",
                      AppColors.greenColor,
                    );
                  }
                },
                child: BlocBuilder<LibraryBloc, LibraryState>(
                  bloc: _bloc,
                  buildWhen: (previous, current) {
                    if (current is InteractFavoritesLoadingState ||
                        current is InteractFavoritesSucceedState ||
                        current is InteractFavoritesFailedState ||
                        current is DownloadFileLoadingState ||
                        current is DownloadFileSucceedState ||
                        current is DownloadFileFailedState) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  builder: (context, state) {
                    print("state");
                    print(state);
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _bloc.add(InteractFavorites(
                                file: widget.item.id!,
                                type: widget.item.isFavorite!
                                    ? 'REMOVE'
                                    : 'ADD'));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.favorite_rounded,
                                      size: 22.w,
                                      color: AppColors.primaryColor,
                                    ),
                                    SizedBox(width: 12.w),
                                    if (widget.item.isFavorite != true)
                                      Text(
                                        "Add to Favorites",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: AppColors.primaryColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      )
                                    else
                                      Text(
                                        "Remove from Favorites",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: AppColors.primaryColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                  ],
                                ),
                                if (state is InteractFavoritesLoadingState)
                                  CustomLoader(
                                    color: AppColors.primaryColor,
                                    size: 20.w,
                                  )
                              ],
                            ),
                          ),
                        ),
                        if (widget.item.type != 'FOLDER' &&
                            widget.isDownloadItem != true) ...[
                          const DividerWidget(
                            color: AppColors.primary200Color,
                          ),
                          GestureDetector(
                            onTap: () async {
                              // widget.onDownloadTab(widget.item);
                              if (await Permission.storage
                                      .request()
                                      .isGranted ||
                                  await Permission
                                      .manageExternalStorage.isGranted ||
                                  await Permission.mediaLibrary
                                      .request()
                                      .isGranted) {
                                _bloc.add(DownloadFile(file: widget.item));
                              } else {
                                print('Permission denied');
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.download,
                                        size: 22.w,
                                        color: AppColors.primaryColor,
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        "Download",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: AppColors.primaryColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      if (state is DownloadFileLoadingState)
                                        CustomLoader(
                                          color: AppColors.primaryColor,
                                          size: 18.w,
                                        ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        '${(widget.item.mediaFiles![0].sizeMB! + 1).toInt()} MB',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: AppColors.primaryColor,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]
                      ],
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getIconForType(String? type) {
    switch (type) {
      case 'FOLDER':
        return Icon(
          Icons.folder,
          size: 22.w,
          color: AppColors.primaryColor,
        );
      case 'VIDEO':
        return SvgPicture.asset(
          Assets.videoIcon,
          width: 22.w,
          height: 22.w,
        );
      case 'AUDIO':
        return SvgPicture.asset(
          Assets.audioIcon,
          width: 22.w,
          height: 22.w,
        );
      case 'PDF':
        return SvgPicture.asset(
          Assets.pdfIcon,
          width: 22.w,
          height: 22.w,
        );
      default:
        return SvgPicture.asset(
          Assets.pdfIcon,
          width: 22.w,
          height: 22.w,
        );
    }
  }
}
