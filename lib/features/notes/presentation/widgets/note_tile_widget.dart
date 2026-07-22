import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_notes/features/notes/presentation/widgets/sync_status_chip.dart';

import '../../domain/entities/note.dart';
import '../pages/add_edit_note_page.dart';
import '../providers/providers.dart';

class NoteTile extends ConsumerWidget {
  final Note note;

  const NoteTile({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SyncStatusChip(
                  status: note.syncStatus,
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Body
            Text(
              note.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 12),

            /// Last Updated
            Text(
              "Updated: ${note.updatedAt}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),

            const Divider(height: 20),

            /// Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: "Edit",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditNotePage(
                          note: note,
                        ),
                      ),
                    );
                  },
                ),

                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  tooltip: "Delete",
                  onPressed: () async {
                    final shouldDelete =
                        await showDialog<bool>(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: const Text("Delete Note"),
                              content: const Text(
                                "Are you sure you want to delete this note?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            );
                          },
                        ) ??
                            false;

                    if (!shouldDelete) return;

                    await ref
                        .read(noteNotifierProvider.notifier)
                        .deleteNote(note.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}