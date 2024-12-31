import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/placeholder_lines.dart';

import '../../styles/app_colors.dart';

class TextPlaceHolderWidget extends StatefulWidget {
  const TextPlaceHolderWidget({Key? key}) : super(key: key);

  @override
  _TextPlaceHolderWidgetState createState() => _TextPlaceHolderWidgetState();
}

class _TextPlaceHolderWidgetState extends State<TextPlaceHolderWidget> {
  @override
  Widget build(BuildContext context) {
    return PlaceholderLines(
      count: 2,
      animate: true,
      minWidth: 0.3,
      maxWidth: 0.6,
      color: AppColors.grayColor.withOpacity(0.5),
      animationOverlayColor: AppColors.grayColor.withOpacity(1),
    );
  }
}
