import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/notes/domain/entities/note.dart';
import 'package:flutter_templates/features/notes/domain/repositories/notes_repository.dart';

/// Creates a new note. Works offline by saving locally and queuing for sync.
class CreateNoteUseCase extends UseCase<Note, CreateNoteParams> {
  /// Creates a [CreateNoteUseCase].
  const CreateNoteUseCase(this._repository);

  final NotesRepository _repository;

  @override
  Future<Either<Failure, Note>> call(CreateNoteParams params) {
    return _repository.createNote(
      title: params.title,
      content: params.content,
    );
  }
}

/// Parameters for [CreateNoteUseCase].
class CreateNoteParams {
  /// Creates [CreateNoteParams].
  const CreateNoteParams({required this.title, required this.content});

  /// Note title.
  final String title;

  /// Note content.
  final String content;
}
