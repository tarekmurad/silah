import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_url.dart';
import '../../../../core/shared_components/widgets/custom_loader.dart';
import '../../../../core/shared_components/widgets/divider.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../../../core/utils/global_config.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/utils.dart';
import '../../../../injection_container.dart';
import '../../data/models/folder.dart';
import '../../data/models/media_file.dart';
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
  MediaFile? image;

  @override
  void initState() {
    super.initState();

    _bloc = getIt<LibraryBloc>();

    image = Helper.getPreviewImage(widget.item.mediaFiles!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        color: Colors.white,
        child: GestureDetector(
          onTap: () {
            widget.onTab(widget.item);
          },
          child: Container(
            color: const Color(0x00000000),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.item.type != 'FOLDER') ...[
                  if (image != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.r),
                        child: CachedNetworkImage(
                          imageUrl:
                              '${AppUrl.baseUrl}/media/${widget.item.path}/${widget.item.id}/${image!.id}.${image!.extension}',
                          width: 78.w,
                          height: 78.w,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Center(
                                child: _getIconForType(widget.item.type)),
                          ),
                          httpHeaders: {
                            'Authorization':
                                'Bearer ${getIt<GlobalConfig>().token}',
                            'api-version': getIt<GlobalConfig>().version,
                          },
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 78.w,
                      height: 78.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(child: _getIconForType(widget.item.type)),
                    ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: SizedBox(
                      height: 78.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Text(
                                    Helper.truncateWithEllipsis(
                                        widget.item.name ?? '',maxLength: 70),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: AppColors.primaryColor,
                                          fontSize: 14.5.sp,
                                          height: 1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    onOptionsClicked(widget.item);
                                  },
                                  child: Icon(
                                    Icons.more_horiz_rounded,
                                    color: AppColors.primaryColor,
                                    size: 24.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.item.desc?.isNotEmpty == true) ...[
                            SizedBox(height: 2.h),
                            Expanded(
                              child: Text(
                                widget.item.desc!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                          Spacer(),
                          if (widget.item.progress! != 0) ...[
                            SizedBox(
                              width: 200.w,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: widget.item.progress! * 0.01,
                                  minHeight: 6.h,
                                  backgroundColor: AppColors.primary200Color,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                          ]

                          /// fav
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Container(
                    width: 78.w,
                    height: 78.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: _getIconForType(widget.item.type),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      widget.item.name ?? '',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  if (widget.item.type == 'FOLDER') ...{
                    const Spacer(),
                    SizedBox(
                      width: 22.w,
                      child: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: AppColors.primaryColor,
                        size: 14.w,
                      ),
                    ),
                  }
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getIconForType(String? type) {
    switch (type) {
      case 'FOLDER':
        return Icon(
          Icons.folder,
          size: 35.w,
          color: AppColors.primaryColor,
        );
      case 'VIDEO':
        return SvgPicture.asset(
          Assets.videoIcon,
          width: 30.w,
          height: 30.w,
        );
      case 'AUDIO':
        return SvgPicture.asset(
          Assets.audioIcon,
          width: 30.w,
          height: 30.w,
        );
      case 'PDF':
        return SvgPicture.asset(
          Assets.pdfIcon,
          width: 30.w,
          height: 30.w,
        );
      default:
        return SvgPicture.asset(
          Assets.pdfIcon,
          width: 22.w,
          height: 22.w,
        );
    }
  }

  void onOptionsClicked(Folder item) {
    showModalBottomSheet(
      context: Navigator.of(context, rootNavigator: true).context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (bottomSheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20.h),
              Text(
                item.name ?? '',
                style: TextStyle(
                  fontSize: 16.w,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 20.h),
              if (widget.item.type != 'FOLDER') ...[
                const DividerWidget(
                  color: AppColors.primary200Color,
                ),
                BlocListener(
                  bloc: _bloc,
                  listenWhen: (previous, current) =>
                      current is InteractFavoritesSucceedState ||
                      current is DownloadFileSucceedState,
                  listener: (context, state) async {
                    if (state is InteractFavoritesSucceedState) {
                      widget.item.isFavorite = !widget.item.isFavorite!;
                      if (widget.item.isFavorite ?? true) {
                        await context.router.maybePop();
                        Future.delayed(Duration(milliseconds: 150), () {
                          showSnackBar(
                            context,
                            "Added to favorites successfully.",
                            AppColors.greenColor,
                          );
                        });
                      } else {
                        await context.router.maybePop();
                        Future.delayed(Duration(milliseconds: 150), () {
                          showSnackBar(
                            context,
                            "Removed from favorites successfully.",
                            AppColors.greenColor,
                          );
                        });
                      }
                    } else if (state is DownloadFileSucceedState) {
                      await context.router.maybePop();
                      Future.delayed(Duration(milliseconds: 150), () {
                        showSnackBar(
                          context,
                          "Download complete.",
                          AppColors.greenColor,
                        );
                      });
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
              SizedBox(height: 30.h),
            ],
          ),
        );
      },
    );
  }
}
