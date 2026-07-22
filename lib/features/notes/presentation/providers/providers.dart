import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_notes/core/network/api_client.dart';
import 'package:offline_notes/features/notes/data/datasources/localDataSource.dart' ;

// import '../../data/datasources/localDatasource.dart';
// import '../../data/datasources/remote_datasource.dart';
import '../../data/datasources/remoteDataSource.dart';
import '../../data/repository/note_repository_impl.dart';

import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';

import '../../domain/usecases/add_note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/get_notes.dart';
import '../../domain/usecases/sync_notes.dart';
import '../../domain/usecases/update_note.dart';

import 'note_notifier.dart';

/// Local Data Source
final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSourceImpl();
});

/// Remote Data Source
final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  return RemoteDataSourceImpl(
    dio: ApiClient.instance.dio,
  );
});

/// Repository
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepositoryImpl(
    localDataSource: ref.watch(localDataSourceProvider),
    remoteDataSource: ref.watch(remoteDataSourceProvider),
  );
});

/// Use Cases
final getNotesProvider = Provider<GetNotes>((ref) {
  return GetNotes(ref.watch(noteRepositoryProvider));
});

final addNoteProvider = Provider<AddNote>((ref) {
  return AddNote(ref.watch(noteRepositoryProvider));
});

final updateNoteProvider = Provider<UpdateNote>((ref) {
  return UpdateNote(ref.watch(noteRepositoryProvider));
});

final deleteNoteProvider = Provider<DeleteNote>((ref) {
  return DeleteNote(ref.watch(noteRepositoryProvider));
});

final syncNotesProvider = Provider<SyncNotes>((ref) {
  return SyncNotes(ref.watch(noteRepositoryProvider));
});

/// Note Notifier
final noteNotifierProvider =
AsyncNotifierProvider<NoteNotifier, List<Note>>(
  NoteNotifier.new,
);