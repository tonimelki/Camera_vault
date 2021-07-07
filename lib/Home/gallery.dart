import 'package:camera_vault/Home/pictures.dart';
import 'package:camera_vault/Home/settings.dart';
import 'package:camera_vault/Home/videos.dart';
import 'package:camera_vault/Models/PicturesModel.dart';
import 'package:camera_vault/Models/VideosModel.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

late var images;
late var videos;
late String pic;
late String vid;

final picker = ImagePicker();
late TabController _tabController;
final List<Tab> myTabs = <Tab>[
  Tab(
    text: 'Images',
  ),
  Tab(text: 'Videos'),
];

class _GalleryState extends State<Gallery> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: myTabs.length,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void deleteImage(int index) async {
    print(images[index]);
    setState(() {
      images[index].deleteSync(recursive: true);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //int counter = 1;
    final image = Provider.of<PicturesModel>(context, listen: true);
    final video = Provider.of<VideosModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery"),
        elevation: 2,
        actions: [
          Image.asset('lib/Assets/premium.png'),
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () async {
              var statuses = await Permission.storage.request();

              if (statuses.isGranted) {
                image.multiPick(context);
              }
            },
          ),
          IconButton(
              icon: Icon(Icons.video_call),
              onPressed: () async {
                var statuses = await Permission.storage.request();
                if (statuses.isGranted) {
                  video.multiPick(context);
                }
              }),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new Settings()),
                );
              }),
        ],
        bottom: TabBar(
          isScrollable: false,
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: new TabBarView(controller: _tabController, children: <Widget>[
        Pictures(),
        Videos(),
      ]),
    );
  }
}
