// import '../models/note_model.dart';
//
// abstract class LocalDataSource {
//   Future<List<NoteModel>> getNotes();
//
//   Future<void> addNote(NoteModel note);
//
//   Future<void> updateNote(NoteModel note);
//
//   Future<void> deleteNote(String id);
//
//   Future<List<NoteModel>> getPendingNotes();
//
//   Future<void> markSynced(String id);
//
//   Future<void> markConflict(String id);
// }
//

import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/note.dart';
import '../models/note_model.dart';

abstract class LocalDataSource {
  Future<List<NoteModel>> getNotes();

  Future<void> addNote(NoteModel note);

  Future<void> updateNote(NoteModel note);

  Future<void> deleteNote(String id);

  Future<List<NoteModel>> getPendingNotes();

  Future<void> markSynced(String id);

  Future<void> markConflict(String id);
}

class LocalDataSourceImpl implements LocalDataSource {
  final Box<NoteModel> _box = Hive.box<NoteModel>('notes');

  @override
  Future<void> addNote(NoteModel note) async {
    await _box.put(note.id, note);
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    await _box.put(note.id, note);
  }

  @override
  Future<void> deleteNote(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<NoteModel>> getNotes() async {
    return _box.values.toList();
  }

  @override
  Future<List<NoteModel>> getPendingNotes() async {
    return _box.values
        .where((note) => note.syncStatus == SyncStatus.pending.index)
        .toList();
  }

  @override
  Future<void> markSynced(String id) async {
    final note = _box.get(id);

    if (note == null) return;

    note.syncStatus = SyncStatus.synced.index;

    await note.save();
  }

  @override
  Future<void> markConflict(String id) async {
    final note = _box.get(id);

    if (note == null) return;

    note.syncStatus = SyncStatus.conflict.index;

    await note.save();
  }
}