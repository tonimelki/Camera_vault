import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PicturesModel<T> extends ChangeNotifier {
  var image;
  int get img {
    return image;
  }

  set age(var img) {
    return this.image = img;
  }

  loadImages() async {
    print('loading');
    late var images;
    late String pic;
    final Directory path = await getApplicationDocumentsDirectory();
    String deviceLocation = path.path;
    pic = '$deviceLocation/Pictures';
    Directory picPath = Directory(pic);
    print('pic path');
    print(picPath);
    if (picPath.existsSync() == false) {
      new Directory('$deviceLocation/Pictures')
          .create()
          .then((Directory directory) {
        print('Pictures directory has been created');
      });
    }

    images = picPath.listSync();
    List content = picPath.listSync();
    List<File> files = <File>[];
    for (var fileorDir in content) {
      if (fileorDir is File) {
        print("files picture are" + fileorDir.toString());
        files.add(fileorDir);
      } else if (fileorDir is Directory) {
        print(fileorDir.toString());
      }
    }
    image = files;
    notifyListeners();
    print(images);
    return files;
  }

  deleteImage(int index) async {
    print(image[index]);

    image[index].deleteSync(recursive: true);

    loadImages();
    notifyListeners();
  }

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final PickedFile pickedImage =
        (await _picker.getImage(source: ImageSource.gallery))!;
    File tmpFile = File(pickedImage.path);
    final Directory path = await getApplicationDocumentsDirectory();
    var fileName = basename(tmpFile.path);
    extension(tmpFile.path);
    String devicepath = path.path;
    //setState(() => _storedImage = tmpFile);
    Directory pictures = Directory('$devicepath/Pictures');
    print('the picture directory' + pictures.toString());
    if (pictures.existsSync() == false) {
      new Directory('$devicepath/Pictures')
          .create()
          .then((Directory directory) {});
    }

    await tmpFile.copy('$devicepath/Pictures/$fileName');
    loadImages();
    notifyListeners();

    print('Saved Data : ${path.listSync()}');
    //images = path.listSync();
  }
void multiPick(BuildContext context)async{
  final List<AssetEntity> assets = (await AssetPicker.pickAssets(context,requestType: RequestType.image))!;
  final Directory path = await getApplicationDocumentsDirectory();
  String devicepath = path.path;
  //setState(() => _storedImage = tmpFile);
  Directory pictures = Directory('$devicepath/Pictures');
  if (pictures.existsSync() == false) {
    new Directory('$devicepath/Pictures')
        .create()
        .then((Directory directory) {});
  }
  for(int i=0;i<assets.length;i++){
    File? tmp;
    // String ex=extension(assets[i].);
    await assets[i].file.then((value) => tmp = value!);


      var fileName = basename(tmp!.path);

      await tmp!.copy('$devicepath/Pictures/$fileName');

  }
  loadImages();
  notifyListeners();
}
  PicturesModel({this.image});
}
