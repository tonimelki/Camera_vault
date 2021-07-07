import 'package:camera_vault/Gallery/PhotoGallery.dart';
import 'package:camera_vault/Models/PicturesModel.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';

class Pictures extends StatefulWidget {
  @override
  _PicturesState createState() => _PicturesState();
}

class _PicturesState extends State<Pictures>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  //late BannerAd banner;
  bool loaded = false;
  int fakeLoading = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScrollController scrollController = ScrollController(
      initialScrollOffset: 0, // or whatever offset you wish
      keepScrollOffset: true,
    );
    final image = Provider.of<PicturesModel>(context, listen: true);
    print(image.image);
    //var imgs = Provider.of<PicturesModel>(context).image;

    return Container(
        decoration: image.image.length == 0
            ? BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/Assets/emptycontainer.png'),
                    fit: BoxFit.contain))
            : null,
        width: MediaQuery.of(context).size.width * 50,
        height: MediaQuery.of(context).size.height * 50,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  child: FutureBuilder(
                      future: Future.delayed(Duration(seconds: fakeLoading)),
                      builder: (context, snapshot) => snapshot
                                  .connectionState ==
                              ConnectionState.done
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: image.image.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (BuildContext context, int index) {
                                fakeLoading = 0;

                                try {
                                  return GestureDetector(
                                      onLongPress: () async {
                                        return showDialog<void>(
                                          context: context,
                                          barrierDismissible:
                                              false, // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Delete the Image.'),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text('are you sure?'),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Yes'),
                                                  onPressed: () {
                                                    image.deleteImage(index);
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('No'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
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
                                                  new PhotoGallery(
                                                    currentindex: index,
                                                  )),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 250.0,
                                          height: 250.0,
                                          alignment: Alignment.center,
                                          decoration: new BoxDecoration(
                                              image: DecorationImage(
                                            image:
                                                FileImage((image.image[index])),
                                            fit: BoxFit.cover,
                                          )),
                                        ),
                                      ));
                                } catch (e) {
                                  return Text(
                                      'Error Loading Image. free some space or contact us for more info.');
                                }
                              },
                              controller: scrollController,
                            )
                          : SpinKitCircle(
                              color: Colors.black38,
                            ))),
            ],
          ),
        ));
  }
}
