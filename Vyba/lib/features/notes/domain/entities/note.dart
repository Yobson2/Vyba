import 'package:flutter/foundation.dart';

/// Domain entity representing a note.
@immutable
class Note {
  /// Creates a [Note].
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = true,
  });

  /// Client-generated UUID (local primary key).
  final String id;

  /// Note title.
  final String title;

  /// Note content body.
  final String content;

  /// When the note was originally created.
  final DateTime createdAt;

  /// When the note was last updated.
  final DateTime updatedAt;

  /// Whether this note has been synced to the server.
  final bool isSynced;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
