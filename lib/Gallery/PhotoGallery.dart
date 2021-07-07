import 'dart:io';

import 'package:camera_vault/Models/PicturesModel.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class PhotoGallery extends StatefulWidget {
  PhotoGallery({required this.currentindex});
  final int currentindex;

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    int current = widget.currentindex;
    PageController scrollController = PageController(
      initialPage: current,
      keepPage: true,
    );
    return Container(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: buildPhotoViewGallery(current, scrollController, context),
    ));
  }

  PhotoViewGallery buildPhotoViewGallery(
      int current, PageController scrollController, BuildContext context) {
    final images = Provider.of<PicturesModel>(context, listen: true);
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        current = index;

        return PhotoViewGalleryPageOptions(
          imageProvider: FileImage(images.image[index]),
          initialScale: PhotoViewComputedScale.contained * 0.8,
          onTapDown: (context, details, controllerValue) =>
              showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: new BoxDecoration(
                color: Colors.transparent,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.elliptical(52.0, 52),
                  topRight: const Radius.elliptical(52.0, 52),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        final directory =
                            (await getExternalStorageDirectory())!.path;
                        var file = basename(images.image[index].path);
                        File imgFile = File('$directory/$file');
                        File fil =
                            await images.image[index].copy('$directory/$file');
                        print(imgFile);
                        Share.shareFiles([fil.path]);
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        images.deleteImage(index);

                        setState(() {});
                        // // widget.callBack(widget.currentindex);
                      }),
                ],
              ),
            ),
          ),
        );
      },
      pageController: scrollController,
      itemCount: images.image.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null ? 0 : 1,
          ),
        ),
      ),
    );
  }
}
