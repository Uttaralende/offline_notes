import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/localDataSource.dart';
import '../datasources/remoteDataSource.dart';
import '../models/note_model.dart';
// import '../mapper/note_mapper.dart';

class NoteRepositoryImpl implements NoteRepository {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  NoteRepositoryImpl({required this.localDataSource, required this.remoteDataSource});

  @override
  Future<List<Note>> getNotes() async {
    final models = await localDataSource.getNotes();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> addNote(Note note) async {

    final pendingNote = note.copyWith(
      syncStatus: SyncStatus.pending,
      updatedAt: DateTime.now(),
    );
    await localDataSource.addNote(NoteModel.fromEntity(pendingNote));
  }

  @override
  Future<void> updateNote(Note note) async {

    final pendingNote = note.copyWith(
      syncStatus: SyncStatus.pending,
      updatedAt: DateTime.now(),
      version: note.version + 1,
    );

    await localDataSource.updateNote(
        NoteModel.fromEntity(pendingNote));
  }

  @override
  Future<void> deleteNote(String id) async {
    await localDataSource.deleteNote(id);
  }

  @override
  Future<void> syncNotes() async {

    final pendingNotes =
    await localDataSource.getPendingNotes();

    print("Pending Notes: ${pendingNotes.length}");


    for (final localNote in pendingNotes) {

      final serverNote =
      await remoteDataSource.getNoteById(localNote.id);

      print("Server Note: $serverNote");


      if (serverNote == null) {

        await remoteDataSource.createNote(localNote);

        print("Created successfully");


        await localDataSource.markSynced(localNote.id);

        continue;
      }

      // Conflict check
      if (serverNote.updatedAt.isAfter(localNote.updatedAt)) {

        await localDataSource.markConflict(localNote.id);

        continue;
      }

      // No conflict
      await remoteDataSource.updateNote(localNote);

      await localDataSource.markSynced(localNote.id);
    }
  }
}
