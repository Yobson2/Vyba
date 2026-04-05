import 'package:dio/dio.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';
import 'package:flutter_templates/features/notes/data/models/note_model.dart';

/// Remote data source for notes API calls.
abstract class NotesRemoteDataSource {
  /// Fetches all notes from the server.
  Future<List<NoteModel>> getAllNotes();

  /// Fetches a single note by ID.
  Future<NoteModel> getNoteById(String id);

  /// Creates a note on the server.
  Future<NoteModel> createNote(NoteModel note);

  /// Updates a note on the server.
  Future<NoteModel> updateNote(NoteModel note);

  /// Deletes a note on the server.
  Future<void> deleteNote(String id);
}

/// Implementation using [Dio] HTTP client.
class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  /// Creates a [NotesRemoteDataSourceImpl].
  const NotesRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<NoteModel>> getAllNotes() async {
    try {
      final response = await _dio.get<List<dynamic>>(ApiEndpoints.notes);
      final data = response.data;
      if (data == null) return [];
      return data
          .cast<Map<String, dynamic>>()
          .map(NoteModel.fromJson)
          .toList();
    } on DioException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<NoteModel> getNoteById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiEndpoints.notes}/$id',
      );
      return NoteModel.fromJson(response.data!);
    } on DioException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<NoteModel> createNote(NoteModel note) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.notes,
        data: note.toJson(),
      );
      return NoteModel.fromJson(response.data!);
    } on DioException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '${ApiEndpoints.notes}/${note.serverId ?? note.id}',
        data: note.toJson(),
      );
      return NoteModel.fromJson(response.data!);
    } on DioException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await _dio.delete<void>('${ApiEndpoints.notes}/$id');
    } on DioException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

/// Mock implementation for development without a backend.
class MockNotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  static const _delay = Duration(milliseconds: 800);

  final List<NoteModel> _notes = [];

  @override
  Future<List<NoteModel>> getAllNotes() async {
    await Future<void>.delayed(_delay);
    return List.unmodifiable(_notes);
  }

  @override
  Future<NoteModel> getNoteById(String id) async {
    await Future<void>.delayed(_delay);
    try {
      return _notes.firstWhere(
        (n) => n.id == id || n.serverId == id,
      );
    } catch (_) {
      throw const ServerException(
        message: 'Note not found',
        statusCode: 404,
      );
    }
  }

  @override
  Future<NoteModel> createNote(NoteModel note) async {
    await Future<void>.delayed(_delay);
    final serverNote = NoteModel(
      id: note.id,
      serverId: 'server_${note.id}',
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
    );
    _notes.add(serverNote);
    return serverNote;
  }

  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    await Future<void>.delayed(_delay);
    _notes.removeWhere((n) => n.id == note.id || n.serverId == note.serverId);
    _notes.add(note);
    return note;
  }

  @override
  Future<void> deleteNote(String id) async {
    await Future<void>.delayed(_delay);
    _notes.removeWhere((n) => n.id == id || n.serverId == id);
  }
}
