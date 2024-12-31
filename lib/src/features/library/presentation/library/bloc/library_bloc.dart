import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';

import '../../../data/models/folder.dart';
import '../../../data/repositories/library_repository_impl.dart';
import 'bloc.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryRepositoryImpl libraryRepository;

  LibraryBloc(this.libraryRepository) : super(InitialLibraryState()) {
    on<GetLibrary>(_onGetLibrary);
    on<SearchLibrary>(_onSearchLibrary);
    on<UpdateProgress>(_onUpdateProgress);
    on<DownloadFile>(_onDownloadFile);
    on<GetDownloadsList>(_onGetDownloadsList);
    on<GetFavoritesList>(_onGetFavoritesList);
    on<InteractFavorites>(_onInteractFavorites);
  }

  Future<void> _onGetLibrary(
    GetLibrary event,
    Emitter<LibraryState> emit,
  ) async {
    emit(GetLibraryLoadingState());

    // try {
    final result = await libraryRepository.getMediaFolders(event.parentId);

    if (result.hasDataOnly) {
      emit(GetLibrarySucceedState(folders: result.data!.folders!));
    } else if (result.hasErrorOnly) {
      emit(GetLibraryFailedState());
    }
    // } catch (e) {
    //   emit(GetLibraryFailedState());
    // }
  }

  Future<void> _onSearchLibrary(
    SearchLibrary event,
    Emitter<LibraryState> emit,
  ) async {
    emit(GetLibraryLoadingState());

    // try {
    final result = await libraryRepository.searchLibrary(event.searchText);

    if (result.hasDataOnly) {
      emit(GetLibrarySucceedState(folders: result.data!.folders!));
    } else if (result.hasErrorOnly) {
      emit(GetLibraryFailedState());
    }
    // } catch (e) {
    //   emit(GetLibraryFailedState());
    // }
  }

  Future<void> _onUpdateProgress(
    UpdateProgress event,
    Emitter<LibraryState> emit,
  ) async {
    emit(UpdateProgressLoadingState());

    // try {
    final result =
        await libraryRepository.updateProgress(event.fileId, event.progress);

    if (result.hasDataOnly) {
      emit(UpdateProgressSucceedState());
    } else if (result.hasErrorOnly) {
      emit(UpdateProgressFailedState());
    }
    // } catch (e) {
    //   emit(GetLibraryFailedState());
    // }
  }

  Future<void> _onDownloadFile(
    DownloadFile event,
    Emitter<LibraryState> emit,
  ) async {
    emit(DownloadFileLoadingState());

    final result = await libraryRepository.downloadFile(event.file);

    if (result.statusCode == 200) {
      final box = Hive.box<Folder>('downloads');
      await box.put(event.file.id, event.file);
      emit(DownloadFileSucceedState());
    } else {
      emit(DownloadFileFailedState());
    }
  }

  Future<void> _onGetDownloadsList(
    GetDownloadsList event,
    Emitter<LibraryState> emit,
  ) async {
    emit(GetDownloadListLoadingState());

    Box<Folder> _downloadsBox = Hive.box<Folder>('downloads');
    emit(GetDownloadListSucceedState(folders: _downloadsBox.values.toList()));
  }

  Future<void> _onGetFavoritesList(
    GetFavoritesList event,
    Emitter<LibraryState> emit,
  ) async {
    emit(GetFavoritesListLoadingState());

    // try {
    final result = await libraryRepository.getFavoritesList();

    if (result.hasDataOnly) {
      emit(GetFavoritesListSucceedState(folders: result.data!.folders!));
    } else if (result.hasErrorOnly) {
      emit(GetFavoritesListFailedState());
    }
    // } catch (e) {
    //   emit(GetLibraryFailedState());
    // }
  }

  Future<void> _onInteractFavorites(
    InteractFavorites event,
    Emitter<LibraryState> emit,
  ) async {
    emit(InteractFavoritesLoadingState());

    // try {
    final result =
        await libraryRepository.interactionFavorites(event.file, event.type);

    if (result.hasDataOnly) {
      emit(InteractFavoritesSucceedState());
    } else if (result.hasErrorOnly) {
      emit(InteractFavoritesFailedState());
    }
    // } catch (e) {
    //   emit(GetLibraryFailedState());
    // }
  }
}
