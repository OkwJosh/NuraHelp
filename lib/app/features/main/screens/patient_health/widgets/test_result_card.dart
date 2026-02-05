import 'package:flutter/material.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import '../../../../../utilities/constants/colors.dart';
import '../../../../../utilities/loaders/loaders.dart';

class TestResultCard extends StatelessWidget {
  const TestResultCard({
    super.key,
    required this.testName,
    required this.observation,
    required this.description,
    required this.date,
    required this.viewLink,
    required this.downloadLink,
  });

  final String testName;
  final String observation;
  final String description;
  final DateTime date;
  final String viewLink;
  final String downloadLink;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0.1,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 20,
            bottom: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                testName,
                style: const TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 16,
                ),
              ),
              Text(
                _formatDate(date),
                style: const TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 14,
                  color: AppColors.black300,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _viewPDF(context, viewLink),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgIcon(AppIcons.eye, color: Colors.white),
                            const SizedBox(width: 5),
                            const Text(
                              'View report',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      OutlinedButton(
                        onPressed: () => _downloadFile(context, downloadLink),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.secondaryColor,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgIcon(
                              AppIcons.download,
                              color: AppColors.secondaryColor,
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'Download',
                              style: TextStyle(
                                color: AppColors.secondaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(width: 5),
                  // IconButton(
                  //   style: IconButton.styleFrom(padding: EdgeInsets.zero),
                  //   onPressed: () {},
                  //   icon: SvgIcon(AppIcons.ellipsis),
                  // ),
                ],
              ),
              const SizedBox(height: 15),
              // const Divider(),
              // const SizedBox(height: 15),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       observation,
              //       style: const TextStyle(
              //         fontFamily: 'Poppins-Medium',
              //         fontSize: 16,
              //       ),
              //     ),
              //     const SizedBox(height: 5),
              //     Text(
              //       description,
              //       style: const TextStyle(
              //         fontFamily: 'Poppins-Regular',
              //         fontSize: 14,
              //         color: AppColors.black300,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  String _getFullUrl(String urlOrPath) {
    // If URL already contains protocol, return as-is
    if (urlOrPath.startsWith('http://') || urlOrPath.startsWith('https://')) {
      return urlOrPath;
    }

    // It's a Firebase Storage path, construct the full URL
    // Path format: uploads/userId/filename
    final storageBucket = 'nura-31b7b.firebasestorage.app';

    final encodedPath = Uri.encodeComponent(urlOrPath);

    // Firebase Storage URL format with alt=media to get direct download link
    return 'https://firebasestorage.googleapis.com/v0/b/$storageBucket/o/$encodedPath?alt=media';
  }

  Future<void> _viewPDF(BuildContext context, String url) async {
    try {
      final fullUrl = _getFullUrl(url);
      print('📄 Opening PDF viewer with URL: $fullUrl');

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text(
                'Test Result PDF',
                style: TextStyle(fontFamily: 'Poppins-Medium', fontSize: 18),
              ),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SfPdfViewer.network(
              fullUrl,
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                print('❌ PDF loading failed: ${details.error}');
                AppToasts.errorSnackBar(
                  title: 'Error',
                  message: 'Failed to load PDF: ${details.error}',
                );
              },
            ),
          ),
        ),
      );

      print('✅ PDF viewer closed');
    } catch (e) {
      print('❌ Error opening PDF: $e');
      AppToasts.errorSnackBar(
        title: 'Error',
        message: 'Failed to open PDF: ${e.toString()}',
      );
    }
  }

  Future<void> _downloadFile(BuildContext context, String url) async {
    try {
      final fullUrl = _getFullUrl(url);
      print('⬇️  Starting download from URL: $fullUrl');
      print('📋 URL length: ${fullUrl.length}, isEmpty: ${fullUrl.isEmpty}');

      // Validate URL first
      if (fullUrl.isEmpty) {
        print('❌ URL is empty!');
        AppToasts.warningSnackBar(
          title: 'No Link Available',
          message: 'The download link is not available for this test result',
        );
        return;
      }

      // Validate URL format
      try {
        Uri.parse(fullUrl);
      } catch (e) {
        print('❌ Invalid URL format: $e');
        AppToasts.errorSnackBar(
          title: 'Invalid URL',
          message: 'The download link appears to be invalid: ${e.toString()}',
        );
        return;
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Downloading file...'),
            ],
          ),
        ),
      );

      print('🌐 Making HTTP GET request to: $fullUrl');
      final response = await http.get(Uri.parse(fullUrl));

      print('📊 Response status code: ${response.statusCode}');
      print('📦 Response body length: ${response.bodyBytes.length}');

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();

        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        final formattedDate =
            '${date.day.toString().padLeft(2, '0')}_${months[date.month - 1]}_${date.year}';
        final fileName = 'NuraTestResult_$formattedDate.pdf';
        final filePath = '${dir.path}/$fileName';

        print('📁 Download path: $filePath');

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('✅ File downloaded successfully to: $filePath');

        // Close loading dialog
        Navigator.pop(context);

        AppToasts.successSnackBar(
          title: 'Download Complete',
          message: 'File saved: $fileName',
        );
      } else {
        print('❌ Download failed with status code: ${response.statusCode}');
        Navigator.pop(context);

        AppToasts.errorSnackBar(
          title: 'Download Failed',
          message: 'Server returned status ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Error downloading file: $e');
      print('❌ Error type: ${e.runtimeType}');

      // Close loading dialog
      try {
        Navigator.pop(context);
      } catch (_) {}

      AppToasts.errorSnackBar(
        title: 'Download Failed',
        message: 'Failed to download file: ${e.toString()}',
      );
    }
  }
}
