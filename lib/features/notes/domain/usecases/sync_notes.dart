import '../repositories/note_repository.dart';

class SyncNotes {
  final NoteRepository repository;

  SyncNotes(this.repository);

  Future<void> call() async {
    await repository.syncNotes();
  }
}