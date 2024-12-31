import '../../../data/models/folder.dart';

abstract class LibraryEvent {}

class GetLibrary extends LibraryEvent {
  final String? parentId;

  GetLibrary({
    required this.parentId,
  });
}

class SearchLibrary extends LibraryEvent {
  final String searchText;

  SearchLibrary({
    required this.searchText,
  });
}

class UpdateProgress extends LibraryEvent {
  final String fileId;
  final int progress;

  UpdateProgress({
    required this.fileId,
    required this.progress,
  });
}

class DownloadFile extends LibraryEvent {
  final Folder file;

  DownloadFile({
    required this.file,
  });
}

class GetDownloadsList extends LibraryEvent {}

class GetFavoritesList extends LibraryEvent {}

class InteractFavorites extends LibraryEvent {
  final String type;
  final String file;

  InteractFavorites({
    required this.type,
    required this.file,
  });
}
