import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/data/errors/base_error.dart';
import '../../../../core/data/models/results/result.dart';
import '../dataSources/library_data_source.dart';
import '../models/folder.dart';
import '../models/library_item.dart';

class LibraryRepositoryImpl {
  final LibraryDataSourceImpl _libraryDataSource;

  LibraryRepositoryImpl(this._libraryDataSource);

  Future<Result<BaseError, LibraryItem>> getMediaFolders(
      String? parentId) async {
    final response = await _libraryDataSource.getMediaFolders(parentId);
    if (response!.isRight()) {
      return Result(data: (response as Right<BaseError, LibraryItem>).value);
    } else {
      return Result(error: (response as Left<BaseError, LibraryItem>).value);
    }
  }

  Future<Result<BaseError, LibraryItem>> searchLibrary(
      String searchText) async {
    final response = await _libraryDataSource.searchLibrary(searchText);
    if (response!.isRight()) {
      return Result(data: (response as Right<BaseError, LibraryItem>).value);
    } else {
      return Result(error: (response as Left<BaseError, LibraryItem>).value);
    }
  }

  Future<Result<BaseError, LibraryItem>> updateProgress(
      String fileId, int progress) async {
    final response = await _libraryDataSource.updateProgress(fileId, progress);
    if (response!.isRight()) {
      return Result(data: (response as Right<BaseError, LibraryItem>).value);
    } else {
      return Result(error: (response as Left<BaseError, LibraryItem>).value);
    }
  }

  Future<Response> downloadFile(Folder file) async {
    return await _libraryDataSource.downloadFile(file);
  }

  Future<Result<BaseError, LibraryItem>> getFavoritesList() async {
    final response = await _libraryDataSource.getFavoritesList();
    if (response!.isRight()) {
      return Result(data: (response as Right<BaseError, LibraryItem>).value);
    } else {
      return Result(error: (response as Left<BaseError, LibraryItem>).value);
    }
  }

  Future<Result<BaseError, LibraryItem>> interactionFavorites(
      String file, String type) async {
    final response = await _libraryDataSource.interactionFavorites(file, type);
    if (response!.isRight()) {
      return Result(data: (response as Right<BaseError, LibraryItem>).value);
    } else {
      return Result(error: (response as Left<BaseError, LibraryItem>).value);
    }
  }
}
