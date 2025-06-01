// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';

// import 'package:permission_handler/permission_handler.dart';

// class TextToSpeech extends StatefulWidget {
//   const TextToSpeech({super.key});

//   @override
//   State<TextToSpeech> createState() => _TextToSpeechState();
// }

// class _TextToSpeechState extends State<TextToSpeech> {
//   final FlutterTts _flutterTts = FlutterTts();
//   final TextEditingController _textController = TextEditingController();

//   List<Map> _voices = [];
//   Map? _currentVoice;
//   bool _isDownloading = false;

//   @override
//   void initState() {
//     super.initState();
//     initTTS();
//     _requestPermissions();
//   }

//   // طلب الصلاحيات للتخزين
//   Future<void> _requestPermissions() async {
//     await Permission.storage.request();
//     await Permission.manageExternalStorage.request();
//   }

//   void initTTS() async {
//     _flutterTts.setProgressHandler((text, start, end, word) {
//       setState(() {});
//     });

//     // إعداد معالج انتهاء التحدث
//     _flutterTts.setCompletionHandler(() {
//       print("Speech completed");
//     });

//     try {
//       var data = await _flutterTts.getVoices;
//       if (data.isNotEmpty) {
//         List<Map> voices = List<Map>.from(data);
//         setState(() {
//           _voices = voices
//               .where((voice) =>
//                   voice["name"].contains("en") || voice["name"].contains("ar"))
//               .toList();
//           if (_voices.isNotEmpty) {
//             _currentVoice = _voices.first; // تحديد الصوت الأول عند تحميل الأصوات
//             setVoice(_currentVoice!);
//           } else {
//             print("No voices available");
//           }
//         });
//       } else {
//         print("No voices returned");
//       }
//     } catch (e) {
//       print("Error getting voices: $e");
//     }
//   }

//   void setVoice(Map voice) {
//     _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
//   }

//   Future<void> _speakText() async {
//     if (_textController.text.isNotEmpty && _currentVoice != null) {
//       try {
//         await _flutterTts.speak(_textController.text);
//       } catch (e) {
//         print("Error: $e");
//       }
//     }
//   }

//   // دالة تنزيل الصوت
//   Future<void> _downloadAudio() async {
//     if (_textController.text.isEmpty || _currentVoice == null) {
//       _showSnackBar("الرجاء إدخال نص واختيار صوت أولاً");
//       return;
//     }

//     setState(() {
//       _isDownloading = true;
//     });

//     try {
//       // الحصول على مجلد التنزيلات
//       Directory? downloadsDirectory;
//       if (Platform.isAndroid) {
//         downloadsDirectory = Directory('/storage/emulated/0/Download');
//         if (!await downloadsDirectory.exists()) {
//           // إذا لم يكن متاحاً، استخدم المجلد الخارجي
//           downloadsDirectory = await getExternalStorageDirectory();
//         }
//       } else {
//         downloadsDirectory = await getApplicationDocumentsDirectory();
//       }

//       if (downloadsDirectory != null) {
//         // إنشاء اسم فريد للملف
//         String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//         String fileName = 'tts_audio_$timestamp.wav';
//         String filePath = '${downloadsDirectory.path}/$fileName';

//         // تحويل النص إلى ملف صوتي
//         await _flutterTts.synthesizeToFile(_textController.text, filePath);

//         _showSnackBar("تم حفظ الملف الصوتي في: $filePath");
//       } else {
//         _showSnackBar("خطأ في الوصول إلى مجلد التنزيلات");
//       }
//     } catch (e) {
//       print("Error downloading audio: $e");
//       _showSnackBar("حدث خطأ أثناء تنزيل الملف الصوتي");
//     } finally {
//       setState(() {
//         _isDownloading = false;
//       });
//     }
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: const Color.fromARGB(255, 94, 1, 137),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 82, 0, 109),
//         title: const Text(
//           "text_to_speech",
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const Text(
//                   "Enter", // استخدام المفتاح Enter
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Color.fromARGB(255, 115, 1, 180),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: _textController,
//                   maxLines: 3,
//                   style: const TextStyle(fontSize: 18),
//                   decoration: InputDecoration(
//                     hintText: "Type something...",
//                     filled: true,
//                     fillColor: const Color.fromARGB(255, 132, 132, 132),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       borderSide: const BorderSide(
//                         color: Color.fromARGB(255, 89, 2, 136),
//                         width: 2.0,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // زر التشغيل
//                 ElevatedButton(
//                   onPressed: _speakText,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromARGB(255, 94, 1, 137),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   child: const Text(
//                     "speak", // استخدام المفتاح Enter
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Color.fromARGB(255, 223, 223, 223),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 12),

//                 // زر التنزيل
//                 ElevatedButton.icon(
//                   onPressed: _isDownloading ? null : _downloadAudio,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromARGB(255, 0, 128, 0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   icon: _isDownloading
//                     ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : const Icon(
//                         Icons.download,
//                         color: Colors.white,
//                       ),
//                   label: Text(
//                     _isDownloading ? "جاري التنزيل..." : "تنزيل الصوت",
//                     style: const TextStyle(
//                       fontSize: 18,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),
//                 _speakerSelector(),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _speakerSelector() {
//     return DropdownButton<Map>(
//       dropdownColor: const Color.fromARGB(255, 116, 2, 153),
//       iconEnabledColor: const Color.fromARGB(255, 192, 2, 255),
//       value: _currentVoice,
//       isExpanded: true,
//       items: _voices
//           .map(
//             (voice) => DropdownMenuItem(
//               value: voice,
//               child: Text(
//                 voice["name"],
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ),
//           )
//           .toList(),
//       onChanged: (value) {
//         setState(() {
//           _currentVoice = value;
//           setVoice(_currentVoice!);
//         });
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _textController.dispose();
//     _flutterTts.stop();
//     super.dispose();
//   }
// }

//todo
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// class TextToSpeech extends StatefulWidget {
//   const TextToSpeech({super.key});

//   @override
//   State<TextToSpeech> createState() => _TextToSpeechState();
// }

// class _TextToSpeechState extends State<TextToSpeech>
//     with TickerProviderStateMixin {
//   final FlutterTts _flutterTts = FlutterTts();
//   final TextEditingController _textController = TextEditingController();

//   List<Map> _voices = [];
//   Map? _currentVoice;
//   bool _isDownloading = false;
//   bool _isSpeaking = false;

//   double _opacity = 0;

//   late AnimationController _buttonController;
//   late Animation<double> _buttonScale;

//   late AnimationController _dropdownController;
//   late Animation<double> _dropdownScale;

//   late AnimationController _iconController;
//   late Animation<double> _iconAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _buttonController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 100),
//       lowerBound: 0.0,
//       upperBound: 0.1,
//     );
//     _buttonScale =
//         Tween<double>(begin: 1.0, end: 0.95).animate(_buttonController);

//     _dropdownController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 150),
//       lowerBound: 0.95,
//       upperBound: 1.0,
//     );
//     _dropdownScale = Tween<double>(begin: 1.0, end: 0.95).animate(
//       CurvedAnimation(parent: _dropdownController, curve: Curves.easeInOut),
//     );

//     // انيميشن الأيقونة (مثلاً تذبذب بسيط)
//     _iconController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);

//     _iconAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
//       CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
//     );

//     _flutterTts.setStartHandler(() {
//       setState(() {
//         _isSpeaking = true;
//       });
//     });

//     _flutterTts.setCompletionHandler(() {
//       setState(() {
//         _isSpeaking = false;
//       });
//     });

//     _flutterTts.setErrorHandler((message) {
//       setState(() {
//         _isSpeaking = false;
//       });
//     });

//     initTTS();
//     _requestPermissions();

//     Future.delayed(const Duration(milliseconds: 300), () {
//       setState(() {
//         _opacity = 1.0;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _textController.dispose();
//     _flutterTts.stop();
//     _buttonController.dispose();
//     _dropdownController.dispose();
//     _iconController.dispose();
//     super.dispose();
//   }

//   Future<void> _requestPermissions() async {
//     // صلاحيات إذا تحتاج
//   }

//   void initTTS() async {
//     var data = await _flutterTts.getVoices;
//     if (data.isNotEmpty) {
//       List<Map> voices = List<Map>.from(data);
//       setState(() {
//         _voices = voices
//             .where((voice) =>
//                 voice["name"].toString().toLowerCase().contains("en") ||
//                 voice["name"].toString().toLowerCase().contains("ar"))
//             .toList();
//         if (_voices.isNotEmpty) {
//           _currentVoice = _voices.first;
//           setVoice(_currentVoice!);
//         }
//       });
//     }
//   }

//   void setVoice(Map voice) {
//     _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
//   }

//   Future<void> _playButtonAnimation() async {
//     await _buttonController.forward();
//     await _buttonController.reverse();
//   }

//   Future<void> _speakText() async {
//     await _playButtonAnimation();
//     if (_textController.text.isNotEmpty &&
//         _currentVoice != null &&
//         !_isSpeaking) {
//       await _flutterTts.speak(_textController.text);
//     }
//   }

//   Future<void> _downloadAudio() async {
//     await _playButtonAnimation();

//     if (_textController.text.isEmpty || _currentVoice == null) {
//       _showSnackBar("Please enter text and select voice first.");
//       return;
//     }

//     setState(() {
//       _isDownloading = true;
//     });

//     try {
//       await Future.delayed(const Duration(seconds: 2));
//       _showSnackBarWithIcon("Audio downloaded successfully!");
//     } catch (e) {
//       _showSnackBar("Error during download.");
//     } finally {
//       setState(() {
//         _isDownloading = false;
//       });
//     }
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   void _showSnackBarWithIcon(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle, color: Colors.green),
//             const SizedBox(width: 8),
//             Text(message),
//           ],
//         ),
//         backgroundColor: Colors.black87,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   void _onVoiceChanged(Map? newVoice) {
//     if (newVoice != null) {
//       setState(() {
//         _currentVoice = newVoice;
//         setVoice(newVoice);
//       });

//       _dropdownController.forward().then((_) => _dropdownController.reverse());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnimatedOpacity(
//         opacity: _opacity,
//         duration: const Duration(milliseconds: 800),
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF6a11cb), Color(0xFF2575fc)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//           child: ListView(
//             children: [
//               const Text(
//                 "Text to Speech",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   shadows: [Shadow(color: Colors.black38, blurRadius: 6)],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 30),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.95),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 12,
//                       offset: Offset(0, 6),
//                     )
//                   ],
//                   border: Border.all(color: const Color(0xFF2575fc), width: 2),
//                 ),
//                 child: TextField(
//                   controller: _textController,
//                   maxLines: 4,
//                   style: const TextStyle(fontSize: 18, color: Colors.black87),
//                   decoration: const InputDecoration(
//                     hintText: "Type something...",
//                     border: InputBorder.none,
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 25),
//               ScaleTransition(
//                 scale: _dropdownScale,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.9),
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 6,
//                         offset: Offset(0, 2),
//                       )
//                     ],
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<Map>(
//                       value: _currentVoice,
//                       isExpanded: true,
//                       iconEnabledColor: const Color(0xFF2575fc),
//                       items: _voices
//                           .map(
//                             (voice) => DropdownMenuItem(
//                               value: voice,
//                               child: Text(
//                                 voice["name"] ?? "",
//                                 style: const TextStyle(
//                                     fontSize: 16, color: Colors.black87),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: _onVoiceChanged,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ScaleTransition(
//                       scale: _buttonScale,
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: _isSpeaking
//                               ? [
//                                   BoxShadow(
//                                     color: const Color(0xFF87CEEB)
//                                         .withOpacity(0.8),
//                                     spreadRadius: 6,
//                                     blurRadius: 20,
//                                   ),
//                                 ]
//                               : [],
//                         ),
//                         child: ElevatedButton(
//                           onPressed: _isSpeaking ? null : _speakText,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: _isSpeaking
//                                 ? const Color(0xFF87CEEB)
//                                 : Colors.white,
//                             foregroundColor: _isSpeaking
//                                 ? Colors.white
//                                 : const Color(0xFF2575fc),
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             elevation: 5,
//                           ),
//                           child: Text(
//                             _isSpeaking ? "Speaking..." : "Speak",
//                             style: const TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: ScaleTransition(
//                       scale: _buttonScale,
//                       child: ElevatedButton.icon(
//                         onPressed: _isDownloading ? null : _downloadAudio,
//                         icon: _isDownloading
//                             ? const SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Color(0xFF2575fc),
//                                 ),
//                               )
//                             : const Icon(Icons.download),
//                         label: Text(
//                           _isDownloading ? "Downloading..." : "Download",
//                           style: const TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.w600),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: const Color(0xFF2575fc),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 5,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 "Select voice from the list above.",
//                 style: TextStyle(color: Colors.white70, fontSize: 14),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 40),
//               Center(
//                 child: FadeTransition(
//                   opacity: _iconAnimation,
//                   child: Icon(
//                     Icons.catching_pokemon_outlined,
//                     size: 190,
//                     color: Colors.white.withOpacity(0.3),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//!

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'save.dart'; // صفحة الملفات المحفوظة

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _textController = TextEditingController();

  List<Map> _voices = [];
  Map? _currentVoice;

  bool _isSpeaking = false;
  bool _isProcessing = false;

  late AnimationController _buttonController;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _buttonScale =
        Tween<double>(begin: 1.0, end: 0.95).animate(_buttonController);

    _flutterTts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
      });
    });
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
    _flutterTts.setErrorHandler((message) {
      setState(() {
        _isSpeaking = false;
      });
    });

    initTTS();
    _requestPermissions();
  }

  @override
  void dispose() {
    _textController.dispose();
    _flutterTts.stop();
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  void initTTS() async {
    var data = await _flutterTts.getVoices;
    if (data.isNotEmpty) {
      List<Map> voices = List<Map>.from(data);
      setState(() {
        _voices = voices
            .where((voice) =>
                voice["name"].toString().toLowerCase().contains("en") ||
                voice["name"].toString().toLowerCase().contains("ar"))
            .toList();
        if (_voices.isNotEmpty) {
          _currentVoice = _voices.first;
          setVoice(_currentVoice!);
        }
      });
    }
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  Future<void> _playButtonAnimation() async {
    await _buttonController.forward();
    await _buttonController.reverse();
  }

  Future<void> _speakText() async {
    await _playButtonAnimation();
    if (_textController.text.isNotEmpty &&
        _currentVoice != null &&
        !_isSpeaking) {
      await _flutterTts.speak(_textController.text);
    }
  }

  Future<void> _saveAudio() async {
    if (_textController.text.isEmpty || _currentVoice == null) {
      _showSnackBar("Please enter text and select voice first.");
      return;
    }
    setState(() {
      _isProcessing = true;
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String path = '${dir.path}/tts_audio_$timestamp.wav';

      await _flutterTts.synthesizeToFile(_textController.text, path);

      _showSnackBar("Audio saved in app folder.");
    } catch (e) {
      _showSnackBar("Error saving audio: $e");
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _downloadAudio() async {
    if (_textController.text.isEmpty || _currentVoice == null) {
      _showSnackBar("Please enter text and select voice first.");
      return;
    }
    setState(() {
      _isProcessing = true;
    });

    try {
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          downloadsDir = await getExternalStorageDirectory();
        }
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (downloadsDir == null) {
        _showSnackBar("Cannot access download folder");
        return;
      }

      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String path = '${downloadsDir.path}/tts_audio_$timestamp.wav';

      await _flutterTts.synthesizeToFile(_textController.text, path);

      _showSnackBar("Audio downloaded to Downloads folder.");
    } catch (e) {
      _showSnackBar("Error downloading audio: $e");
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required List<Color> gradientColors,
    bool enabled = true,
    bool glowing = false,
    double? fontSize,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: glowing
            ? [
                BoxShadow(
                  color: gradientColors.last.withOpacity(0.6),
                  spreadRadius: 6,
                  blurRadius: 20,
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
      ),
      child: SizedBox(
        width: 140,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: enabled ? onPressed : null,
          icon: Icon(icon, size: 22, color: Colors.white),
          label: Text(
            label,
            style: TextStyle(
                fontSize: fontSize ?? 16,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 150, 19, 244),
              Color.fromARGB(150, 196, 154, 190)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SafeArea(
          child: ListView(
            children: [
              const Text(
                "Text to Speech",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    )
                  ],
                  border: Border.all(
                      color: Color.fromARGB(255, 229, 124, 255), width: 2),
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: 5,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                  decoration: const InputDecoration(
                    hintText: "Type your text here...",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<Map>(
                value: _currentVoice,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.95),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        BorderSide(color: Colors.blue.shade700, width: 2),
                  ),
                ),
                items: _voices.map((voice) {
                  return DropdownMenuItem(
                    value: voice,
                    child: Text(
                      voice["name"] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setVoice(val);
                    setState(() {
                      _currentVoice = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 30),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildButton(
                      label: _isSpeaking ? "Speaking..." : "Speak",
                      icon: Icons.play_arrow,
                      onPressed: _speakText,
                      gradientColors: [
                        Color(0xFF6DD5FA),
                        Color(0xFF2980B9)
                      ], // أزرق سماوي
                      enabled: !_isProcessing && !_isSpeaking,
                      glowing: _isSpeaking,
                    ),
                    _buildButton(
                      label: "Save",
                      icon: Icons.save,
                      onPressed: _saveAudio,
                      gradientColors: [
                        Color(0xFF56ab2f),
                        Color(0xFFa8e063)
                      ], // أخضر نعناع
                      enabled: !_isProcessing,
                    ),
                    _buildButton(
                      label: "Down",
                      icon: Icons.download,
                      onPressed: _downloadAudio,
                      gradientColors: [
                        Color(0xFFe52d27),
                        Color(0xFFb31217)
                      ], // أحمر متدرج
                      enabled: !_isProcessing,
                      fontSize: 14,
                    ),
                    IconButton(
                      icon: const Icon(Icons.folder,
                          color: Color.fromARGB(255, 255, 255, 255), size: 30),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SavedFilesPage()),
                        );
                      },
                      tooltip: 'Saved Files',
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Icon(
                  Icons.volume_up,
                  size: 80,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
