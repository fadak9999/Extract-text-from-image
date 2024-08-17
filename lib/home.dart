// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_picker/gallery_picker.dart';

import 'package:flutter/services.dart'; //إضافة خاصية النسخ?     خاصة بالودجت clip
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //!
  File? selectedMedia;
  String? extractedText = "";
//!
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "استخراج النصوص من الصور",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal[600],
      ),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Colors.teal[600],
        child: const Icon(
          Icons.add_a_photo,
          color: Colors.white,
        ),
      ),
    );
  }

  void _pickImage() async {
    List<MediaFile>? media = await GalleryPicker.pickMedia(
      context: context,
      singleMedia: true, //! اذا صارت false  راح تاخذ صورة وحده من الاستوديو
    );
    if (media != null && media.isNotEmpty) {
      var data = await media.first.getFile();
      setState(() {
        selectedMedia = data;
      });
    } else {
      print("no image ");
    }
  }

//body
  Widget _buildUI() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _imageView(),
              _extractTextView(),
              //!نسخ
              if (extractedText!.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(//?   نسخ

                        ClipboardData(
                            text: extractedText.toString())); //يحول كلشي الى نص
                    //?
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("تم نسخ النص")),
                    );
                  },
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "نسخ النص",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[600],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _imageView() {
    if (selectedMedia == null) {
      return const Center(
        child: Text(
          "اختر صورة لاستخراج النصوص منها",
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    //
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.file(
            selectedMedia!,
            width: 300,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

//
  Widget _extractTextView() {
    if (selectedMedia == null) {
      return const Center(
        child: Text(
          "لا يوجد نص مستخرج",
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    return FutureBuilder(
      future: _extractText(selectedMedia!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Text(
            "حدث خطأ أثناء استخراج النص",
            style: TextStyle(fontSize: 18, color: Colors.red),
          );
        }
        extractedText = snapshot.data ?? "";
        return Text(
          extractedText!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        );
      },
    );
  }

  ///
  Future<String?> _extractText(File file) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin, //خاصيه بالمكتبه لتحليل الصورة
    );
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    /////
    //text
    String text = recognizedText.text;
    textRecognizer.close();
    return text;
  }
}
