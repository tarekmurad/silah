import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/folder.dart';
import 'media_item_view.dart';

class MediaListView extends StatelessWidget {
  final bool? isDownloadItem;
  final List<Folder> items;
  final Function(Folder) onTab;
  final Function(Folder) onDownloadTab;
  final Function(Folder, bool) onFavoritesTab;

  MediaListView(
      {this.isDownloadItem,
      required this.items,
      required this.onTab,
      required this.onDownloadTab,
      required this.onFavoritesTab});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemBuilder: (context, index) {
        final item = items[index];
        return MediaItemView(
          item: item,
          onTab: (Folder) {
            onTab(Folder);
          },
          onDownloadTab: (Folder) {
            onDownloadTab(Folder);
          },
          onFavoritesTab: (Folder, bool) {
            onFavoritesTab(Folder, bool);
          },
        );
      },
    );
  }
}
