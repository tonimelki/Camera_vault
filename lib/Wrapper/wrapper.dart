import 'package:camera_vault/Home/home.dart';
import 'package:camera_vault/Home/introScreen.dart';
import 'package:camera_vault/Shared/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _storage = FlutterSecureStorage();

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Future<String> readPassword() async {
    String key = (await _storage.read(key: 'Password'))!;
    return key;
  }

  @override
  void initState() {
    super.initState();
    readPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
          future: readPassword(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                print('loading');
                return Loading();
              default:
                if (snapshot.hasData) {
                  print('hasdata');
                  return Home();
                } else {
                  print('nodata');
                  return IntroScreen();
                }
            }
          }),
    );
  }
}
