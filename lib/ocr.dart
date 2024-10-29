// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:flutter/services.dart';

// class OCRScreen extends StatefulWidget {
//   @override
//   _OCRScreenState createState() => _OCRScreenState();
// }

// class _OCRScreenState extends State<OCRScreen> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   String _extractedText = "No text extracted";
//   bool _isProcessing = false;

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         _extractedText = "Extracting text..."; // Reset extracted text
//         _isProcessing = true;
//       });
//       await _extractTextFromImage(File(pickedFile.path));
//     }
//   }

//   Future<void> _extractTextFromImage(File image) async {
//     final inputImage = InputImage.fromFile(image);
//     final textRecognizer = GoogleMlKit.vision.textRecognizer();

//     try {
//       final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
//       setState(() {
//         _extractedText = recognizedText.text.isNotEmpty ? recognizedText.text : "No text found.";
//       });

//       // Print extracted text to console
//       print("Extracted Text: $_extractedText");

//     } catch (e) {
//       setState(() {
//         _extractedText = "Error extracting text: $e";
//       });
//     } finally {
//       setState(() {
//         _isProcessing = false;
//       });
//       textRecognizer.close();
//     }
//   }

//   // Function to copy extracted text to clipboard
//   void _copyToClipboard() {
//     Clipboard.setData(ClipboardData(text: _extractedText));
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Text copied to clipboard")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'OCR Text Extractor',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: const Color(0xff001f4d),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Display Image Section
//               if (_image != null)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.file(
//                     _image!,
//                     height: 250,
//                     fit: BoxFit.cover,
//                   ),
//                 )
//               else
//                 Container(
//                   height: 250,
//                   width: 250,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 7,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.image,
//                     size: 80,
//                     color: Colors.grey,
//                   ),
//                 ),
//               const SizedBox(height: 20),

//               // Button Row for Gallery and Camera
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.gallery),
//                     icon: const Icon(Icons.photo_library),
//                     label: const Text('Gallery'),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       backgroundColor: const Color(0xff001f4d),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.camera),
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text('Camera'),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       backgroundColor: const Color(0xff001f4d),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Display Progress Indicator or Extracted Text
//               if (_isProcessing)
//                 const CircularProgressIndicator()
//               else
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   margin: const EdgeInsets.only(top: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       const Text(
//                         "Extracted Text:",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xff001f4d),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         _extractedText,
//                         style: const TextStyle(fontSize: 16, color: Colors.black87),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//               const SizedBox(height: 20),

//               // Copy Text Button
//               ElevatedButton.icon(
//                 onPressed: _copyToClipboard,
//                 icon: const Icon(Icons.copy),
//                 label: const Text('Copy Text'),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   backgroundColor: Colors.blueAccent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/services.dart';

class OCRScreen extends StatefulWidget {
  @override
  _OCRScreenState createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String _extractedText = "No text extracted";
  bool _isProcessing = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _extractedText = "Extracting text..."; // Reset extracted text
        _isProcessing = true;
      });
      await _extractTextFromImage(File(pickedFile.path));
    }
  }

  Future<void> _extractTextFromImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        _extractedText = recognizedText.text.isNotEmpty ? recognizedText.text : "No text found.";
      });

      // Print extracted text to console
      print("Extracted Text: $_extractedText");

    } catch (e) {
      setState(() {
        _extractedText = "Error extracting text: $e";
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
      textRecognizer.close();
    }
  }

  // Function to copy extracted text to clipboard
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _extractedText));
    ScaffoldMessenger.of(context).showSnackBar(
      
      const SnackBar(backgroundColor: Colors.pinkAccent,
        content: Center(child: Text("Text copied to clipboard"))),
    );
  }

  // Function to show the image source selection dialog
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.photo_library, color: Color(0xff001f4d), size: 40),
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt, color: Color(0xff001f4d), size: 40),
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OCR Text Extractor',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff001f4d),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy,),color: Colors.pinkAccent,
            onPressed: _copyToClipboard,
            tooltip: 'Copy Text',
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
          decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/bg.jpg"), // Replace with your actual image path
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    _image!,
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.image,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(height: 20),
        
              if (_isProcessing)
                const CircularProgressIndicator()
              else
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Extracted Text:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff001f4d),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _extractedText,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                          textAlign: TextAlign.justify, // Justify text alignment
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showImageSourceDialog,
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add_a_photo, color: Colors.white),
        tooltip: 'Select Image',
      ),
    );
  }
}
