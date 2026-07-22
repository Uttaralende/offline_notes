import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/note.dart';
import '../providers/providers.dart';

class AddEditNotePage extends ConsumerStatefulWidget {
  final Note? note;

  const AddEditNotePage({
    super.key,
    this.note,
  });

  @override
  ConsumerState<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends ConsumerState<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  final uuid = const Uuid();

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.note?.title ?? '',
    );

    _bodyController = TextEditingController(
      text: widget.note?.body ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    final note = Note(
      id: isEditing ? widget.note!.id : uuid.v4(),
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),

      updatedAt: DateTime.now(),

      version: isEditing
          ? widget.note!.version + 1
          : 1,

      isDeleted: false,

      // Every local change becomes pending until synced
      syncStatus: SyncStatus.pending,
    );

    final notifier = ref.read(noteNotifierProvider.notifier);

    if (isEditing) {
      await notifier.updateNote(note);
    } else {
      await notifier.addNote(note);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Note" : "Add Note",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              TextFormField(
                controller: _titleController,

                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Title is required";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              Expanded(
                child: TextFormField(
                  controller: _bodyController,

                  maxLines: null,

                  expands: true,

                  textAlignVertical: TextAlignVertical.top,

                  decoration: const InputDecoration(
                    labelText: "Body",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Body is required";
                    }

                    return null;
                  },
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: _saveNote,

                  icon: const Icon(Icons.save),

                  label: Text(
                    isEditing
                        ? "Update Note"
                        : "Save Note",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}