import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/folder.dart';
import 'media_item_view.dart';

class MediaListView extends StatefulWidget {
  final bool? isDownloadItem;
  final List<Folder> items;
  final Function(Folder) onTab;

  const MediaListView({
    Key? key,
    this.isDownloadItem,
    required this.items,
    required this.onTab,
  }) : super(key: key);

  @override
  _MediaListViewState createState() => _MediaListViewState();
}

class _MediaListViewState extends State<MediaListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return MediaItemView(
          item: item,
          onTab: widget.onTab,
        );
      },
    );
  }
}