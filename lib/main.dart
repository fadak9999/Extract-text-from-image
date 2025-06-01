import 'package:flutter/material.dart';

//import 'package:flutter_application_5/one.dart';
import 'package:flutter_application_5/tts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
// todo  add permission for android and ios 

        //?  for  Android  Manifest
    // <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    // <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
    // <uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
    ///////////////////////////////
    //!build.gradle داخل ملف app
        // compileSdk = 34
        //  minSdk = 21
        // targetSdk = 34



    //! for  ios >>Runner >> info.plist
    //?جوة ذني الزرك 
    //?<string>????</string>
	//? <key>CFBundleVersion</key>
	//? <string>$(FLUTTER_BUILD_NUMBER)</string>
    // <key>NSPhotoLibraryUsageDescription</key>
    // <string>Privacy - Photo Library Usage Description</string>
    // <key>NSMotionUsageDescription</key>
    // <string>Motion usage description</string>
    // <key>NSPhotoLibraryAddUsageDescription</key>
    // <string>NSPhotoLibraryAddUsageDescription</string>
    //////////////
    
  //     google_mlkit_text_recognition: ^0.13.0
  // gallery_picker: ^0.5.1