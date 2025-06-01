// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:audioplayers/audioplayers.dart';

// class SavedFilesPage extends StatefulWidget {
//   const SavedFilesPage({super.key});

//   @override
//   State<SavedFilesPage> createState() => _SavedFilesPageState();
// }

// class _SavedFilesPageState extends State<SavedFilesPage> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   List<FileSystemEntity> _savedFiles = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedFiles();
//   }

//   Future<void> _loadSavedFiles() async {
//     final dir = await getApplicationDocumentsDirectory();
//     final files = dir.listSync().where((e) => e.path.endsWith('.wav')).toList();
//     setState(() {
//       _savedFiles = files;
//     });
//   }

//   Future<void> _playFile(File file) async {
//     await _audioPlayer.stop();
//     await _audioPlayer.play(DeviceFileSource(file.path));
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Saved Audio Files"),
//       ),
//       body: _savedFiles.isEmpty
//           ? const Center(child: Text("No saved audio files."))
//           : ListView.builder(
//               itemCount: _savedFiles.length,
//               itemBuilder: (context, index) {
//                 final file = _savedFiles[index];
//                 final fileName = file.path.split('/').last;
//                 return ListTile(
//                   leading: const Icon(Icons.audiotrack, color: Colors.blueAccent),
//                   title: Text(fileName),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.play_arrow, color: Colors.blueAccent),
//                     onPressed: () => _playFile(File(file.path)),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }



//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:intl/intl.dart';

// class SavedFilesPage extends StatefulWidget {
//   const SavedFilesPage({super.key});

//   @override
//   State<SavedFilesPage> createState() => _SavedFilesPageState();
// }

// class _SavedFilesPageState extends State<SavedFilesPage> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   List<FileSystemEntity> _savedFiles = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedFiles();
//   }

//   Future<void> _loadSavedFiles() async {
//     final dir = await getApplicationDocumentsDirectory();
//     final files = dir.listSync().where((e) => e.path.endsWith('.wav')).toList();
//     files.sort((a, b) => b
//         .statSync()
//         .modified
//         .compareTo(a.statSync().modified)); // ترتيب حسب الأحدث
//     setState(() {
//       _savedFiles = files;
//     });
//   }

//   Future<void> _playFile(File file) async {
//     await _audioPlayer.stop();
//     await _audioPlayer.play(DeviceFileSource(file.path));
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   String _formatDate(DateTime dt) {
//     return DateFormat('yyyy-MM-dd – HH:mm').format(dt);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 179, 163, 211),
//       appBar: AppBar(
//         title: const Text("Saved Audio Files"),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF6a11cb), Color.fromARGB(164, 230, 131, 227)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: _savedFiles.isEmpty
//           ? const Center(
//               child: Text(
//                 "No saved audio files.",
//                 style: TextStyle(fontSize: 18, color: Colors.black54),
//               ),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: _savedFiles.length,
//               itemBuilder: (context, index) {
//                 final file = _savedFiles[index];
//                 final stat = file.statSync();
//                 final modified = stat.modified;
//                 final fileName = file.path.split('/').last;

//                 return Container(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.purple.withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       )
//                     ],
//                   ),
//                   child: ListTile(
//                     leading: const Icon(Icons.audiotrack,
//                         color: Colors.white, size: 32),
//                     title: Text(
//                       fileName,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     subtitle: Text(
//                       'Modified: ${_formatDate(modified)}',
//                       style:
//                           const TextStyle(color: Colors.white70, fontSize: 13),
//                     ),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.play_arrow,
//                           color: Colors.white, size: 30),
//                       onPressed: () => _playFile(File(file.path)),
//                       tooltip: 'Play',
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
//!



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

class SavedFilesPage extends StatefulWidget {
  const SavedFilesPage({super.key});

  @override
  State<SavedFilesPage> createState() => _SavedFilesPageState();
}

class _SavedFilesPageState extends State<SavedFilesPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<FileSystemEntity> _savedFiles = [];

  @override
  void initState() {
    super.initState();
    _loadSavedFiles();
  }

  Future<void> _loadSavedFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync().where((e) => e.path.endsWith('.wav')).toList();
    files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    setState(() {
      _savedFiles = files;
    });
  }

  Future<void> _playFile(File file) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(DeviceFileSource(file.path));
  }

  Future<void> _deleteFile(FileSystemEntity file) async {
    try {
      await file.delete();
      if (mounted) {
        _showSnackBar("File deleted.");
        _loadSavedFiles();
      }
    } catch (e) {
      _showSnackBar("Error deleting file: $e");
    }
  }

  Future<void> _renameFile(FileSystemEntity file) async {
    final oldPath = file.path;
    final oldFile = File(oldPath);
    final dir = oldFile.parent;

    final newNameController = TextEditingController();
    final oldName = oldPath.split('/').last;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Rename file"),
          content: TextField(
            controller: newNameController,
            decoration: InputDecoration(
              labelText: "New file name",
              hintText: oldName,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = newNameController.text.trim();
                if (newName.isEmpty) {
                  _showSnackBar("Name cannot be empty");
                  return;
                }
                String newFileName = newName.endsWith('.wav') ? newName : '$newName.wav';
                final newPath = '${dir.path}/$newFileName';
                final newFile = File(newPath);

                if (await newFile.exists()) {
                  _showSnackBar("A file with this name already exists.");
                  return;
                }

                try {
                  await oldFile.rename(newPath);
                  if (mounted) {
                    _showSnackBar("File renamed.");
                    _loadSavedFiles();
                  }
                } catch (e) {
                  _showSnackBar("Error renaming file: $e");
                }
                Navigator.pop(context);
              },
              child: const Text("Rename"),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  String _formatDate(DateTime dt) {
    return DateFormat('yyyy-MM-dd – HH:mm').format(dt);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 179, 163, 211),
      appBar: AppBar(
        title: const Text("Saved Audio Files"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6a11cb), Color.fromARGB(164, 230, 131, 227)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _savedFiles.isEmpty
          ? const Center(
              child: Text(
                "No saved audio files.",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _savedFiles.length,
              itemBuilder: (context, index) {
                final file = _savedFiles[index];
                final stat = file.statSync();
                final modified = stat.modified;
                final fileName = file.path.split('/').last;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.audiotrack,
                        color: Colors.white, size: 32),
                    title: Text(
                      fileName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Modified: ${_formatDate(modified)}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Colors.white, size: 28),
                          onPressed: () => _renameFile(file),
                          tooltip: 'Rename',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.white, size: 28),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete File'),
                              content: Text('Are you sure you want to delete "$fileName"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteFile(file);
                                  },
                                  child: const Text('Delete'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          tooltip: 'Delete',
                        ),
                        IconButton(
                          icon: const Icon(Icons.play_arrow,
                              color: Colors.white, size: 30),
                          onPressed: () => _playFile(File(file.path)),
                          tooltip: 'Play',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
