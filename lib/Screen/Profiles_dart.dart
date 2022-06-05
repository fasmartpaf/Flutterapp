import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutterapp/Firebase_Auth/Models_Class.dart';

import '../Firebase_Auth/LogIn_Page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class Profiles extends StatefulWidget {

  @override
  _ProfilesState createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  var _deviceData = '';
  String _address = '';
  String _name = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initPlatformState();
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

  // Future<void> initPlatformState() async {
  //   var deviceData = '';
  //
  //   try {
  //     if (Platform.isAndroid) {
  //       deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
  //     } else if (Platform.isIOS) {
  //       deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
  //     }
  //   } on PlatformException {
  //     deviceData = 'Failed to get platform version.';
  //   }
  //
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _deviceData = deviceData;
  //   });
  // }

  _readAndroidBuildData(AndroidDeviceInfo build) {
    return build.device;
  }

  _readIosDeviceInfo(IosDeviceInfo data) {
    return data.identifierForVendor;
  }
  TextEditingController _vornoma=TextEditingController();
  TextEditingController _alert=TextEditingController();
  TextEditingController _device=TextEditingController();
  PickedFile? imageFile;

  uploadPic() async {
    FirebaseStorage _storage = await FirebaseStorage.instance;

    var reference = _storage.ref().child("profile_pictures/");

    var uploadTask = reference.putFile;(cropImag(imageFile!));
    return uploadTask;
  }
 cropImag(PickedFile imagefile){
   Future<CroppedFile?> croppedFile = ImageCropper().cropImage(
     compressFormat: ImageCompressFormat.png,
     maxHeight: 30,
     maxWidth: 49,
     compressQuality: 30,
     sourcePath: imagefile.path,
     aspectRatioPresets: [
       CropAspectRatioPreset.square,
       CropAspectRatioPreset.ratio3x2,
       CropAspectRatioPreset.original,
       CropAspectRatioPreset.ratio4x3,
       CropAspectRatioPreset.ratio16x9
     ],
     uiSettings: [
       AndroidUiSettings(
           toolbarTitle: 'Cropper',
           toolbarColor: Colors.deepOrange,
           toolbarWidgetColor: Colors.white,
           initAspectRatio: CropAspectRatioPreset.original,
           lockAspectRatio: false),
       IOSUiSettings(
         title: 'Cropper',
       ),
     ],
   );

 }
  Firebases firebases=Firebases();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 80,left: 10),
        child: ListView(
          children: [
        StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Profil').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              _vornoma.text=data['name'];
              _alert.text=data['Age'];
              return ListTile(

              );
            }).toList(),
          );
        },
      ),
           Padding(
             padding: const EdgeInsets.only(left: 170),
             child: Row(
               children: [
                 Text('profil',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                 SizedBox(width: 70,),
              FlatButton(onPressed: (){
                Firebases().signOutse();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                LogInPage()
                ));
              }, child:Icon(Icons.logout,size: 30,)
              )
               ],
             ),
           ),
            SizedBox(height: 20,),
           Stack(
             children: [
               Center(
                 child: FlatButton(onPressed: (){
                   showChoiceDialog(context);
                 },
                 child: CircleAvatar(
                    
                     radius: 70,
                     backgroundColor: Colors.grey.shade300,
                   child: (imageFile == null)
                       ? const Icon(Icons.person_add_alt_outlined)
                       : Container(
                       width: 100,
                       decoration: BoxDecoration(
                         shape: BoxShape.circle
                           ),
                       child: Image.file(File(imageFile!.path),fit: BoxFit.cover,)
    )
               ),)),
               Positioned(
                   bottom: 5,
                   left: -2,
                   right: -100,
                   child:CircleAvatar(
                     backgroundColor: Colors.white,
                     foregroundColor: Colors.grey,
                     radius: 20,
                     child:  FlatButton(
                       color: Colors.pink,
                       highlightColor: Colors.grey.shade800,
                       onPressed: () {
                       },
                       splashColor: Colors.black,
                       child: const Icon(Icons.edit, color: Colors.white,),
                       padding: EdgeInsets.all(1.0),
                       shape: const CircleBorder(
                       ),
                     ),
                   )
               ),

             ],
           ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 30,right: 35),
              child: TextFormField(
                controller: _vornoma,
                decoration: InputDecoration(
                    fillColor: Color(0xffDCE6FF),
                    filled: true,
                    hintText: 'Vorname',
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 30,right: 35),
              child: TextFormField(
                controller: _alert,
                decoration: InputDecoration(
                    fillColor: Color(0xffDCE6FF),
                    filled: true,
                    hintText: 'Alert',
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 30,right: 35),
              child: TextFormField(
                decoration: InputDecoration(
                    fillColor: Color(0xffDCE6FF),
                    filled: true,
                    hintText: 'Instagram',
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 30,right: 35),
              child: TextFormField(
                decoration: InputDecoration(
                    fillColor: Color(0xffDCE6FF),
                    filled: true,
                    hintText: 'UUID',
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30,top: 10,right: 30),
              child: Container(
                height: 50,
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FlatButton(
                  onPressed: () {
                    Center(
                      child: Text(
                        _name,
                        style:
                        const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),);

                    Text('$_deviceData');
                     Firebases().Profiledata(_alert.text, _vornoma.text,_device.text,_name );
                  },
                  child: const Center(
                      child: Text(
                        'update',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void openCamera(BuildContext context)  async{
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera ,
    );
    setState(() {
      imageFile=pickedFile;
    });
    Navigator.pop(context);
  }
  void _openGallery(BuildContext context) async{
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery ,
    );
    setState(() {
      imageFile=pickedFile;
    });
    if(imageFile!=null){
      setState(() {
        cropImag(imageFile!);

      });
    }
    Navigator.pop(context);
  }
  void openGallery(BuildContext context) async{
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery ,
    );
    setState(() {
      imageFile=pickedFile;
    });
    cropImag(imageFile!);
    Navigator.pop(context);
  }
  showChoiceDialog(BuildContext context) {
    return showDialog(context: context,builder: (BuildContext context){

      return AlertDialog(
        title: Text("Choose option",style: TextStyle(color: Colors.blue),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  _openGallery(context);
                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.blue,),
              ),

              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  openCamera(context);
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.blue,),
              ),
            ],
          ),
        ),);
    });
  }
}
