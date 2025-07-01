import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/app_url.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../../../core/utils/global_config.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../injection_container.dart';
import '../../data/models/folder.dart';
import '../../data/models/media_file.dart';
import '../library/bloc/bloc.dart';

class AudioService with WidgetsBindingObserver {
  static final AudioService _instance = AudioService._internal();

  factory AudioService() => _instance;

  late AudioPlayer audioPlayer;
  String? currentAudioId;

  AudioService._internal() {
    audioPlayer = AudioPlayer();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _disposeAudioPlayer();
    }
  }

  void _disposeAudioPlayer() {
    audioPlayer.dispose();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeAudioPlayer();
  }
}

var audioService = AudioService();

@RoutePage()
class AudioPlayerPage extends StatefulWidget {
  final Folder file;
  final bool? isDownloadedFile;

  const AudioPlayerPage({required this.file, Key? key, this.isDownloadedFile})
      : super(key: key);

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late LibraryBloc _bloc;

  late AudioPlayer _audioPlayer;

  bool isPlaying = false;

  double _playbackSpeed = 1.0;

  MediaFile? image;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<LibraryBloc>();

    _audioPlayer = audioService.audioPlayer;

    image = Helper.getPreviewImage(widget.file.mediaFiles!);

    // CHECK if the current audio is different
    if (audioService.currentAudioId != widget.file.id) {
      if (audioService.currentAudioId != null) {
        _stopAndResetPlayer();
      }

      _initializePlayer();

      if (audioService.currentAudioId == null) {
        _startAudioProgressTimer();
      }
      audioService.currentAudioId = widget.file.id;
    }
  }

  Future<void> _stopAndResetPlayer() async {
    await _audioPlayer.stop();
    await _audioPlayer.seek(Duration.zero);
  }

  Future<void> _initializePlayer() async {
    final mp3File = Helper.getFirstMp3(widget.file.mediaFiles!);

    try {
      String localPath = '';
      if (Platform.isAndroid) {
        final directory = await getExternalStorageDirectory();
        final fileName = '${widget.file.name}.${mp3File?.extension}';
        localPath = '${directory?.path}/$fileName';
      } else if (Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = '${widget.file.name}.${mp3File?.extension}';
        localPath = '${directory.path}/$fileName';
      }

      if (widget.isDownloadedFile == true) {
        await _audioPlayer.setAudioSource(
          AudioSource.file(
            localPath,
            tag: MediaItem(
              id: widget.file.id ?? '',
              title: widget.file.name ?? '',
              displayDescription: widget.file.desc ?? '',
            ),
          ),
          preload: true,
        );
      } else {
        print(widget.file.mediaFiles?.length);
        print(widget.file.mediaFiles?[0].id);
        print(widget.file.mediaFiles?[0].extension);
        // print(widget.file.mediaFiles?[1].id);
        // print(widget.file.mediaFiles?[1].extension);
        print(
            '${AppUrl.baseUrl}/media/${widget.file.path}/${widget.file.id}/${mp3File?.id}.${mp3File?.extension}');
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(
                '${AppUrl.baseUrl}/media/${widget.file.path}/${widget.file.id}/${mp3File?.id}.${mp3File?.extension}'),
            headers: {
              'Authorization': 'Bearer ${getIt<GlobalConfig>().token}',
              'api-version': getIt<GlobalConfig>().version,
            },
            tag: MediaItem(
              id: widget.file.id ?? '',
              title: widget.file.name ?? '',
              displayDescription: widget.file.desc ?? '',
            ),
          ),
          preload: true,
        );
      }

      if (widget.file.progress != null && widget.file.progress! > 0) {
        if (widget.file.progress! == 100) {
          _audioPlayer.seek(const Duration(seconds: 0));
        } else {
          _audioPlayer.seek(Duration(
              seconds: ((widget.file.progress! / 100) *
                      _audioPlayer.duration!.inSeconds)
                  .round()));
        }
      }
    } catch (e, stackTrace) {
      print('🔴 Error loading audio: $e');
      print('🧵 Stack trace:\n$stackTrace');
      print('🔴 Error type: ${e.runtimeType}');
    }
  }

  Timer? _audioProgressTimer;
  int? _lastSentAudioSecond;
  int? _lastSentAudioProgress;
  bool _isAudioInitialized = false;

  void _startAudioProgressTimer() {
    const checkInterval = Duration(seconds: 5);

    _audioProgressTimer?.cancel();
    _lastSentAudioSecond = -1;
    _lastSentAudioProgress = -1;
    _isAudioInitialized = false;

    _audioProgressTimer = Timer.periodic(checkInterval, (timer) {
      if (!_audioPlayer.playing) return;

      final totalDuration = _audioPlayer.duration ?? Duration.zero;
      final currentPosition = _audioPlayer.position;

      if (totalDuration.inSeconds == 0) return;

      final currentSecond = currentPosition.inSeconds;

      if (!_isAudioInitialized) {
        _isAudioInitialized = true;
        return;
      }

      if (currentSecond == 0) return;

      // Near end → Send 100%
      if (currentSecond >= totalDuration.inSeconds - 1) {
        if (_lastSentAudioProgress != 100) {
          _lastSentAudioProgress = 100;
          _lastSentAudioSecond = currentSecond;
          _bloc.add(UpdateProgress(
            fileId: audioService.currentAudioId!,
            progress: 100,
          ));
          print('[🔁 Sent] Progress: 100% (Completed)');
        }
        return;
      }

      // Only send last 10-second mark crossed
      final currentMark = (currentSecond ~/ 10) * 10;
      final lastMark = (_lastSentAudioSecond ?? -10) ~/ 10 * 10;

      if (currentMark != lastMark) {
        final progressPercent =
            ((currentMark / totalDuration.inSeconds) * 100).floor();

        if (progressPercent > 0 && progressPercent != _lastSentAudioProgress) {
          _lastSentAudioProgress = progressPercent;
          _lastSentAudioSecond = currentSecond;

          _bloc.add(UpdateProgress(
            fileId: audioService.currentAudioId!,
            progress: progressPercent,
          ));

          print('[🔁 Sent] Progress: $progressPercent% (Mark: $currentMark)');
        } else {
          print('[⏳ Skip] Same progress or invalid percent');
        }
      } else {
        print('[⏳ Skip] Still in same 10s mark ($currentMark)');
      }
    });
  }

  void _stopAudioProgressTimer() {
    _audioProgressTimer?.cancel();
  }

  // int? _lastSentSecond;
  // int? _lastSentProgress;
  // bool _isAudioInitialized = false;
  //
  // void _listenToProgress() {
  //   _audioPlayer.positionStream.listen((position) {
  //     print(position);
  //     if (!_audioPlayer.playing) {
  //       return; // Don't track progress if audio is not playing
  //     }
  //
  //     final totalDuration = _audioPlayer.duration ?? Duration.zero;
  //     final positionInSeconds = position.inSeconds;
  //
  //     // Only proceed if the total duration is valid
  //     if (totalDuration.inSeconds > 0) {
  //       // Skip the initial progress update if the audio is resumed from a saved position
  //       if (!_isAudioInitialized) {
  //         _isAudioInitialized = true;
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
  //           _bloc.add(UpdateProgress(
  //               fileId: audioService.currentAudioId!, progress: 100));
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
  //               fileId: audioService.currentAudioId!,
  //               progress: progressPercent));
  //         }
  //       }
  //     }
  //   });
  // }

  @override
  void dispose() {
    // _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  SizedBox(height: 60.h),
                  if (image != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Image.network(
                        '${AppUrl.baseUrl}/media/${widget.file.path}/${widget.file.id}/${image!.id}.${image!.extension}',
                        height: 280.w,
                        width: 280.w,
                        fit: BoxFit.cover,
                        headers: {
                          'Authorization':
                              'Bearer ${getIt<GlobalConfig>().token}',
                          'api-version': getIt<GlobalConfig>().version,
                        },
                      ),
                    )
                  else
                    Container(
                      height: 280.w,
                      width: 280.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade300,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          Assets.audioIcon,
                          width: 110.w,
                          height: 110.w,
                        ),
                      ),
                    ),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 45.w),
                        Expanded(
                          child: Text(
                            widget.file.name ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              height: 1,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showSpeedSelector();
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                size: 24.w,
                                color: AppColors.primaryColor,
                              ),
                              Text(
                                '${_playbackSpeed}x',
                                style: TextStyle(
                                  fontSize: 13.w,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  StreamBuilder<Duration>(
                    stream: _audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = _audioPlayer.duration ?? Duration.zero;
                      return Column(
                        children: [
                          Slider(
                            activeColor: AppColors.primaryColor,
                            inactiveColor: AppColors.primary300Color,
                            thumbColor: AppColors.primaryColor,
                            min: 0.0,
                            max: duration.inSeconds.toDouble(),
                            value: position.inSeconds
                                .toDouble()
                                .clamp(0, duration.inSeconds.toDouble()),
                            onChanged: (value) {
                              _audioPlayer
                                  .seek(Duration(seconds: value.toInt()));
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(position),
                                  style: const TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  _formatDuration(duration),
                                  style: const TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.replay_10,
                            color: AppColors.primaryColor,
                          ),
                          color: Colors.black,
                          iconSize: 40.w,
                          onPressed: () {
                            final newPosition = _audioPlayer.position -
                                const Duration(seconds: 10);
                            _audioPlayer.seek(newPosition.isNegative
                                ? Duration.zero
                                : newPosition);
                          },
                        ),
                        StreamBuilder<PlayerState>(
                          stream: _audioPlayer.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final playing = playerState?.playing ?? false;

                            return GestureDetector(
                              onTap: () {
                                if (playing) {
                                  _audioPlayer.pause();
                                } else {
                                  _audioPlayer.play();
                                }
                              },
                              child: Container(
                                height: 80.w,
                                width: 80.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryColor,
                                ),
                                child: Icon(
                                  playing
                                      ? Icons.pause
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 50.w,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.forward_10,
                            color: AppColors.primaryColor,
                          ),
                          color: Colors.black,
                          iconSize: 40.w,
                          onPressed: () {
                            final newPosition = _audioPlayer.position +
                                const Duration(seconds: 10);
                            _audioPlayer.seek(newPosition);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Utility function to format duration as mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _showSpeedSelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Icon(
                    Icons.play_circle_outline_rounded,
                    color: AppColors.primaryColor,
                    size: 22.w,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Playback Speed',
                    style: TextStyle(
                      fontSize: 16.w,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            ...[0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0].map((speed) {
              return ListTile(
                title: Row(
                  children: [
                    if (speed == _playbackSpeed) ...[
                      Icon(
                        Icons.check_rounded,
                        size: 22.w,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      '${speed}x',
                      style: TextStyle(
                        fontSize: 13.w,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  setState(() {
                    _playbackSpeed = speed;
                  });
                  await _audioPlayer.setSpeed(speed);
                  Navigator.pop(context);
                },
              );
            }),
            SizedBox(height: 5.h),
          ],
        );
      },
    );
  }
}
