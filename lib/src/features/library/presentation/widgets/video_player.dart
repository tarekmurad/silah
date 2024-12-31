import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/app_url.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../../../core/utils/global_config.dart';
import '../../../../injection_container.dart';
import '../../data/models/folder.dart';
import '../library/bloc/bloc.dart';

@RoutePage()
class VideoPlayerPage extends StatefulWidget {
  final Folder file;
  final bool? isDownloadedFile;

  VideoPlayerPage({required this.file, this.isDownloadedFile});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _videoPlayerController;
  late ChewieController _chewieController;
  late LibraryBloc _bloc;

  int? _lastSentSecond; // The last second for which progress was sent
  int? _lastSentProgress; // The last progress percentage that was sent
  bool _isVideoInitialized =
      false; // Flag to track if video has been initialized

  @override
  void initState() {
    super.initState();

    _bloc = getIt<LibraryBloc>();

    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    // final directory = await getExternalStorageDirectory();
    // final fileName =
    //     '${widget.file.name}.${widget.file.mediaFiles?[0].extension}';
    // final localPath = '${directory?.path}/$fileName';

    String localPath = '';
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      final fileName =
          '${widget.file.name}.${widget.file.mediaFiles?[0].extension}';
       localPath = '${directory?.path}/$fileName';
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          '${widget.file.name}.${widget.file.mediaFiles?[0].extension}';
       localPath = '${directory.path}/$fileName';
    }

    if (widget.isDownloadedFile == true) {
      _videoPlayerController = VideoPlayerController.file(File(localPath));
    } else {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(
          '${AppUrl.baseUrl}/media/${widget.file.path}/${widget.file.id}/${widget.file.mediaFiles?[0].id}.${widget.file.mediaFiles?[0].extension}',
        ),
        httpHeaders: {
          'Authorization': 'Bearer ${getIt<GlobalConfig>().token}',
          'api-version': getIt<GlobalConfig>().version,
        },
      );
    }

    await _videoPlayerController!.initialize();
    setState(() {});
    _seekToSavedProgress();
    _listenToProgress();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: true,
      showControls: true,
      allowFullScreen: true,
      allowMuting: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.primary500Color,
        bufferedColor: AppColors.primary300Color,
        backgroundColor: AppColors.neutral300Color,
      ),
    );
  }

  void _seekToSavedProgress() {
    if (widget.file.progress != null && widget.file.progress! > 0) {
      if (widget.file.progress! == 100) {
        _videoPlayerController!.seekTo(const Duration(seconds: 0));
      } else {
        final totalDuration = _videoPlayerController!.value.duration;
        if (totalDuration != null) {
          final seekPosition = Duration(
            seconds: ((widget.file.progress! / 100) * totalDuration.inSeconds)
                .round(),
          );
          _videoPlayerController!.seekTo(seekPosition);
        }
      }
    }
  }

  void _listenToProgress() {
    _videoPlayerController!.addListener(() {
      if (!_videoPlayerController!.value.isPlaying)
        return; // Don't track progress if video is not playing

      final totalDuration = _videoPlayerController!.value.duration;
      final position = _videoPlayerController!.value.position;
      final positionInSeconds = position.inSeconds;

      // Only proceed if the total duration is valid
      if (totalDuration.inSeconds > 0) {
        // Skip the initial progress update if the video is resumed from a saved position
        if (!_isVideoInitialized) {
          _isVideoInitialized = true;
          return; // Prevent the first progress update when the page is opened/resumed
        }

        // 1. Avoid sending 0% if position is at the start (0 seconds)
        if (positionInSeconds == 0) return;

        // 2. Check if the position is at the end of the track
        if (positionInSeconds >= totalDuration.inSeconds - 1) {
          if (_lastSentProgress != 100) {
            _lastSentProgress = 100; // Mark progress as 100%
            _bloc.add(UpdateProgress(fileId: widget.file.id!, progress: 100));
          }
        }
        // 3. Update progress at specific intervals (every 10 seconds)
        else if (positionInSeconds % 10 == 0 &&
            positionInSeconds != _lastSentSecond) {
          _lastSentSecond = positionInSeconds; // Update the last second tracked
          final progressPercent =
              ((positionInSeconds / totalDuration.inSeconds) * 100).floor();

          // Avoid sending duplicate progress updates
          if (progressPercent != _lastSentProgress && progressPercent > 0) {
            _lastSentProgress =
                progressPercent; // Update the last sent progress
            _bloc.add(UpdateProgress(
                fileId: widget.file.id!, progress: progressPercent));
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController!.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Center(
                child: (_videoPlayerController != null && _videoPlayerController!.value.isInitialized &&
                        _chewieController
                            .videoPlayerController.value.isInitialized)
                    ? Chewie(controller: _chewieController)
                    : CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
