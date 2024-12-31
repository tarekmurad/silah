import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/shared_components/widgets/custom_loader.dart';
import '../../../../core/shared_components/widgets/divider.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../../../injection_container.dart';
import '../../data/models/folder.dart';
import '../library/bloc/bloc.dart';

class MediaItemView extends StatefulWidget {
  final Folder item;
  final bool? isDownloadItem;
  final Function(Folder) onTab;
  final Function(Folder) onDownloadTab;
  final Function(Folder, bool) onFavoritesTab;

  const MediaItemView(
      {super.key,
      required this.item,
      this.isDownloadItem,
      required this.onTab,
      required this.onDownloadTab,
      required this.onFavoritesTab});

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
                listener: (context, state) {
                  if (state is InteractFavoritesSucceedState) {
                    widget.item.isFavorite = !widget.item.isFavorite!;
                  }
                },
                child: BlocBuilder<LibraryBloc, LibraryState>(
                  bloc: _bloc,
                  buildWhen: (previous, current) {
                    if (current is InteractFavoritesLoadingState ||
                        current is InteractFavoritesSucceedState ||
                        current is InteractFavoritesFailedState) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        _bloc.add(InteractFavorites(
                            file: widget.item.id!,
                            type: widget.item.isFavorite! ? 'REMOVE' : 'ADD'));
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
                    );
                  },
                ),
              ),
            ],

            /// download
            if (widget.item.type != 'FOLDER' &&
                widget.isDownloadItem != true) ...[
              const DividerWidget(
                color: AppColors.primary200Color,
              ),
              GestureDetector(
                onTap: () {
                  widget.onDownloadTab(widget.item);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
