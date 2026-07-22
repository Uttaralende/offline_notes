import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/emptyNotesWidget.dart';
import '../widgets/note_tile_widget.dart';
import 'add_edit_note_page.dart';
// import '../widgets/note_tile.dart';
// import '../widgets/empty_notes_widget.dart';
// import 'add_edit_note_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesState = ref.watch(noteNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Offline Notes"),
        centerTitle: true,
      ),

      body: notesState.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const EmptyNotesWidget();
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(noteNotifierProvider.notifier).loadNotes();
            },
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return NoteTile(
                  note: notes[index],
                );
              },
            ),
          );
        },

        loading: () =>
        const Center(
          child: CircularProgressIndicator(),
        ),

        error: (error, stackTrace) =>
            Center(
              child: Text(error.toString()),
            ),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditNotePage(),
            ),
          );
        },
      ),
    );
  }
}