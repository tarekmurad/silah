import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:chewie/chewie.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/app_url.dart';
import '../../../../core/shared_components/widgets/custom_loader.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../../../core/utils/global_config.dart';
import '../../../../core/utils/helpers.dart';
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
  late LibraryBloc _bloc;

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  // BetterPlayerDataSource? betterPlayerDataSource;
  // BetterPlayerController? betterPlayerController;
  // GlobalKey _betterPlayerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _bloc = getIt<LibraryBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeVideoPlayer();
    });
  }

  Future<void> _initializeVideoPlayer() async {
    final mp4File = Helper.getFirstMp4(widget.file.mediaFiles!);
    final getFirstSrt = Helper.getFirstSrt(widget.file.mediaFiles!);

    String localPath = '';
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      final fileName = '${widget.file.name}.${mp4File?.extension}';
      localPath = '${directory?.path}/$fileName';
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = '${widget.file.name}.${mp4File?.extension}';
      localPath = '${directory.path}/$fileName';
    }

    if (widget.isDownloadedFile == true) {
      videoPlayerController = VideoPlayerController.file(File(localPath));
      // betterPlayerDataSource = BetterPlayerDataSource.file(localPath);
    } else {
      print(widget.file.mediaFiles![0].extension);
      print(widget.file.mediaFiles![0].id);
      print(getIt<GlobalConfig>().version);
      print('Bearer ${getIt<GlobalConfig>().token}');
      print(
          '${AppUrl.baseUrl}/media/${widget.file.path}/${widget.file.id}/${mp4File?.id}.${mp4File?.extension}');
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(
            '${AppUrl.baseUrl}/media/${widget.file.path}/${widget.file.id}/${mp4File?.id}.${mp4File?.extension}'),
        // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
        httpHeaders: {
          'Authorization': 'Bearer ${getIt<GlobalConfig>().token}',
          'api-version': getIt<GlobalConfig>().version,
        },
      );
      // betterPlayerDataSource = BetterPlayerDataSource(
      //   BetterPlayerDataSourceType.network,
      //   '${AppUrl.baseUrl}/media/${widget.file.path}/${widget.file.id}/${mp4File?.id}.${mp4File?.extension}',
      //   headers: {
      //     'Authorization': 'Bearer ${getIt<GlobalConfig>().token}',
      //     'api-version': getIt<GlobalConfig>().version,
      //   },
      //   subtitles: getFirstSrt != null
      //       ? BetterPlayerSubtitlesSource.single(
      //           type: BetterPlayerSubtitlesSourceType.network,
      //           url:
      //               '${AppUrl.baseUrl}/media/${widget.file.path}/${widget.file.id}/${getFirstSrt.id}.${getFirstSrt.extension}',
      //           headers: {
      //             'Authorization': 'Bearer ${getIt<GlobalConfig>().token}',
      //             'api-version': getIt<GlobalConfig>().version,
      //           },
      //         )
      //       : null,
      // );
    }

    await videoPlayerController!.initialize();

    setState(() {});

    _seekToSavedProgress();
    _startProgressTimer();
    // _listenToProgress();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      looping: true,
      aspectRatio: videoPlayerController!.value.aspectRatio,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    // betterPlayerController = BetterPlayerController(
    //     const BetterPlayerConfiguration(
    //       autoPlay: true,
    //       looping: true,
    //       fit: BoxFit.cover,
    //       autoDetectFullscreenDeviceOrientation: true,
    //       autoDetectFullscreenAspectRatio: true,
    //       deviceOrientationsAfterFullScreen: [
    //         DeviceOrientation.portraitUp,
    //         DeviceOrientation.landscapeLeft,
    //         DeviceOrientation.portraitDown,
    //         DeviceOrientation.landscapeRight
    //       ],
    //     ),
    //     betterPlayerDataSource: betterPlayerDataSource);
    //
    // betterPlayerController?.addEventsListener(_onBetterPlayerEvent);
    //
    // if (await betterPlayerController!.isPictureInPictureSupported()) {
    //   betterPlayerController!.enablePictureInPicture(_betterPlayerKey);
    // }

    // setState(() {});
    // _seekToSavedProgress();
    // _listenToProgress();
  }

  // void _onBetterPlayerEvent(BetterPlayerEvent event) {
  //   if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
  //     final duration =
  //         betterPlayerController!.videoPlayerController?.value.duration;
  //
  //     print("Video initialized. Duration: $duration");
  //     _seekToSavedProgress();
  //     _listenToProgress();
  //   }
  // }

  Future<void> _seekToSavedProgress() async {
    if (widget.file.progress != null && widget.file.progress! > 0) {
      if (widget.file.progress! == 100) {
        videoPlayerController?.seekTo(const Duration(seconds: 0));
      } else {
        final totalDuration = videoPlayerController?.value.duration;
        if (totalDuration != null) {
          final seekPosition = Duration(
            seconds: ((widget.file.progress! / 100) * totalDuration.inSeconds)
                .round(),
          );
          await videoPlayerController?.seekTo(seekPosition);
          videoPlayerController?.play();
        }
      }
    }
  }

  // void _listenToProgress() {
  //   videoPlayerController!.addListener(() {
  //     if (!videoPlayerController!.value.isPlaying) {
  //       return; // Don't track progress if video is not playing
  //     }
  //
  //     final totalDuration = videoPlayerController!.value.duration;
  //     final position = videoPlayerController!.value.position;
  //     final positionInSeconds = position!.inSeconds;
  //
  //     // Only proceed if the total duration is valid
  //     if (totalDuration!.inSeconds > 0) {
  //       // Skip the initial progress update if the video is resumed from a saved position
  //       if (!_isVideoInitialized) {
  //         _isVideoInitialized = true;
  //         return; // Prevent the first progress update when the page is opened/resumed
  //       }
  //
  //       // 1. Avoid sending 0% if position is at the start (0 seconds)
  //       if (positionInSeconds == 0) return;
  //
  //       // 2. Check if the position is at the end of the track
  //       if (positionInSeconds >= totalDuration.inSeconds - 1) {
  //         if (_lastSentProgress != 100) {
  //           _lastSentProgress = 100; // Mark progress as 100%
  //           _bloc.add(UpdateProgress(fileId: widget.file.id!, progress: 100));
  //         }
  //       }
  //       // 3. Update progress at specific intervals (every 10 seconds)
  //       else if (positionInSeconds % 10 == 0 &&
  //           positionInSeconds != _lastSentSecond) {
  //         _lastSentSecond = positionInSeconds; // Update the last second tracked
  //         final progressPercent =
  //             ((positionInSeconds / totalDuration.inSeconds) * 100).floor();
  //
  //         // Avoid sending duplicate progress updates
  //         if (progressPercent != _lastSentProgress && progressPercent > 0) {
  //           _lastSentProgress =
  //               progressPercent; // Update the last sent progress
  //           _bloc.add(UpdateProgress(
  //               fileId: widget.file.id!, progress: progressPercent));
  //         }
  //       }
  //     }
  //   });
  // }

  Timer? _progressTimer;
  int _lastSentMark = -10; // track last 10-second mark sent
  int _lastSentProgress = -1;
  bool _isVideoInitialized = false;

  void _startProgressTimer() {
    _progressTimer?.cancel();

    _progressTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final controller = videoPlayerController;
      if (controller == null ||
          !controller.value.isInitialized ||
          !controller.value.isPlaying) {
        return;
      }

      final totalSeconds = controller.value.duration.inSeconds;
      final currentSecond = controller.value.position.inSeconds;

      if (totalSeconds == 0) return;

      if (!_isVideoInitialized) {
        _isVideoInitialized = true;
        return;
      }

      if (currentSecond == 0) return;

      // Near the end
      if (currentSecond >= totalSeconds - 1) {
        if (_lastSentProgress != 100) {
          _lastSentProgress = 100;
          _lastSentMark = currentSecond;
          _bloc.add(UpdateProgress(fileId: widget.file.id!, progress: 100));
        }
        return;
      }

      // Calculate current 10-second mark (floor to nearest 10)
      final currentMark = (currentSecond ~/ 10) * 10;

      // If the mark changed (either forward or backward), send update
      if (currentMark != _lastSentMark) {
        final progressPercent = ((currentMark / totalSeconds) * 100).floor();

        if (progressPercent > 0 && progressPercent != _lastSentProgress) {
          _lastSentProgress = progressPercent;
          _lastSentMark = currentMark;
          _bloc.add(UpdateProgress(
              fileId: widget.file.id!, progress: progressPercent));
        }
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                            Helper.truncateWithEllipsis(widget.file.name ?? '',
                                maxLength: 40),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: AppColors.whiteColor,
                                  fontSize: 17.sp,
                                  height: 1,
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
            Expanded(
              child: Center(
                child: videoPlayerController != null &&
                        videoPlayerController!.value.isInitialized &&
                        chewieController != null &&
                        chewieController!
                            .videoPlayerController.value.isInitialized
                    ? Chewie(controller: chewieController!)
                    : const CustomLoader(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
