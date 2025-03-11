import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:io';

class BunnyVideoPlayer extends StatefulWidget {
  final String videoId;

  BunnyVideoPlayer({required this.videoId});

  @override
  _BunnyVideoPlayerState createState() => _BunnyVideoPlayerState();
}

class _BunnyVideoPlayerState extends State<BunnyVideoPlayer> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;
  String? _videoUrl;
  bool _isDownloaded = false;

  @override
  void initState() {
    super.initState();
    _initializeDownloader();
    _loadLastViewedPosition();
    _checkIfVideoIsDownloaded();
  }

  Future<void> _initializeDownloader() async {
    await FlutterDownloader.initialize(debug: true);
  }

  Future<void> _loadLastViewedPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? position = prefs.getInt('lastViewed_${widget.videoId}');
    if (position != null) {
      _controller.seekTo(Duration(seconds: position));
    }
  }

  Future<void> _checkIfVideoIsDownloaded() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${widget.videoId}.mp4';
    if (File(filePath).existsSync()) {
      setState(() {
        _videoUrl = filePath;
        _isDownloaded = true;
        _initializeVideoPlayer(filePath);
      });
    } else {
      fetchVideoUrl(widget.videoId);
    }
  }

  Future<void> fetchVideoUrl(String videoId) async {
    try {
      final Dio dio = Dio();
      final response = await dio.get('https://api.bunny.net/library/$videoId', options: Options(
        headers: {
          'AccessKey': 'YOUR_ACCESS_KEY', // Replace with your Bunny Stream API key
        },
      ));
      final videoUrl = response.data['videoUrl'];
      setState(() {
        _videoUrl = videoUrl;
        _initializeVideoPlayer(videoUrl);
      });
    } catch (e) {
      print('Error fetching video URL: $e');
    }
  }

  void _initializeVideoPlayer(String url) {
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
        _controller.addListener(_saveLastViewedPosition);
      });
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: _controller.value.aspectRatio,
      autoPlay: true,
      looping: false,
    );
  }

  void _saveLastViewedPosition() async {
    if (_controller.value.isPlaying) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('lastViewed_${widget.videoId}', _controller.value.position.inSeconds);
    }
  }

  Future<void> _downloadVideo() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${widget.videoId}.mp4';
    await FlutterDownloader.enqueue(
      url: _videoUrl!,
      savedDir: directory.path,
      fileName: '${widget.videoId}.mp4',
      showNotification: true,
      openFileFromNotification: true,
    );
    setState(() {
      _isDownloaded = true;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_saveLastViewedPosition);
    _controller.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : Center(child: CircularProgressIndicator()),
        if (!_isDownloaded)
          ElevatedButton(
            onPressed: _downloadVideo,
            child: Text('Download for Offline Viewing'),
          ),
      ],
    );
  }
}