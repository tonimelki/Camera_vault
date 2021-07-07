import 'dart:io';
import 'package:camera_vault/Models/VideosModel.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

class VideoGallery extends StatefulWidget {
  VideoGallery({required this.video, required this.index});
  final File video;
  final int index;
  @override
  _VideoGalleryState createState() => _VideoGalleryState();
}

class _VideoGalleryState extends State<VideoGallery>
    with AutomaticKeepAliveClientMixin {
  late ChewieController _chewieController;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: VideoPlayerController.file(widget.video),
        aspectRatio: 16 / 14,
        autoInitialize: true,
        autoPlay: true,
        looping: true,
        errorBuilder: (context, errorMessage) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final video = Provider.of<VideosModel>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () async {
                  final directory = (await getExternalStorageDirectory())!.path;
                  var file = basename(widget.video.path);
                  File imgFile = File('$directory/$file');
                  File fil = await widget.video.copy('$directory/$file');

                  print(imgFile);
                  Share.shareFiles([fil.path]);
                }),
            IconButton(
                icon: Icon(Icons.delete_forever_outlined),
                onPressed: () {
                  video.deleteVideo(widget.index);
                  Navigator.pop(context);

                  setState(() {});
                }),
          ],
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.black,
        body: Chewie(
          controller: _chewieController,
        ));
  }
}
