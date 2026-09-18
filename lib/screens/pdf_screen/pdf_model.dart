import 'package:hive/hive.dart';

part 'pdf_model.g.dart';

@HiveType(typeId: 0)
class PdfModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String fileName;

  @HiveField(3)
  int lastPage;

  PdfModel({
    required this.id,
    required this.name,
    required this.fileName,
    this.lastPage = 1,
  });
}