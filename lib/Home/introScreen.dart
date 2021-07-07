import 'package:camera_vault/Home/home.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() => new IntroScreenState();
}

final _formKey = GlobalKey<FormState>();

//------------------ Custom config ------------------
class IntroScreenState extends State<IntroScreen> {
  //List<Slide> slides = new List();
  bool donebtn = false;
  bool stop = false;
  bool next = true;
  late int password;
  final _storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
  }

  void deleteall() async {
    final storage = new FlutterSecureStorage();
    await storage.deleteAll();
  }

  void savePassword(int password) async {
    await _storage.write(key: 'Password', value: password.toString());
  }

  Widget pin(BuildContext context, donbtn) {
    bool inRange = false;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 10 / 50,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: const InputDecoration(
              hintText: 'Please Enter Your Pin from 1 to 4 ',
            ),
            validator: (value) {
              for (int i = 0; i < value!.length; i++) {
                if (value[i] == '1' ||
                    value[i] == '2' ||
                    value[i] == '3' ||
                    value[i] == '4') {
                  setState(() {
                    inRange = true;
                  });
                } else {
                  setState(() {
                    inRange = false;
                  });
                  break;
                }
              }
              if (value.isEmpty) {
                return 'Please enter some text';
              } else if (value.length < 4 || value.length > 4) {
                return 'Please enter a 4 numbers (From 1-4)';
              } else if (inRange == false) {
                return 'Please just enter from 1-4 numbers';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                password = int.parse(value!);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    donebtn = true;
                    stop = false;
                    next = true;
                    _formKey.currentState!.save();
                    savePassword(password);
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.success,
                      text: "Your Done!",
                    );
                  });

                  // Process data.
                }
              },
              child: Container(
                decoration: const BoxDecoration(),
                padding: const EdgeInsets.all(10.0),
                child: const Text('Sumbit', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    if (donebtn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Home()),
      );
    }
  }

  void _onNext(int value) {
    if (value == 2) {
      stop = true;
      next = false;
      setState(() {});
    }
  }

  Widget _buildImage(String assetName) {
    return Image.asset(
      'lib/Assets/$assetName.png',
      fit: BoxFit.contain,
      height: 600,
    );
  }

  Widget firstpage() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/Assets/gallery.png'),
              fit: BoxFit.contain)),
      child: Column(
        children: [
          Text(
            "Basically, You Will Choose A Pin, And the pin will be entered by swiping on specific direction on the camera. \nPlease Follow this tutorial to see How it Works.",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 100 * 70,
          ),
          // Image.asset('lib/Assets/robot.png'),
        ],
      ),
    );
  }

  Widget _finalStep() {
    return Column(
      children: [
        Text(
          'Now You Can Try It ! \n Swipe on the Camera According to the password you chose. ',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 5,
        ),
        Image.asset('lib/Assets/FinalStep.png'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      titlePadding: EdgeInsets.only(top: 30),
      descriptionPadding: EdgeInsets.only(top: 0, bottom: 0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.only(top: 0),
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          // bodyWidget: _buildImage('Camera'),
          title: "Welcome To Camera Vault",
          decoration: pageDecoration,
          bodyWidget: firstpage(),
        ),
        PageViewModel(
          title: "How It Works ?",
          bodyWidget: _buildImage('SwipeTutorial'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Please Enter Your Pin ",
          bodyWidget: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/Assets/password.png'),
                    fit: BoxFit.contain)),
            child: Column(children: [
              SizedBox(height: MediaQuery.of(context).size.height / 100 * 40),
              pin(context, donebtn),
            ]),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Finalyy,Your Done ! ",
          bodyWidget: _finalStep(),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),

      //onSkip: () => null, // You can override onSkip callback
      freeze: stop,
      onChange: (value) => _onNext(value),
      showSkipButton: true,
      showNextButton: next,
      skipFlex: 1,
      nextFlex: 1,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
