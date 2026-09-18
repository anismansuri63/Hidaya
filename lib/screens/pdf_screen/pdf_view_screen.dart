import 'dart:io';

import 'package:com_quranicayah/screens/pdf_screen/pdf_model.dart';
import 'package:com_quranicayah/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../theme/app_colors.dart';
import 'dart:io';

import 'package:com_quranicayah/screens/pdf_screen/pdf_model.dart';
import 'package:com_quranicayah/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../theme/app_colors.dart';

class PdfViewerScreen extends StatefulWidget {
  final PdfModel pdf;

  const PdfViewerScreen({super.key, required this.pdf});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfViewerController _controller;
  final TextEditingController _pageController = TextEditingController();

  bool _isLoaded = false;
  bool _showPdf = false;
  File? _file;

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
    _loadFile();
  }

  Future<void> _loadFile() async {
    final dir = await getApplicationDocumentsDirectory();
    _file = File('${dir.path}/${widget.pdf.fileName}');

    // 🔥 DELAYED RENDER FIX
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _showPdf = true;
        });
      }
    });
  }

  void onDocumentLoaded(PdfDocumentLoadedDetails details) {
    setState(() {
      _isLoaded = true;
    });

    // 🔥 SAFE PAGE RESTORE
    if (widget.pdf.lastPage > 1) {
      Future.delayed(const Duration(milliseconds: 300), () {
        try {
          _controller.jumpToPage(widget.pdf.lastPage);
        } catch (e) {
          debugPrint("Jump error: $e");
        }
      });
    }
  }

  void onPageChanged(PdfPageChangedDetails details) {
    widget.pdf.lastPage = details.newPageNumber;
    widget.pdf.save();
  }

  void jumpToPage() {
    final page = int.tryParse(_pageController.text);
    if (page != null && page > 0) {
      _controller.jumpToPage(page);
    }

    // 🔥 Hide keyboard
    FocusScope.of(context).unfocus();

    // 🔥 Clear input
    _pageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);

    if (_file == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.pdf.name)),
        body: const Center(child: Text("Loading")),
      );
    }

    if (!_file!.existsSync() || _file!.lengthSync() == 0) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.pdf.name)),
        body: const Center(child: Text("PDF not available")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(color: theme.textWhite),
        title: Text(
          widget.pdf.name,
          style: TextStyle(color: theme.textWhite),
        ),
        actions: [
          SizedBox(
            width: 60,
            child: TextField(
              controller: _pageController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Page",
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => jumpToPage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: jumpToPage,
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // 🔥 Hide keyboard on tap anywhere
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            if (_showPdf)
              SfPdfViewer.file(
                _file!,
                controller: _controller,
                onDocumentLoaded: onDocumentLoaded,
                onPageChanged: onPageChanged,
                onDocumentLoadFailed: (details) {
                  debugPrint("Load error: ${details.error}");
                },
              ),

            if (!_isLoaded)
              Center(
                child: CircularProgressIndicator(color: theme.primary),
              ),
          ],
        ),
      ),
    );
  }
}