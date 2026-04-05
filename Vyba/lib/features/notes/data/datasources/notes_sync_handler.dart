import 'dart:convert';

import 'package:flutter_templates/core/sync/sync_engine.dart';
import 'package:flutter_templates/features/notes/data/datasources/notes_local_datasource.dart';
import 'package:flutter_templates/features/notes/data/datasources/notes_remote_datasource.dart';
import 'package:flutter_templates/features/notes/data/models/note_model.dart';

/// Handles sync operations for the notes feature.
///
/// Registered with [SyncEngine] to process note-related queue entries.
class NotesSyncHandler implements SyncHandler {
  /// Creates a [NotesSyncHandler].
  const NotesSyncHandler({
    required NotesRemoteDataSource remoteDataSource,
    required NotesLocalDataSource localDataSource,
  })  : _remote = remoteDataSource,
        _local = localDataSource;

  final NotesRemoteDataSource _remote;
  final NotesLocalDataSource _local;

  @override
  String get entityType => 'note';

  @override
  Future<String> pushCreate(String entityId, String payload) async {
    final model = NoteModel.fromJson(
      json.decode(payload) as Map<String, dynamic>,
    );
    final serverModel = await _remote.createNote(model);
    await _local.markSynced(entityId, serverId: serverModel.serverId);
    return serverModel.serverId ?? entityId;
  }

  @override
  Future<void> pushUpdate(String entityId, String payload) async {
    final model = NoteModel.fromJson(
      json.decode(payload) as Map<String, dynamic>,
    );
    await _remote.updateNote(model);
    await _local.markSynced(entityId);
  }

  @override
  Future<void> pushDelete(String entityId) async {
    await _remote.deleteNote(entityId);
  }

  @override
  Future<String?> fetchRemote(String entityId) async {
    try {
      final model = await _remote.getNoteById(entityId);
      return json.encode(model.toJson());
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> applyServerVersion(
    String entityId,
    String serverPayload,
  ) async {
    final model = NoteModel.fromJson(
      json.decode(serverPayload) as Map<String, dynamic>,
    );
    await _local.saveNote(model, isSynced: true);
  }
}
