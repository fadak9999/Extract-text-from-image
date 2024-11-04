
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class One extends StatefulWidget {
  const One({super.key});

  @override
  State<One> createState() => _OneState();
}

class _OneState extends State<One> {
  String _extractedText = '';
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageAndRecognizeText() async {
    final permissionStatus = await Permission.photos.request();
    if (!permissionStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء منح إذن الوصول للمعرض')),
      );
      return;
    }

    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        _selectedImage = File(imageFile.path);
        _extractedText = 'جارٍ استخراج النص...';
      });

      final inputImage = InputImage.fromFilePath(imageFile.path);
      final textRecognizer = TextRecognizer();

      try {
        final RecognizedText recognizedText =
            await textRecognizer.processImage(inputImage);
        setState(() {
          if (recognizedText.text.trim().isEmpty) {
            _extractedText = 'لا يوجد نص في هذه الصورة';
          } else {
            _extractedText = recognizedText.text;
          }
        });
      } catch (e) {
        setState(() {
          _extractedText = 'حدث خطأ أثناء استخراج النص';
        });
      } finally {
        textRecognizer.close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        title: const Text(
          'استخراج النص من الصورة',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple[200]!),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.purple,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImageAndRecognizeText,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[800],
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
              child: const Text(
                'اختر صورة واستخرج النص',
                style: TextStyle(
                    color: Color.fromARGB(255, 215, 214, 215),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width *
                    0.8, // عرض بنسبة 80% من عرض الشاشة
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.purple[200]!, width: 1),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _extractedText,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.purple[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
