import 'dart:typed_data';

import 'package:camera_vault/Gallery/VideoGallery.dart';
import 'package:camera_vault/Models/VideosModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late VideoPlayerController _controller;
  late InterstitialAd myInterstitial;
  int fakeLoading=1;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  void dispose() {
    _controller.dispose();
    myInterstitial.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final video = Provider.of<VideosModel>(context, listen: true);

    ScrollController scrollController = ScrollController(
      initialScrollOffset: 0, // or whatever offset you wish
      keepScrollOffset: true,
    );

    return Container(
        decoration: video.video.length == 0
            ? BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/Assets/emptycontainer.png'),
                    fit: BoxFit.contain))
            : null,
        width: MediaQuery.of(context).size.width * 50,
        height: MediaQuery.of(context).size.height * 50,
        child: FutureBuilder(
          future: Future.delayed(Duration(seconds: fakeLoading)),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.done
                  ? GridView.builder(
                      itemCount: video.video.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        //count = index;
fakeLoading=0;
                        try {
                          Future<Uint8List?> thumbnail() async {
                            return await VideoThumbnail.thumbnailData(
                              video: video.video[index].path,
                              imageFormat: ImageFormat.JPEG,
                              maxWidth:
                                  128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                              quality: 25,
                            );
                          }

                          return FutureBuilder<Uint8List?>(
                              future: thumbnail(),
                              builder: (context,
                                  AsyncSnapshot<Uint8List?> snapshot) {
                                if (snapshot.hasData) {
                                  return GestureDetector(
                                      onLongPress: () async {
                                        return showDialog<void>(
                                          context: context,
                                          barrierDismissible:
                                              false, // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Delete the video'),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text('Are you sure ?'),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Yes'),
                                                  onPressed: () {
                                                    video.deleteVideo(index);
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('No'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    myInterstitial.show();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new VideoGallery(
                                                    video: video.video[index],
                                                    index: index,
                                                  )),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          //color: Colors.black,
                                          width: 250.0,
                                          height: 250.0,
                                          alignment: Alignment.center,

                                          child: Image.memory(snapshot.data!),
                                        ),
                                      ));
                                }
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        //color: Colors.black,
                                        width: 250.0,
                                        height: 250.0,
                                        alignment: Alignment.center,

                                        child: SpinKitCircle(
                                          color: Colors.black38,
                                        ),
                                      ),
                                    );
                                  default:
                                    return Container(
                                      child: Text('Error Loading...'),
                                    );
                                }
                              });
                        } catch (e) {
                          print("no file exist");
                        }
                        return Container();
                      },
                      controller: scrollController,
                    )
                  : SpinKitCircle(
                      color: Colors.black38,
                    ),
        ));
  }
}
