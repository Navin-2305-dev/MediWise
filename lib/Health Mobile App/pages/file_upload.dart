import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'dart:io';
import 'dart:convert';

class PDFExtractorApp extends StatelessWidget {
  const PDFExtractorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.indigo,
          secondary: Colors.teal,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
      ),
      home: FileUploadScreen(),
    );
  }
}

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  File? _selectedFile;
  String _status = '';
  String _pdfContent = '';
  bool _isLoading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _status = 'Selected: ${result.files.single.name}';
        _pdfContent = '';
      });
    }
  }

  Future<void> _uploadAndAnalyzeFile() async {
    if (_selectedFile == null) {
      setState(() => _status = 'Please select a PDF file first');
      return;
    }

    setState(() => _isLoading = true);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://172.16.3.25:3000/upload/uploadfile'),
      );

      request.files.add(
        http.MultipartFile(
          'medicalDoc',
          _selectedFile!.readAsBytes().asStream(),
          _selectedFile!.lengthSync(),
          filename: _selectedFile!.path.split('/').last,
          contentType: MediaType('application', 'pdf'),
        ),
      );

      var uploadResponse = await request.send();

      if (uploadResponse.statusCode == 200) {
        await _analyzeWithGemini();
        setState(() {
          _status = 'Upload and analysis completed';
        });
      } else {
        setState(() {
          _status = 'Upload failed: ${uploadResponse.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _analyzeWithGemini() async {
    const apiKey = 'YOUR_API_KEY';
    final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey');

    try {
      // Extract text from PDF using read_pdf_text
      String pdfText = await ReadPdfText.getPDFtext(_selectedFile!.path);

      if (pdfText.isEmpty) {
        setState(() {
          _pdfContent = 'No text could be extracted from the PDF';
        });
        return;
      }

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'Please provide a brief summary of this content: $pdfText'
                },
              ],
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _pdfContent = data['candidates'][0]['content']['parts'][0]['text'];
        });
      } else {
        final errorBody = jsonDecode(response.body);
        setState(() {
          _pdfContent =
              'Failed to analyze content. Status: ${response.statusCode}. '
              'Error: ${errorBody['error']['message']}';
        });
      }
    } catch (e) {
      setState(() {
        _pdfContent = 'Error processing PDF: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'PDF Analyzer',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.indigo, Colors.teal],
                  ),
                ),
                child: Icon(
                  Icons.picture_as_pdf,
                  size: 80,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildActionButton(
                                  icon: Icons.attach_file,
                                  label: 'Select PDF',
                                  color: Colors.indigo,
                                  onPressed: _pickFile,
                                ),
                                _buildActionButton(
                                  icon: Icons.cloud_upload,
                                  label: 'Analyze',
                                  color: Colors.teal,
                                  onPressed: _uploadAndAnalyzeFile,
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            _buildStatusContainer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_pdfContent.isNotEmpty) ...[
                    SizedBox(height: 24),
                    Text(
                      'Analysis Result',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            _pdfContent,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildStatusContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: _isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Processing...',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            )
          : Text(
              _status.isEmpty ? 'No file selected' : _status,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }
}
