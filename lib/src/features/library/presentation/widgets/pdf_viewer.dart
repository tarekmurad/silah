import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../core/constants/app_url.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../../../core/utils/global_config.dart';
import '../../../../injection_container.dart';
import '../../data/models/folder.dart';

@RoutePage()
class PdfViewerPage extends StatefulWidget {
  final Folder file;
  final bool? isDownloadedFile;

  const PdfViewerPage({super.key, required this.file, this.isDownloadedFile});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool isLoading = true;
  int currentPage = 0;
  int totalPages = 0;
  String? localPath;

  @override
  void initState() {
    super.initState();

    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    String localPath = '';
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      final fileName =
          '${widget.file.name}.${widget.file.mediaFiles?[0].extension}';
      setState(() {
        localPath = '${directory?.path}/$fileName';
      });
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          '${widget.file.name}.${widget.file.mediaFiles?[0].extension}';
      setState(() {
        localPath = '${directory?.path}/$fileName';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 105.h,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
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
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    SizedBox(width: 20.w),
                    IconButton(
                      color: AppColors.whiteColor,
                      icon: const Icon(Icons.arrow_back_ios),
                      iconSize: 18.w,
                      onPressed: () {
                        context.router.maybePop();
                      },
                    ),
                    Text(
                      widget.file.name ?? '',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.whiteColor,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                if (widget.isDownloadedFile == true)
                  if (localPath != null)
                    SfPdfViewer.file(
                      File(localPath!),
                      controller: _pdfViewerController,
                      canShowScrollHead: true,
                      canShowScrollStatus: true,
                      enableDoubleTapZooming: true,
                      onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                        setState(() {
                          isLoading = false;
                          totalPages = details.document.pages.count;
                        });
                      },
                      onPageChanged: (PdfPageChangedDetails details) {
                        setState(() {
                          currentPage = details.newPageNumber;
                        });
                      },
                    )
                  else
                    SizedBox()
                else
                  SfPdfViewer.network(
                    '${AppUrl.baseUrl}/media/${widget.file.path}/${widget.file.id}/${widget.file.mediaFiles?[0].id}.${widget.file.mediaFiles?[0].extension}',
                    headers: {
                      'Authorization': 'Bearer ${getIt<GlobalConfig>().token}',
                      'api-version': getIt<GlobalConfig>().version,
                    },
                    controller: _pdfViewerController,
                    canShowScrollHead: true,
                    canShowScrollStatus: true,
                    enableDoubleTapZooming: true,
                    onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                      setState(() {
                        isLoading = false;
                        totalPages = details.document.pages.count;
                      });
                    },
                    onPageChanged: (PdfPageChangedDetails details) {
                      setState(() {
                        currentPage = details.newPageNumber;
                      });
                    },
                  ),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          // Container(
          //   padding: EdgeInsets.symmetric(vertical: 10.h),
          //   decoration: const BoxDecoration(
          //     color: AppColors.primaryColor,
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(20),
          //       topRight: Radius.circular(20),
          //     ),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       IconButton(
          //         icon: Icon(Icons.first_page, color: AppColors.whiteColor),
          //         onPressed: () {
          //           _pdfViewerController.jumpToPage(1);
          //         },
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.chevron_left, color: AppColors.whiteColor),
          //         onPressed: () {
          //           final prevPage = currentPage > 1 ? currentPage - 1 : 1;
          //           _pdfViewerController.jumpToPage(prevPage);
          //         },
          //       ),
          //       Column(
          //         children: [
          //           Text(
          //             "Page $currentPage of $totalPages",
          //             style: TextStyle(
          //               color: AppColors.whiteColor,
          //               fontSize: 14.sp,
          //             ),
          //           ),
          //           SizedBox(height: 4.h),
          //           Container(
          //             height: 4.h,
          //             width: 100.w,
          //             decoration: BoxDecoration(
          //               color: AppColors.whiteColor.withOpacity(0.3),
          //               borderRadius: BorderRadius.circular(2),
          //             ),
          //             child: FractionallySizedBox(
          //               widthFactor: (currentPage / totalPages).clamp(0.0, 1.0),
          //               alignment: Alignment.centerLeft,
          //               child: Container(
          //                 color: AppColors.whiteColor,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.chevron_right, color: AppColors.whiteColor),
          //         onPressed: () {
          //           final nextPage =
          //               currentPage < totalPages ? currentPage + 1 : totalPages;
          //           _pdfViewerController.jumpToPage(nextPage);
          //         },
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.last_page, color: AppColors.whiteColor),
          //         onPressed: () {
          //           _pdfViewerController.jumpToPage(totalPages);
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
