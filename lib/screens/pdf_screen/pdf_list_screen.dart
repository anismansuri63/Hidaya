import 'dart:io';

import 'package:com_quranicayah/screens/pdf_screen/pdf_model.dart';
import 'package:com_quranicayah/screens/pdf_screen/pdf_view_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import '../../theme/app_colors.dart';

class PdfListScreen extends StatelessWidget {
  PdfListScreen({super.key});

  final Box<PdfModel> box = Hive.box<PdfModel>('pdfBox');

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(
          color: theme.textWhite, // ← Set your desired color here
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              pickAndSavePdf(context);
            },
            tooltip: 'Add',
          )
        ],

        title: Text("PDF Dua",
          style: TextStyle(color: theme.textWhite),),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<PdfModel> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No PDFs added"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final pdf = box.getAt(index)!;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  elevation: 3,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PdfViewerScreen(pdf: pdf),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          // 📄 PDF ICON
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                              size: 28,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // 📄 FILE INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pdf.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Last page: ${pdf.lastPage}",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 🗑 DELETE BUTTON (VISIBLE)
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.red,
                            onPressed: () async {
                              final confirm =
                              await _showDeleteDialog(context);
                              if (confirm) {
                                await _deletePdf(context, pdf);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ==============================
  // 📂 PICK & SAVE PDF
  // ==============================
  Future<void> pickAndSavePdf(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final pickedFile = result.files.first;

      final appDir = await getApplicationDocumentsDirectory();

      // 🔥 Generate safe filename
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';

      final newPath = '${appDir.path}/$fileName';

      File savedFile;

      if (pickedFile.path != null && pickedFile.path!.isNotEmpty) {
        // ✅ Android
        savedFile = await File(pickedFile.path!).copy(newPath);
      } else if (pickedFile.bytes != null) {
        // ✅ iOS
        savedFile = await File(newPath).writeAsBytes(
          pickedFile.bytes!,
          flush: true, // 🔥 VERY IMPORTANT
        );
      } else {
        throw Exception("File data not available");
      }

      // 🔥 SAVE ONLY FILE NAME (NOT FULL PATH)
      final pdf = PdfModel(
        id: DateTime.now().toString(),
        name: pickedFile.name,
        fileName: fileName, // ✅ store only filename
      );

      await box.add(pdf);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF added successfully")),
      );
    } catch (e) {
      debugPrint("ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add PDF")),
      );
    }
  }

  // ==============================
  // 🗑 DELETE CONFIRM DIALOG
  // ==============================
  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete PDF"),
        content:
        const Text("Are you sure you want to delete this PDF?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  // ==============================
  // ❌ DELETE FILE + HIVE
  // ==============================
  Future<void> _deletePdf(BuildContext context, PdfModel pdf) async {
    try {
      // 🔥 Rebuild full path
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/${pdf.fileName}';

      final file = File(filePath);

      // ✅ Delete file if exists
      if (await file.exists()) {
        await file.delete();
      } else {
        debugPrint("File not found: $filePath");
      }

      // ✅ Delete from Hive
      await pdf.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${pdf.name} deleted")),
      );
    } catch (e) {
      debugPrint("Delete error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete PDF")),
      );
    }
  }
}