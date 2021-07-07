import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:camera_vault/Wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'Models/PicturesModel.dart';
import 'Models/VideosModel.dart';

late final savedThemeMode;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final initFuture = MobileAds.instance.initialize();
  //final adState = AdState(initFuture);
  savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

late PicturesModel picturesModel;
late VideosModel videosModel;

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    picturesModel = PicturesModel();
    videosModel = VideosModel();
    picturesModel.loadImages();
    videosModel.loadVideos();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<PicturesModel>.value(value: picturesModel),
          ChangeNotifierProvider<VideosModel>.value(value: videosModel),
        ],
        child: AdaptiveTheme(
          light: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.red,
            accentColor: Colors.amber,
          ),
          dark: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.red,
            accentColor: Colors.amber,
          ),
          initial: savedThemeMode ?? AdaptiveThemeMode.light,
          builder: (theme, darkTheme) => OKToast(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Adaptive Theme',
              theme: theme,
              darkTheme: darkTheme,
              home: Wrapper(),
            ),
          ),
        ));
  }
}
