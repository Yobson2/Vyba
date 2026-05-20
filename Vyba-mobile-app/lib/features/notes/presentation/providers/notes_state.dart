import 'package:flutter_templates/features/notes/domain/entities/note.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notes_state.freezed.dart';

/// Represents the state for notes operations (create/update/delete).
@freezed
sealed class NotesState with _$NotesState {
  /// Initial idle state.
  const factory NotesState.initial() = NotesInitial;

  /// Loading state during an operation.
  const factory NotesState.loading() = NotesLoading;

  /// Operation completed successfully.
  const factory NotesState.success({String? message}) = NotesSuccess;

  /// A single note was loaded successfully.
  const factory NotesState.loaded(Note note) = NotesLoaded;

  /// An error occurred.
  const factory NotesState.error(String message) = NotesError;
}
