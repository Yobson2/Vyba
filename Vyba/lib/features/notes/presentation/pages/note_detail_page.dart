import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/extensions/context_extensions.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/layout/app_app_bar.dart';
import 'package:flutter_templates/features/notes/presentation/providers/notes_notifier.dart';
import 'package:flutter_templates/features/notes/presentation/providers/notes_providers.dart';
import 'package:flutter_templates/features/notes/presentation/providers/notes_state.dart';
import 'package:go_router/go_router.dart';

/// Page for creating or editing a note.
class NoteDetailPage extends ConsumerStatefulWidget {
  /// Creates a [NoteDetailPage].
  ///
  /// Pass [noteId] to edit an existing note, or leave null to create new.
  const NoteDetailPage({super.key, this.noteId});

  /// ID of the note to edit. Null for creating a new note.
  final String? noteId;

  @override
  ConsumerState<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends ConsumerState<NoteDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.noteId != null) {
      _isEditing = true;
      _loadNote();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadNote() async {
    final repository = ref.read(notesRepositoryProvider);
    final result = await repository.getNoteById(widget.noteId!);
    result.fold(
      (failure) {
        if (mounted) {
          context.showSnackBar(failure.message, isError: true);
          context.pop();
        }
      },
      (note) {
        if (mounted) {
          _titleController.text = note.title;
          _contentController.text = note.content;
          setState(() => _isLoading = false);
        }
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<NotesState>(notesNotifierProvider, (_, state) {
      switch (state) {
        case NotesSuccess():
          context.pop();
        case NotesError(:final message):
          context.showSnackBar(message, isError: true);
        default:
          break;
      }
    });

    final notesState = ref.watch(notesNotifierProvider);
    final isSaving = notesState is NotesLoading;

    return Scaffold(
      appBar: AppAppBar(
        title: _isEditing ? 'Edit Note' : 'New Note',
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: isSaving ? null : _deleteNote,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: AppSpacing.paddingLg,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter note title',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.verticalLg,
                  TextFormField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      hintText: 'Write your note...',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 10,
                    minLines: 5,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Content is required';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.verticalXl,
                  FilledButton(
                    onPressed: isSaving ? null : _saveNote,
                    child: isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(_isEditing ? 'Update' : 'Create'),
                  ),
                ],
              ),
            ),
    );
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (_isEditing) {
      ref.read(notesNotifierProvider.notifier).updateNote(
            id: widget.noteId!,
            title: title,
            content: content,
          );
    } else {
      ref.read(notesNotifierProvider.notifier).createNote(
            title: title,
            content: content,
          );
    }
  }

  void _deleteNote() {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(notesNotifierProvider.notifier).deleteNote(widget.noteId!);
      }
    });
  }
}
