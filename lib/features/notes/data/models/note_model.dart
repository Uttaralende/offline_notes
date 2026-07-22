import 'package:hive/hive.dart';

import '../../domain/entities/note.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  DateTime updatedAt;

  @HiveField(4)
  int version;

  @HiveField(5)
  bool isDeleted;

  @HiveField(6)
  int syncStatus;

  NoteModel({
    required this.id,
    required this.title,
    required this.body,
    required this.updatedAt,
    required this.version,
    required this.isDeleted,
    required this.syncStatus,
  });

  /// Convert Hive Model -> Domain Entity
  Note toEntity() {
    return Note(
      id: id,
      title: title,
      body: body,
      updatedAt: updatedAt,
      version: version,
      isDeleted: isDeleted,
      syncStatus: SyncStatus.values[syncStatus],
    );
  }

  /// Convert Domain Entity -> Hive Model
  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      body: note.body,
      updatedAt: note.updatedAt,
      version: note.version,
      isDeleted: note.isDeleted,
      syncStatus: note.syncStatus.index,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'updatedAt': updatedAt.toIso8601String(),
      'version': version,
      'isDeleted': isDeleted,
      'syncStatus': syncStatus,
    };
  }
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      version: json['version'] as int,
      isDeleted: json['isDeleted'] as bool,
      syncStatus: json['syncStatus'] as int,
    );
  }
}