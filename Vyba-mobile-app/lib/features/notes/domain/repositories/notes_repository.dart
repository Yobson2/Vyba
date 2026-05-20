import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/notes/domain/entities/note.dart';

/// Abstract notes repository defined in the domain layer.
abstract class NotesRepository {
  /// Gets all notes from local storage.
  Future<Either<Failure, List<Note>>> getNotes();

  /// Watches all notes reactively (for stream-based UI updates).
  Stream<List<Note>> watchNotes();

  /// Gets a single note by ID.
  Future<Either<Failure, Note>> getNoteById(String id);

  /// Creates a new note. Saves locally and queues for sync.
  Future<Either<Failure, Note>> createNote({
    required String title,
    required String content,
  });

  /// Updates an existing note. Saves locally and queues for sync.
  Future<Either<Failure, Note>> updateNote({
    required String id,
    required String title,
    required String content,
  });

  /// Deletes a note. Removes locally and queues for sync.
  Future<Either<Failure, void>> deleteNote(String id);

  /// Triggers a full refresh from the server (pull-to-refresh).
  Future<Either<Failure, void>> refreshFromServer();
}
