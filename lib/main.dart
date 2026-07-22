import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:offline_notes/features/notes/presentation/pages/home_page.dart';

import 'core/sync_widget.dart';
import 'features/notes/data/models/note_model.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(NoteModelAdapter());

  await Hive.openBox<NoteModel>('notes');

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SyncBootstrap(
        child: const HomePage(),
      ),
    );
  }
}
