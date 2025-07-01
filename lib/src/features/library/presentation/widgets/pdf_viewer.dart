import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../core/constants/app_url.dart';
import '../../../../core/shared_components/widgets/custom_loader.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../../../core/utils/global_config.dart';
import '../../../../injection_container.dart';
import '../../data/models/folder.dart';
import '../library/bloc/bloc.dart';

@RoutePage()
class PdfViewerPage extends StatefulWidget {
  final Folder file;
  final bool? isDownloadedFile;

  const PdfViewerPage({super.key, required this.file, this.isDownloadedFile});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late PdfViewerController _pdfViewerController;
  bool isLoading = true;
  int currentPage = 0;
  int totalPages = 0;
  Timer? _debounceTimer;
  String? localPath;

  late LibraryBloc _bloc;

  Folder? newFile;

  @override
  void initState() {
    super.initState();

    newFile = widget.file;
    _bloc = getIt<LibraryBloc>();

    _pdfViewerController = PdfViewerController();

    // _bloc.add(GetLibrary(parentId: widget.file.id));

    if (widget.isDownloadedFile == true) {
      _initializeViewer();
    }
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  Future<void> _initializeViewer() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      final fileName = '${newFile?.name}.${newFile?.mediaFiles?[0].extension}';
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        localPath = '${directory?.path}/$fileName';
      });
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = '${newFile?.name}.${newFile?.mediaFiles?[0].extension}';
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        localPath = '${directory.path}/$fileName';
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
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
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
                          widget.file.name ?? '',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ),
                    ),
                    SizedBox(width: 50.w),
                  ],
                ),
              ),
            ],
          ),
          BlocListener<LibraryBloc, LibraryState>(
            bloc: _bloc,
            listener: (context, state) async {
              if (state is GetLibrarySucceedState) {
                // newFile = state.folders[0];
                // _initializePlayer();
              }
            },
            child: Expanded(
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
                      const SizedBox()
                  else
                    SfPdfViewer.network(
                      '${AppUrl.baseUrl}/media/${newFile?.path}/${newFile?.id}/${newFile?.mediaFiles?[0].id}.${newFile?.mediaFiles?[0].extension}',
                      headers: {
                        'Authorization':
                            'Bearer ${getIt<GlobalConfig>().token}',
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

                        currentPage =
                            ((newFile!.progress! / 100) * totalPages).round();
                        _pdfViewerController.jumpToPage(currentPage - 1);
                      },
                      onPageChanged: (PdfPageChangedDetails details) {
                        setState(() {
                          currentPage = details.newPageNumber;
                        });

                        _debounceTimer?.cancel();

                        _debounceTimer = Timer(const Duration(seconds: 3), () {
                          final progress =
                              ((currentPage / totalPages) * 100).round();
                          _bloc.add(UpdateProgress(
                              fileId: newFile!.id!, progress: progress));
                        });
                      },
                    ),
                  if (isLoading)
                    const Center(
                      child: CustomLoader(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
