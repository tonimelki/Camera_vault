import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TermsAndConditions extends StatefulWidget {
  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    Future<String> loadAsset() async {
      return await rootBundle.loadString('lib/Assets/termsandconditions.txt');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Terms And Conditions'),
      ),
      body: FutureBuilder<String>(
          future: loadAsset(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DraggableScrollableSheet(
                  initialChildSize: 1,
                  minChildSize: 1,
                  expand: true,
                  builder: (context, scrollcontroller) {
                    return SingleChildScrollView(
                      controller: scrollcontroller,
                      child: Container(
                          child: Column(
                        children: [
                          Text(
                            snapshot.data.toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )),
                    );
                  });
            }
            return SpinKitDoubleBounce(
              color: Colors.black38,
            );
          }),
    );
  }
}
