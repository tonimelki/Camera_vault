import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class VideosModel extends ChangeNotifier {
  var video;
  VideosModel({this.video});
  get vid {
    return video;
  }

  set vid(var vid) {
    return this.video = vid;
  }

  printer() {
    print(video);
  }

  loadVideos() async {
    print('loading');
    //late var videos;
    late String vid;
    final Directory path = await getApplicationDocumentsDirectory();
    String devicepath = path.path;
    vid = devicepath + '/Videos';
    var vids = Directory(vid);
    if (vids.existsSync() == false) {
      new Directory('$devicepath/Videos').create().then((Directory directory) {
        print('Videos directory has been created');
      });
    }
    List content = vids.listSync();
    List<File> files = <File>[];
    for (var fileorDir in content) {
      if (fileorDir is File) {
        // print(fileorDir.toString());
        files.add(fileorDir);
      } else if (fileorDir is Directory) {
        // print(fileorDir.toString());
      }
    }
    // videos = vids.listSync();
    VideosModel videosModel = VideosModel();
    videosModel.video = files;
    video = files;
    notifyListeners();
    print('loaded');
    return video;
  }

  deleteVideo(int index) async {
    video[index].deleteSync(recursive: true);
    notifyListeners();
    loadVideos();
  }

  void pickVideo() async {
    final ImagePicker _picker = ImagePicker();
    final PickedFile pickedImage =
        (await _picker.getVideo(source: ImageSource.gallery))!;
    File tmpFile = File(pickedImage.path);
    final Directory path = await getApplicationDocumentsDirectory();
    var fileName = basename(tmpFile.path);
    extension(tmpFile.path);
    String devicepath = path.path;
    // _storedImage = tmpFile;
    Directory videos = Directory('$devicepath/Videos');
    print('videos directory: $videos');
    if (videos.existsSync() == false) {
      new Directory('$devicepath/Videos')
          .create()
          .then((Directory directory) {});
    }
    await tmpFile.copy('$devicepath/Videos/$fileName');

    loadVideos();
    notifyListeners();
    print('Saved Data : ${path.listSync()}');
    //images = path.listSync();
  }
  void multiPick(BuildContext context)async{
    final List<AssetEntity> assets = (await AssetPicker.pickAssets(context,requestType: RequestType.video))!;
    final Directory path = await getApplicationDocumentsDirectory();
    String devicepath = path.path;
    //setState(() => _storedImage = tmpFile);
    Directory pictures = Directory('$devicepath/Videos');
    if (pictures.existsSync() == false) {
      new Directory('$devicepath/Videos')
          .create()
          .then((Directory directory) {});
    }
    for(int i=0;i<assets.length;i++){
      File? tmp;
      await assets[i].file.then((value) => tmp=value!);
      var fileName = basename(tmp!.path);
      //extension(tmpFile.path);
      await tmp!.copy('$devicepath/Videos/$fileName');

    }
    loadVideos();
    notifyListeners();
  }
}
