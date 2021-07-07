import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class Attributes extends StatelessWidget {
  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credits'),
      ),
      body: DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 1,
          builder: (context, scrollcontroller) {
            return SingleChildScrollView(
              controller: scrollcontroller,
              child: Container(
                child: Column(
                  children: [
                    Text(
                      'I would like to mentions that i use images and icons from this websites that i thanks for:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text('Icons made by Pixel perfect from www.flaticon.com'),
                    Linkify(
                      onOpen: (link) => _launchURL(link.url),
                      text: "https://www.flaticon.com/authors/pixel-perfect",
                    ),
                    Text(
                        'Icons made by Flat Icons perfect from www.flaticon.com'),
                    Linkify(
                      onOpen: (link) => _launchURL(link.url),
                      text: "https://www.flaticon.com/authors/flat-icons",
                    ),
                    Text('Icons made by srip from www.flaticon.com'),
                    Linkify(
                      onOpen: (link) => _launchURL(link.url),
                      text: "https://www.flaticon.com/authors/srip",
                    ),
                    Text('Icons made by Freepik from www.flaticon.com'),
                    Linkify(
                      onOpen: (link) => _launchURL(link.url),
                      text: "https://www.flaticon.com/authors/freepik",
                    ),
                    Text('Icon made by Kiranshastry from www.flaticon.com'),
                    Linkify(
                      onOpen: (link) => _launchURL(link.url),
                      text: "https://www.flaticon.com/authors/kiranshastry",
                    ),
                    Text('Intro Images from undraw.co'),
                    Linkify(
                      onOpen: (link) => _launchURL(link.url),
                      text: "https://undraw.co/illustrations",
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
