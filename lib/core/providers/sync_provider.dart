import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/notes/presentation/providers/providers.dart';
import '../services/sync_service.dart';

final syncServiceProvider =
Provider<SyncService>((ref){

  return SyncService(

      ref.watch(noteRepositoryProvider)

  );

});