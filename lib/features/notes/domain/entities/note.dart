enum SyncStatus {
  synced,
  pending,
  conflict,
}

class Note {
  final String id;
  final String title;
  final String body;
  final DateTime updatedAt;
  final int version;
  final bool isDeleted;
  final SyncStatus syncStatus;

  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.updatedAt,
    required this.version,
    required this.isDeleted,
    required this.syncStatus,
  });

  Note copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? updatedAt,
    int? version,
    bool? isDeleted,
    SyncStatus? syncStatus,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}