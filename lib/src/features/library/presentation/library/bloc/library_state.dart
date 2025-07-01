import '../../../data/models/folder.dart';

abstract class LibraryState {}

class InitialLibraryState extends LibraryState {}

/// Get Library

class GetLibraryLoadingState extends LibraryState {}

class GetLibrarySucceedState extends LibraryState {
  final List<Folder> folders;

  GetLibrarySucceedState({
    required this.folders,
  });
}

class GetLibraryFailedState extends LibraryState {}

/// Get Library Category

class GetLibraryCategoryLoadingState extends LibraryState {}

class GetLibraryCategorySucceedState extends LibraryState {
  final List<Folder> folders;

  GetLibraryCategorySucceedState({
    required this.folders,
  });
}

class GetLibraryCategoryFailedState extends LibraryState {}

/// Search Library

class UpdateProgressLoadingState extends LibraryState {}

class UpdateProgressSucceedState extends LibraryState {}

class UpdateProgressFailedState extends LibraryState {}

/// Download File

class DownloadFileLoadingState extends LibraryState {}

class DownloadFileSucceedState extends LibraryState {}

class DownloadFileFailedState extends LibraryState {}

/// Get Download List

class GetDownloadListLoadingState extends LibraryState {}

class GetDownloadListSucceedState extends LibraryState {
  final List<Folder> folders;

  GetDownloadListSucceedState({
    required this.folders,
  });
}

class GetDownloadListFailedState extends LibraryState {}

/// Get Favorites List

class GetFavoritesListLoadingState extends LibraryState {}

class GetFavoritesListSucceedState extends LibraryState {
  final List<Folder> folders;

  GetFavoritesListSucceedState({
    required this.folders,
  });
}

class GetFavoritesListFailedState extends LibraryState {}

/// Download File

class InteractFavoritesLoadingState extends LibraryState {}

class InteractFavoritesSucceedState extends LibraryState {}

class InteractFavoritesFailedState extends LibraryState {}

/// Get Subtitle

class GetSubtitleLoadingState extends LibraryState {}

class GetSubtitleSucceedState extends LibraryState {
  final String subtitle;

  GetSubtitleSucceedState({
    required this.subtitle,
  });
}

class GetSubtitleFailedState extends LibraryState {}
