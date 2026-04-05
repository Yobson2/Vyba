import 'package:drift/drift.dart';

/// Drift table definition for notes.
class Notes extends Table {
  /// Client-generated UUID. Serves as local primary key.
  TextColumn get id => text()();

  /// Server-assigned ID. Null until first sync.
  TextColumn get serverId => text().nullable()();

  /// Note title.
  TextColumn get title => text().withLength(min: 1, max: 500)();

  /// Note content body.
  TextColumn get content => text()();

  /// When the note was originally created.
  DateTimeColumn get createdAt => dateTime()();

  /// When the note was last updated.
  DateTimeColumn get updatedAt => dateTime()();

  /// Whether this note has been synced to the server.
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
