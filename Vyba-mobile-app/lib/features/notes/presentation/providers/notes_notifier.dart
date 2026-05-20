import 'package:flutter_templates/features/notes/domain/usecases/create_note_usecase.dart';
import 'package:flutter_templates/features/notes/domain/usecases/update_note_usecase.dart';
import 'package:flutter_templates/features/notes/presentation/providers/notes_providers.dart';
import 'package:flutter_templates/features/notes/presentation/providers/notes_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_notifier.g.dart';

/// Manages notes mutation state (create, update, delete).
///
/// Notes list is handled reactively via [notesStreamProvider].
/// This notifier handles one-shot operations and their status.
@riverpod
class NotesNotifier extends _$NotesNotifier {
  @override
  NotesState build() => const NotesState.initial();

  /// Creates a new note.
  Future<void> createNote({
    required String title,
    required String content,
  }) async {
    state = const NotesState.loading();
    try {
      final result = await ref.read(createNoteUseCaseProvider).call(
            CreateNoteParams(title: title, content: content),
          );
      state = result.fold(
        (failure) => NotesState.error(failure.message),
        (note) => const NotesState.success(message: 'Note created'),
      );
    } catch (e) {
      state = NotesState.error(e.toString());
    }
  }

  /// Updates an existing note.
  Future<void> updateNote({
    required String id,
    required String title,
    required String content,
  }) async {
    state = const NotesState.loading();
    try {
      final result = await ref.read(updateNoteUseCaseProvider).call(
            UpdateNoteParams(id: id, title: title, content: content),
          );
      state = result.fold(
        (failure) => NotesState.error(failure.message),
        (note) => const NotesState.success(message: 'Note updated'),
      );
    } catch (e) {
      state = NotesState.error(e.toString());
    }
  }

  /// Deletes a note.
  Future<void> deleteNote(String id) async {
    state = const NotesState.loading();
    try {
      final result = await ref.read(deleteNoteUseCaseProvider).call(id);
      state = result.fold(
        (failure) => NotesState.error(failure.message),
        (_) => const NotesState.success(message: 'Note deleted'),
      );
    } catch (e) {
      state = NotesState.error(e.toString());
    }
  }

  /// Refreshes notes from the server (pull-to-refresh).
  Future<void> refreshFromServer() async {
    try {
      final repository = ref.read(notesRepositoryProvider);
      final result = await repository.refreshFromServer();
      result.fold(
        (failure) => state = NotesState.error(failure.message),
        (_) => state = const NotesState.success(message: 'Notes refreshed'),
      );
    } catch (e) {
      state = NotesState.error(e.toString());
    }
  }

  /// Loads a single note by ID.
  Future<void> loadNote(String id) async {
    state = const NotesState.loading();
    try {
      final repository = ref.read(notesRepositoryProvider);
      final result = await repository.getNoteById(id);
      state = result.fold(
        (failure) => NotesState.error(failure.message),
        NotesState.loaded,
      );
    } catch (e) {
      state = NotesState.error(e.toString());
    }
  }
}
