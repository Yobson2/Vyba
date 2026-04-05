import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/database/database_providers.dart';
import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/core/sync/sync_providers.dart';
import 'package:flutter_templates/features/notes/data/datasources/notes_local_datasource.dart';
import 'package:flutter_templates/features/notes/data/datasources/notes_remote_datasource.dart';
import 'package:flutter_templates/features/notes/data/datasources/notes_sync_handler.dart';
import 'package:flutter_templates/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:flutter_templates/features/notes/domain/entities/note.dart';
import 'package:flutter_templates/features/notes/domain/repositories/notes_repository.dart';
import 'package:flutter_templates/features/notes/domain/usecases/create_note_usecase.dart';
import 'package:flutter_templates/features/notes/domain/usecases/delete_note_usecase.dart';
import 'package:flutter_templates/features/notes/domain/usecases/get_notes_usecase.dart';
import 'package:flutter_templates/features/notes/domain/usecases/update_note_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_providers.g.dart';

/// Provides the [NotesRemoteDataSource].
///
/// Set `USE_MOCK_NOTES=true` in `.env` to use mock data.
@riverpod
NotesRemoteDataSource notesRemoteDataSource(Ref ref) {
  final useMock =
      dotenv.get('USE_MOCK_NOTES', fallback: 'false') == 'true';
  if (useMock) return MockNotesRemoteDataSourceImpl();
  return NotesRemoteDataSourceImpl(ref.watch(dioProvider));
}

/// Provides the [NotesLocalDataSource].
@riverpod
NotesLocalDataSource notesLocalDataSource(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return NotesLocalDataSourceImpl(
    notesDao: db.notesDao,
    syncQueueDao: db.syncQueueDao,
  );
}

/// Provides the [NotesSyncHandler] and registers it with the SyncEngine.
@riverpod
NotesSyncHandler notesSyncHandler(Ref ref) {
  final handler = NotesSyncHandler(
    remoteDataSource: ref.watch(notesRemoteDataSourceProvider),
    localDataSource: ref.watch(notesLocalDataSourceProvider),
  );

  // Register this handler with the sync engine.
  ref.watch(syncEngineProvider).registerHandler(handler);

  return handler;
}

/// Provides the [NotesRepository].
@riverpod
NotesRepository notesRepository(Ref ref) {
  // Ensure sync handler is registered.
  ref.watch(notesSyncHandlerProvider);

  return NotesRepositoryImpl(
    remoteDataSource: ref.watch(notesRemoteDataSourceProvider),
    localDataSource: ref.watch(notesLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

/// Watches notes reactively from the local database.
@riverpod
Stream<List<Note>> notesStream(Ref ref) {
  final repository = ref.watch(notesRepositoryProvider);
  return repository.watchNotes();
}

/// Provides the [CreateNoteUseCase].
@riverpod
CreateNoteUseCase createNoteUseCase(Ref ref) {
  return CreateNoteUseCase(ref.watch(notesRepositoryProvider));
}

/// Provides the [UpdateNoteUseCase].
@riverpod
UpdateNoteUseCase updateNoteUseCase(Ref ref) {
  return UpdateNoteUseCase(ref.watch(notesRepositoryProvider));
}

/// Provides the [DeleteNoteUseCase].
@riverpod
DeleteNoteUseCase deleteNoteUseCase(Ref ref) {
  return DeleteNoteUseCase(ref.watch(notesRepositoryProvider));
}

/// Provides the [GetNotesUseCase].
@riverpod
GetNotesUseCase getNotesUseCase(Ref ref) {
  return GetNotesUseCase(ref.watch(notesRepositoryProvider));
}
