import 'dart:io';
import 'package:camera_vault/Home/gallery.dart';
import 'package:oktoast/oktoast.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _storage = FlutterSecureStorage();
  late File val;
  String key = '';
  String password = '';
  bool condition = true;
  bool permissionRequest = false;
  @override
  void initState() {
    super.initState();
    createDirectories();
    readPassword();
    permission();
  }

  void readPassword() async {
    key = (await _storage.read(key: 'Password'))!;
    print('the password we find is :$key');
    setState(() {});
  }

  createDirectories() async {
    final Directory path = await getApplicationDocumentsDirectory();
    String devicepath = path.path;
    Directory videos = Directory('$devicepath/Videos');
    if (videos.existsSync() == false) {
      await new Directory('$devicepath/Videos').create()
          // The created directory is returned as a Future.
          .then((Directory directory) {
        print(directory.path + "has created");
      });
    }
    Directory pictures = Directory('$devicepath/Pictures');
    print('Pictures directory: $pictures');
    if (pictures.existsSync() == false) {
      await new Directory('$devicepath/Pictures').create()
          // The created directory is returned as a Future.
          .then((Directory directory) {
        print(directory.path + "has created");
      });
    }
  }

  void permission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    print(statuses[Permission.location]);
    if (statuses[Permission.camera]!.isGranted) {
      setState(() {
        permissionRequest = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
              onHorizontalDragStart: (DragStartDetails details) {
                condition = true;
                print("Starting...");
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                print("Horizontal");
                print(details);
                print(password);
                print('condition is $condition');
                if (condition == true) {
                  if (details.delta.dx > 0) {
                    password += '2';
                    showToast(
                      "2",
                      duration: Duration(milliseconds: 700),
                      position: ToastPosition.bottom,
                      backgroundColor: Colors.grey.withOpacity(0.8),
                      radius: 13.0,
                      textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                    );

                    print(password);
                  } else if (details.delta.dx < 0) {
                    password += '4';
                    showToast(
                      "4",
                      duration: Duration(milliseconds: 700),
                      position: ToastPosition.bottom,
                      backgroundColor: Colors.grey.withOpacity(0.8),
                      radius: 13.0,
                      textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                    );

                    print(password);
                  }
                  if (password == key) {
                    showToast(
                      "Access Granted",
                      duration: Duration(milliseconds: 700),
                      position: ToastPosition.bottom,
                      backgroundColor: Colors.grey.withOpacity(0.8),
                      radius: 13.0,
                      textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                    );
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new Gallery()),
                    );
                    password = '';
                  }
                  if (password.length == key.length) {
                    if (password == key) {
                      showToast(
                        "Access Granted",
                        duration: Duration(milliseconds: 700),
                        position: ToastPosition.bottom,
                        backgroundColor: Colors.grey.withOpacity(0.8),
                        radius: 13.0,
                        textStyle:
                            TextStyle(fontSize: 18.0, color: Colors.white),
                      );
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) => new Gallery()),
                      );
                      password = '';
                    } else {
                      password = '';
                      showToast(
                        "Wrong Password Try Again",
                        duration: Duration(milliseconds: 700),
                        position: ToastPosition.bottom,
                        backgroundColor: Colors.grey.withOpacity(0.8),
                        radius: 13.0,
                        textStyle:
                            TextStyle(fontSize: 18.0, color: Colors.white),
                      );
                    }
                  }
                }
                condition = false;
              },
              onVerticalDragStart: (DragStartDetails details) {
                condition = true;
                print('Starting..');
              },
              onVerticalDragUpdate: (DragUpdateDetails details) {
                print("vertical");
                print(details);
                print(password);
                if (condition == true) {
                  if (details.delta.dy > 0) {
                    password += '3';
                    showToast(
                      "3",
                      duration: Duration(milliseconds: 700),
                      position: ToastPosition.bottom,
                      backgroundColor: Colors.grey.withOpacity(0.8),
                      radius: 13.0,
                      textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                    );
                    print(password);
                  } else if (details.delta.dy < 0) {
                    password += '1';
                    showToast(
                      "1",
                      duration: Duration(milliseconds: 700),
                      position: ToastPosition.bottom,
                      backgroundColor: Colors.grey.withOpacity(0.8),
                      radius: 13.0,
                      textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                    );
                    print(password);
                  }
                }
                if (password == key) {
                  showToast(
                    "Access Granted",
                    duration: Duration(milliseconds: 700),
                    position: ToastPosition.bottom,
                    backgroundColor: Colors.grey.withOpacity(0.8),
                    radius: 13.0,
                    textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                  );
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Gallery()),
                  );
                  password = '';
                }
                if (password.length == key.length) {
                  if (password == key) {
                    showToast(
                      "Access Granted",
                      duration: Duration(milliseconds: 700),
                      position: ToastPosition.bottom,
                      backgroundColor: Colors.grey.withOpacity(0.8),
                      radius: 13.0,
                      textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                    );
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new Gallery()),
                    );
                    password = '';
                  } else {
                    password = '';
                    showToast(
                      "Wrong Password Try Again",
                      duration: Duration(milliseconds: 700),
                      position: ToastPosition.bottom,
                      backgroundColor: Colors.grey.withOpacity(0.8),
                      radius: 13.0,
                      textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                    );
                  }
                }
                condition = false;
              },
              child: Scaffold(
                body: permissionRequest == true
                    ? CameraCamera(
                        enableZoom: true,
                        onFile: (file) async {
                          if (await Permission.storage.request().isGranted) {
                            final result =
                                await ImageGallerySaver.saveFile(file.path);
                            print(result);
                            Fluttertoast.showToast(
                                msg: "Picture Captured Check your Gallery",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        })
                    : Container(
                        color: Colors.black,
                      ),
              ))),
    );
  }
}
