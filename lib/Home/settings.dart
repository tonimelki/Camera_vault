import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:camera_vault/Shared/Attributes.dart';
import 'package:camera_vault/Shared/PrivacyPolicies.dart';
import 'package:camera_vault/Shared/TermsAndConditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool donebtn = false;
  final _storage = FlutterSecureStorage();
  void savePassword(int password) async {
    await _storage.write(key: 'Password', value: password.toString());
  }

  @override
  Widget build(BuildContext context) {
    bool donebtn = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/Assets/settings.png'),
                fit: BoxFit.contain)),
        alignment: Alignment.center,
        child: SettingsList(
          sections: [
            SettingsSection(
              title: 'App Settings',
              tiles: [
                SettingsTile(
                  title: 'Password',
                  subtitle: 'Change your password',
                  leading: Icon(Icons.security_rounded),
                  onPressed: (context) async {
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "Change Password",
                      desc: "Enter your new password below",
                      content: pin(context, donebtn),
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          color: Color.fromRGBO(0, 179, 134, 1.0),
                        ),
                      ],
                    ).show();
                  },
                ),
                SettingsTile.switchTile(
                  title: 'Dark Mode',
                  leading: Icon(Icons.mode_edit),
                  switchValue: Theme.of(context).brightness == Brightness.dark
                      ? true
                      : false,
                  onToggle: (bool value) {
                    //AdaptiveTheme.of(context).toggleThemeMode();
                    value == true
                        ? AdaptiveTheme.of(context).setDark()
                        : AdaptiveTheme.of(context).setLight();
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Lisences and policies',
              tiles: [
                SettingsTile(
                  title: 'Lisences',
                  leading: Icon(Icons.policy_outlined),
                  onPressed: (context) => showLicensePage(
                      context: context,
                      applicationIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset('lib/Assets/InApp3.png')),
                      ),
                      applicationName: 'Camera Vault',
                      applicationVersion: '0.0.1',
                      applicationLegalese: 'Copyright 2021'),
                ),
                SettingsTile(
                  title: 'Terms & Conditions',
                  leading: Icon(Icons.privacy_tip_outlined),
                  onPressed: (context) => Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new TermsAndConditions()),
                  ),
                ),
                SettingsTile(
                  title: 'Privacy & Policy',
                  leading: Icon(Icons.privacy_tip),
                  onPressed: (context) => Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new ProvacyPolicies()),
                  ),
                ),
                SettingsTile(
                  title: 'Credits',
                  leading: Icon(Icons.attribution_outlined),
                  onPressed: (context) => Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Attributes()),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void saveBrightness(bool value) async {
    String mode;
    if (value == true) {
      mode = 'dark';
    } else {
      mode = 'light';
    }
    await _storage.write(key: 'Brightness', value: mode);
  }

  Widget pin(BuildContext context, donbtn) {
    bool inRange = false;
    late int password;
    final _formKey = GlobalKey<FormState>();
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
                  print(value[i]);
                  print('true');
                  setState(() {
                    inRange = true;
                  });
                } else {
                  print(value[i]);
                  print('false');
                  setState(() {
                    inRange = false;
                  });
                  break;
                }
              }
              print('inrange is $inRange');
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
                print(password);
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
                    print(donebtn);
                    _formKey.currentState!.save();
                    savePassword(password);
                    Navigator.pop(context);
                    var alertStyle = AlertStyle(
                      animationType: AnimationType.fromTop,
                      isCloseButton: false,
                      isOverlayTapDismiss: false,
                      descStyle: TextStyle(fontWeight: FontWeight.bold),
                      descTextAlign: TextAlign.start,
                      animationDuration: Duration(milliseconds: 400),
                      alertBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                        side: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      titleStyle: TextStyle(
                        color: Colors.red,
                      ),
                      alertAlignment: Alignment.topCenter,
                    );
                    Alert(
                      context: context,
                      style: alertStyle,
                      type: AlertType.success,
                      title: "Done",
                      desc: "Please restart you app to take effect.",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Cool",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          color: Color.fromRGBO(0, 179, 134, 1.0),
                          radius: BorderRadius.circular(0.0),
                        ),
                      ],
                    ).show();
                  });

                  // Process data.

                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
