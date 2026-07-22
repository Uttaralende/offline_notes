  import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_notes/features/notes/presentation/providers/providers.dart';

  import '../../domain/entities/note.dart';
  import '../../domain/usecases/add_note.dart';
  import '../../domain/usecases/delete_note.dart';
  import '../../domain/usecases/get_notes.dart';
  import '../../domain/usecases/sync_notes.dart';
  import '../../domain/usecases/update_note.dart';

  class NoteNotifier extends AsyncNotifier<List<Note>> {
    late final GetNotes _getNotes;
    late final AddNote _addNote;
    late final UpdateNote _updateNote;
    late final DeleteNote _deleteNote;
    late final SyncNotes _syncNotes;

    @override
    Future<List<Note>> build() async {
      _getNotes = ref.read(getNotesProvider);
      _addNote = ref.read(addNoteProvider);
      _updateNote = ref.read(updateNoteProvider);
      _deleteNote = ref.read(deleteNoteProvider);
      _syncNotes = ref.read(syncNotesProvider);

      return _getNotes();
    }

    Future<void> loadNotes() async {
      state = const AsyncLoading();

      state = await AsyncValue.guard(() async {
        return _getNotes();
      });
    }

    Future<void> addNote(Note note) async {
      await _addNote(note);
      await loadNotes();
    }

    Future<void> updateNote(Note note) async {
      await _updateNote(note);
      await loadNotes();
    }

    Future<void> deleteNote(String id) async {
      await _deleteNote(id);
      await loadNotes();
    }

    Future<void> syncNotes() async {
      await _syncNotes();
      await loadNotes();
    }
  }