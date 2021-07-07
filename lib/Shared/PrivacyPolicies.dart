import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProvacyPolicies extends StatefulWidget {
  @override
  _ProvacyPoliciesState createState() => _ProvacyPoliciesState();
}

class _ProvacyPoliciesState extends State<ProvacyPolicies> {
  @override
  Widget build(BuildContext context) {
    Future<String> loadAsset() async {
      return await rootBundle.loadString('lib/Assets/privacypolicy.txt');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy And Policy'),
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
            return Scaffold(
                body: SpinKitCircle(
              color: Colors.black38,
            ));
          }),
    );
  }
}
