import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mediwise/Health%20Mobile%20App/models/pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

class PatientPDFPage extends StatelessWidget {
  final String uniqueId; // Keeping this for consistency

  const PatientPDFPage({super.key, required this.uniqueId});

  Future<String> savePDFFromAssets(BuildContext context, String pdfName) async {
    try {
      // Load PDF from assets
      final byteData = await rootBundle.load('assets/pdfs/$pdfName');
      final bytes = byteData.buffer.asUint8List();

      // Save to documents directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$pdfName');
      await file.writeAsBytes(bytes);

      return file.path;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error handling PDF: $e')),
      );
      rethrow;
    }
  }

  void openPDF(BuildContext context, String pdfName) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewPage(
            isAsset: false,
          ),
        ),
      );
    } catch (e) {
      // Error already handled in savePDFFromAssets
    }
  }

  Widget buildTile(BuildContext context, String period, List<String> pdfs) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              period,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: pdfs.map((pdfName) {
                  final isDownloadable =
                      period == 'Jan-Mar' && pdfName != 'Coming Soon';
                  return GestureDetector(
                    onTap:
                        isDownloadable ? () => openPDF(context, pdfName) : null,
                    child: Container(
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isDownloadable
                            ? Colors.blue[100]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                pdfName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDownloadable
                                      ? Colors.black
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                          if (isDownloadable)
                            Positioned(
                              right: 4,
                              bottom: 4,
                              child: Icon(
                                Icons
                                    .visibility, // Changed to visibility icon since we're viewing
                                size: 20,
                                color: Colors.blue[700],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pdfFiles = {
      'Jan-Mar': ['January-March.pdf'],
      'Apr-Jun': ['Coming Soon'],
      'Jul-Sep': ['Coming Soon'],
      'Oct-Dec': ['Coming Soon'],
      'Annual': ['Coming Soon'],
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient PDF Reports'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: pdfFiles.entries
            .map((entry) => buildTile(context, entry.key, entry.value))
            .toList(),
      ),
    );
  }
}

class PDFViewerPage extends StatelessWidget {
  final String pdfPath;
  final String pdfName;

  const PDFViewerPage(
      {super.key, required this.pdfPath, required this.pdfName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pdfName),
      ),
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading PDF: $error')),
          );
        },
        onPageError: (page, error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error on page $page: $error')),
          );
        },
      ),
    );
  }
}
