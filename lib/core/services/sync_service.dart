import '../../features/notes/domain/repositories/note_repository.dart';

class SyncService {

  SyncService(this.repository);

  final NoteRepository repository;

  bool _isSyncing = false;

  Future<void> sync() async {

    if(_isSyncing) return;

    _isSyncing = true;

    try{

      await repository.syncNotes();

    }finally{

      _isSyncing = false;

    }

  }

}