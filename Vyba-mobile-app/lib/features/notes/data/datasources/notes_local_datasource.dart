import 'package:flutter_templates/core/database/daos/sync_queue_dao.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/features/notes/data/daos/notes_dao.dart';
import 'package:flutter_templates/features/notes/data/models/note_model.dart';

/// Local data source for notes using Drift database.
abstract class NotesLocalDataSource {
  /// Watches all notes reactively.
  Stream<List<NoteModel>> watchNotes();

  /// Gets all notes.
  Future<List<NoteModel>> getNotes();

  /// Gets a single note by ID.
  Future<NoteModel?> getNoteById(String id);

  /// Saves a note to the local database.
  Future<void> saveNote(NoteModel note, {required bool isSynced});

  /// Deletes a note from the local database.
  Future<void> deleteNote(String id);

  /// Enqueues a sync operation for background processing.
  Future<void> enqueueSync({
    required String entityId,
    required String operation,
    String? payload,
  });

  /// Replaces all local notes with server data (full refresh).
  Future<void> replaceAllFromServer(List<NoteModel> notes);

  /// Marks a note as synced after successful server push.
  Future<void> markSynced(String id, {String? serverId});
}

/// Implementation using Drift [NotesDao] and [SyncQueueDao].
class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  /// Creates a [NotesLocalDataSourceImpl].
  const NotesLocalDataSourceImpl({
    required NotesDao notesDao,
    required SyncQueueDao syncQueueDao,
  })  : _notesDao = notesDao,
        _syncQueueDao = syncQueueDao;

  final NotesDao _notesDao;
  final SyncQueueDao _syncQueueDao;

  @override
  Stream<List<NoteModel>> watchNotes() {
    return _notesDao.watchAll().map(
          (rows) => rows.map(NoteModel.fromDrift).toList(),
        );
  }

  @override
  Future<List<NoteModel>> getNotes() async {
    try {
      final rows = await _notesDao.getAll();
      return rows.map(NoteModel.fromDrift).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get notes: $e');
    }
  }

  @override
  Future<NoteModel?> getNoteById(String id) async {
    final row = await _notesDao.getById(id);
    return row != null ? NoteModel.fromDrift(row) : null;
  }

  @override
  Future<void> saveNote(NoteModel note, {required bool isSynced}) async {
    try {
      await _notesDao.upsert(note.toDriftCompanion(isSynced: isSynced));
    } catch (e) {
      throw CacheException(message: 'Failed to save note: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await _notesDao.deleteById(id);
    } catch (e) {
      throw CacheException(message: 'Failed to delete note: $e');
    }
  }

  @override
  Future<void> enqueueSync({
    required String entityId,
    required String operation,
    String? payload,
  }) async {
    await _syncQueueDao.enqueue(
      entityType: 'note',
      entityId: entityId,
      operation: operation,
      payload: payload,
    );
  }

  @override
  Future<void> replaceAllFromServer(List<NoteModel> notes) async {
    final companions =
        notes.map((n) => n.toDriftCompanion(isSynced: true)).toList();
    await _notesDao.replaceAll(companions);
  }

  @override
  Future<void> markSynced(String id, {String? serverId}) async {
    await _notesDao.markSynced(id, serverId: serverId);
  }
}
