// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notesRemoteDataSourceHash() =>
    r'd43ec64e8f7865df1ab5e8e6fe0ee1f3f8180b0d';

/// Provides the [NotesRemoteDataSource].
///
/// Set `USE_MOCK_NOTES=true` in `.env` to use mock data.
///
/// Copied from [notesRemoteDataSource].
@ProviderFor(notesRemoteDataSource)
final notesRemoteDataSourceProvider =
    AutoDisposeProvider<NotesRemoteDataSource>.internal(
  notesRemoteDataSource,
  name: r'notesRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notesRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotesRemoteDataSourceRef
    = AutoDisposeProviderRef<NotesRemoteDataSource>;
String _$notesLocalDataSourceHash() =>
    r'a46fa74fe9b394f2a134c3d2d0204e515c5cc4cd';

/// Provides the [NotesLocalDataSource].
///
/// Copied from [notesLocalDataSource].
@ProviderFor(notesLocalDataSource)
final notesLocalDataSourceProvider =
    AutoDisposeProvider<NotesLocalDataSource>.internal(
  notesLocalDataSource,
  name: r'notesLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notesLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotesLocalDataSourceRef = AutoDisposeProviderRef<NotesLocalDataSource>;
String _$notesSyncHandlerHash() => r'65b0bc022993511f0b70b26c345b34c852b86cdd';

/// Provides the [NotesSyncHandler] and registers it with the SyncEngine.
///
/// Copied from [notesSyncHandler].
@ProviderFor(notesSyncHandler)
final notesSyncHandlerProvider = AutoDisposeProvider<NotesSyncHandler>.internal(
  notesSyncHandler,
  name: r'notesSyncHandlerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notesSyncHandlerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotesSyncHandlerRef = AutoDisposeProviderRef<NotesSyncHandler>;
String _$notesRepositoryHash() => r'ed5b65d8f734df440ba2f1f04ac28ce4b928f5d5';

/// Provides the [NotesRepository].
///
/// Copied from [notesRepository].
@ProviderFor(notesRepository)
final notesRepositoryProvider = AutoDisposeProvider<NotesRepository>.internal(
  notesRepository,
  name: r'notesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotesRepositoryRef = AutoDisposeProviderRef<NotesRepository>;
String _$notesStreamHash() => r'4ff0397cb4e8d24c4ef6c63b851881c28786e06a';

/// Watches notes reactively from the local database.
///
/// Copied from [notesStream].
@ProviderFor(notesStream)
final notesStreamProvider = AutoDisposeStreamProvider<List<Note>>.internal(
  notesStream,
  name: r'notesStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$notesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotesStreamRef = AutoDisposeStreamProviderRef<List<Note>>;
String _$createNoteUseCaseHash() => r'f60d49be9aff8c6996e68311321b50f751caa156';

/// Provides the [CreateNoteUseCase].
///
/// Copied from [createNoteUseCase].
@ProviderFor(createNoteUseCase)
final createNoteUseCaseProvider =
    AutoDisposeProvider<CreateNoteUseCase>.internal(
  createNoteUseCase,
  name: r'createNoteUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createNoteUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateNoteUseCaseRef = AutoDisposeProviderRef<CreateNoteUseCase>;
String _$updateNoteUseCaseHash() => r'7de73448074e59d68f805535367bcbcd2a7df1c4';

/// Provides the [UpdateNoteUseCase].
///
/// Copied from [updateNoteUseCase].
@ProviderFor(updateNoteUseCase)
final updateNoteUseCaseProvider =
    AutoDisposeProvider<UpdateNoteUseCase>.internal(
  updateNoteUseCase,
  name: r'updateNoteUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateNoteUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateNoteUseCaseRef = AutoDisposeProviderRef<UpdateNoteUseCase>;
String _$deleteNoteUseCaseHash() => r'bf271c8d7f8653299d3b1ab07bf1578ac0c3999b';

/// Provides the [DeleteNoteUseCase].
///
/// Copied from [deleteNoteUseCase].
@ProviderFor(deleteNoteUseCase)
final deleteNoteUseCaseProvider =
    AutoDisposeProvider<DeleteNoteUseCase>.internal(
  deleteNoteUseCase,
  name: r'deleteNoteUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteNoteUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteNoteUseCaseRef = AutoDisposeProviderRef<DeleteNoteUseCase>;
String _$getNotesUseCaseHash() => r'7b8e6ab825aa656988e5fd3c5adc9f4f7307cf7e';

/// Provides the [GetNotesUseCase].
///
/// Copied from [getNotesUseCase].
@ProviderFor(getNotesUseCase)
final getNotesUseCaseProvider = AutoDisposeProvider<GetNotesUseCase>.internal(
  getNotesUseCase,
  name: r'getNotesUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getNotesUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetNotesUseCaseRef = AutoDisposeProviderRef<GetNotesUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
