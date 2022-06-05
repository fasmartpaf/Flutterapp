import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutterapp/Firebase_Auth/LogIn_Page.dart';
import 'package:flutterapp/Firebase_Auth/Models_Class.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController Passwordcontroller = TextEditingController();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  var _deviceData = '';
  String _address = '';
  String _name = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
      FlutterBluetoothSerial.instance.name.then((name) {
        setState(() {
          _name = name!;
        });
      });
    });
  }

  Future<void> initPlatformState() async {
    var deviceData = '';

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  _readAndroidBuildData(AndroidDeviceInfo build) {
    return build.device;
  }

  _readIosDeviceInfo(IosDeviceInfo data) {
    return data.identifierForVendor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 200, left: 45, right: 45),
        child: Column(
          children: [
            Center(
              child: Text(
                _name,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Text('$_deviceData'),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: emailcontroller,
              decoration: const InputDecoration(
                  fillColor: Color(0xffDCE6FF),
                  filled: true,
                  hintText: 'Email',
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              controller: Passwordcontroller,
              decoration: const InputDecoration(
                  fillColor: Color(0xffDCE6FF),
                  filled: true,
                  hintText: 'Passwort',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(10),
              ),
              child: FlatButton(
              onPressed: () {
                  Firebases().SignUp(
                      emailcontroller.text, Passwordcontroller.text, context);
                  Firebases().AddData(emailcontroller.text,
                      Passwordcontroller.text, _name.toString());
                },
                child: const Center(
                    child: Text(
                  'Register',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 20),
              child: Row(
                children: [
                  const Text(
                    "Do hast ein Konton",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LogInPage()));
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.pink,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
