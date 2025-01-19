import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/app_url.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../../../core/utils/global_config.dart';
import '../../../../injection_container.dart';
import '../../data/models/folder.dart';
import '../library/bloc/bloc.dart';

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

  @override
  void initState() {
    super.initState();
    _bloc = getIt<LibraryBloc>();
    _audioPlayer = AudioPlayer();
    _initializePlayer();
    _listenToProgress();
  }

  Future<void> _initializePlayer() async {
    try {
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
        await _audioPlayer.setAudioSource(
          AudioSource.file(
            localPath,
            tag: MediaItem(
              id: widget.file.id ?? '',
              title: widget.file.name ?? '',
            ),
          ),
          preload: true,
        );
      } else {
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(
                '${AppUrl.baseUrl}/media/${widget.file.path}/${widget.file.id}/${widget.file.mediaFiles?[0].id}.${widget.file.mediaFiles?[0].extension}'),
            headers: {
              'Authorization': 'Bearer ${getIt<GlobalConfig>().token}',
              'api-version': getIt<GlobalConfig>().version,
            },
            tag: MediaItem(
              id: widget.file.id ?? '',
              title: widget.file.name ?? '',
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
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  int? _lastSentSecond; // The last second for which progress was sent
  int? _lastSentProgress; // The last progress percentage that was sent
  bool _isAudioInitialized =
      false; // Flag to track if audio has been initialized

  void _listenToProgress() {
    _audioPlayer.positionStream.listen((position) {
      if (!_audioPlayer.playing)
        return; // Don't track progress if audio is not playing

      final totalDuration = _audioPlayer.duration ?? Duration.zero;
      final positionInSeconds = position.inSeconds;

      // Only proceed if the total duration is valid
      if (totalDuration.inSeconds > 0) {
        // Skip the initial progress update if the audio is resumed from a saved position
        if (!_isAudioInitialized) {
          _isAudioInitialized = true;
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
    _audioPlayer.dispose();
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  SizedBox(height: 60.h),
                  Container(
                    height: 280.w,
                    width: 280.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.neutral300Color,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.music_note,
                        size: 140.w,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 40.w),
                        Text(
                          widget.file.name ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.settings,
                            size: 24.w,
                            color: AppColors.primaryColor,
                          ),
                          onPressed: _showSpeedSelector,
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
            SizedBox(height: 10.h),
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
                onTap: () {
                  setState(() {
                    _playbackSpeed = speed;
                  });
                  Navigator.pop(context);
                  // Set playback speed here
                  // _audioPlayer.setSpeed(_playbackSpeed);
                },
              );
            }).toList(),
            SizedBox(height: 10.h),
          ],
        );
      },
    );
  }
}
