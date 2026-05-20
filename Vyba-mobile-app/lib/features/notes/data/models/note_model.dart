import 'package:drift/drift.dart' as drift;
import 'package:flutter_templates/core/database/app_database.dart' as db;
import 'package:flutter_templates/features/notes/domain/entities/note.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

/// Data model for [Note] with JSON serialization and Drift conversion.
@freezed
abstract class NoteModel with _$NoteModel {
  const NoteModel._();

  const factory NoteModel({
    required String id,
    @JsonKey(name: 'server_id') String? serverId,
    required String title,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(true)
    bool isSynced,
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  /// Creates a [NoteModel] from a Drift database row.
  factory NoteModel.fromDrift(db.Note row) => NoteModel(
        id: row.id,
        serverId: row.serverId,
        title: row.title,
        content: row.content,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        isSynced: row.isSynced,
      );

  /// Converts to a domain [Note] entity.
  Note toEntity() => Note(
        id: id,
        title: title,
        content: content,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isSynced: isSynced,
      );

  /// Creates from a domain [Note] entity.
  static NoteModel fromEntity(Note entity) => NoteModel(
        id: entity.id,
        title: entity.title,
        content: entity.content,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        isSynced: entity.isSynced,
      );

  /// Converts to a Drift table companion for insert/update.
  db.NotesCompanion toDriftCompanion({required bool isSynced}) {
    return db.NotesCompanion(
      id: drift.Value(id),
      serverId: drift.Value(serverId),
      title: drift.Value(title),
      content: drift.Value(content),
      createdAt: drift.Value(createdAt),
      updatedAt: drift.Value(updatedAt),
      isSynced: drift.Value(isSynced),
    );
  }
}
