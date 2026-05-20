import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/notes/domain/entities/note.dart';
import 'package:flutter_templates/features/notes/domain/repositories/notes_repository.dart';

/// Updates an existing note. Works offline by saving locally and queuing.
class UpdateNoteUseCase extends UseCase<Note, UpdateNoteParams> {
  /// Creates an [UpdateNoteUseCase].
  const UpdateNoteUseCase(this._repository);

  final NotesRepository _repository;

  @override
  Future<Either<Failure, Note>> call(UpdateNoteParams params) {
    return _repository.updateNote(
      id: params.id,
      title: params.title,
      content: params.content,
    );
  }
}

/// Parameters for [UpdateNoteUseCase].
class UpdateNoteParams {
  /// Creates [UpdateNoteParams].
  const UpdateNoteParams({
    required this.id,
    required this.title,
    required this.content,
  });

  /// ID of the note to update.
  final String id;

  /// Updated title.
  final String title;

  /// Updated content.
  final String content;
}
