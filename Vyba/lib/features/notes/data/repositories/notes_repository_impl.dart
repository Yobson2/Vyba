import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/core/utils/logger.dart';
import 'package:flutter_templates/features/notes/data/datasources/notes_local_datasource.dart';
import 'package:flutter_templates/features/notes/data/datasources/notes_remote_datasource.dart';
import 'package:flutter_templates/features/notes/data/models/note_model.dart';
import 'package:flutter_templates/features/notes/domain/entities/note.dart';
import 'package:flutter_templates/features/notes/domain/repositories/notes_repository.dart';
import 'package:uuid/uuid.dart';

/// Offline-first repository implementation for notes.
///
/// All mutations write to the local Drift database first and
/// enqueue a sync operation. Reads always come from local DB.
class NotesRepositoryImpl implements NotesRepository {
  /// Creates a [NotesRepositoryImpl].
  const NotesRepositoryImpl({
    required NotesRemoteDataSource remoteDataSource,
    required NotesLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _local = localDataSource,
        _networkInfo = networkInfo;

  final NotesRemoteDataSource _remote;
  final NotesLocalDataSource _local;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    try {
      final localNotes = await _local.getNotes();

      // If online, trigger a background refresh (fire-and-forget).
      if (await _networkInfo.isConnected) {
        _refreshFromServerSilently();
      }

      return Right(localNotes.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Stream<List<Note>> watchNotes() {
    return _local.watchNotes().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<Either<Failure, Note>> getNoteById(String id) async {
    try {
      final model = await _local.getNoteById(id);
      if (model == null) {
        return const Left(CacheFailure(message: 'Note not found'));
      }
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Note>> createNote({
    required String title,
    required String content,
  }) async {
    try {
      final now = DateTime.now();
      final localId = const Uuid().v4();

      final model = NoteModel(
        id: localId,
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
        isSynced: false,
      );

      // 1. Save to local database immediately.
      await _local.saveNote(model, isSynced: false);

      // 2. Enqueue for sync.
      await _local.enqueueSync(
        entityId: localId,
        operation: 'create',
        payload: json.encode(model.toJson()),
      );

      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote({
    required String id,
    required String title,
    required String content,
  }) async {
    try {
      final existing = await _local.getNoteById(id);
      if (existing == null) {
        return const Left(CacheFailure(message: 'Note not found'));
      }

      final updated = NoteModel(
        id: id,
        serverId: existing.serverId,
        title: title,
        content: content,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      // 1. Save to local database immediately.
      await _local.saveNote(updated, isSynced: false);

      // 2. Enqueue for sync.
      await _local.enqueueSync(
        entityId: id,
        operation: 'update',
        payload: json.encode(updated.toJson()),
      );

      return Right(updated.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String id) async {
    try {
      // 1. Delete from local database immediately.
      await _local.deleteNote(id);

      // 2. Enqueue for sync.
      await _local.enqueueSync(
        entityId: id,
        operation: 'delete',
      );

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> refreshFromServer() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final remoteNotes = await _remote.getAllNotes();
      await _local.replaceAllFromServer(remoteNotes);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  /// Fire-and-forget server refresh. Errors are silently logged.
  Future<void> _refreshFromServerSilently() async {
    try {
      final remoteNotes = await _remote.getAllNotes();
      await _local.replaceAllFromServer(remoteNotes);
    } catch (e) {
      AppLogger.debug(
        'Background refresh failed: $e',
        tag: 'NotesRepository',
      );
    }
  }
}
