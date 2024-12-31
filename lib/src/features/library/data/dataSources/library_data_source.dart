import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/constants/app_url.dart';
import '../../../../core/constants/endpoint_url.dart';
import '../../../../core/data/errors/base_error.dart';
import '../../../../core/data/http_helper.dart';
import '../models/folder.dart';
import '../models/library_item.dart';

class LibraryDataSourceImpl {
  final HttpHelper _httpHelper;

  LibraryDataSourceImpl(this._httpHelper);

  Future<Either<BaseError, LibraryItem>>? getMediaFolders(
      String? parentId) async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.getMediaFoldersUrl,
      withAuthentication: true,
      rawDataString: jsonEncode({
        'parentId': parentId,
      }),
    );

    return response!.fold(
      (error) => Left(error),
      (data) => Right(LibraryItem.fromJson(data.data!)),
    );
  }

  Future<Either<BaseError, LibraryItem>>? searchLibrary(
      String searchText) async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.searchLibraryUrl,
      withAuthentication: true,
      rawDataString: jsonEncode({
        'searchText': searchText,
      }),
    );

    return response!.fold(
      (error) => Left(error),
      (data) => Right(LibraryItem.fromJson(data.data!)),
    );
  }

  Future<Either<BaseError, LibraryItem>>? updateProgress(
      String fileId, int progress) async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.pushProgressUrl,
      withAuthentication: true,
      rawDataString: jsonEncode({
        'folderId': fileId,
        'progress': progress,
      }),
    );

    return response!.fold(
      (error) => Left(error),
      (data) => Right(LibraryItem.fromJson(data.data!)),
    );
  }

  Future<Response> downloadFile(Folder file) async {
    final response = await _httpHelper.downloadMediaFile(
        '${AppUrl.baseUrl}/media/${file.path}/${file.id}/${file.mediaFiles?[0].id}.${file.mediaFiles?[0].extension}',
        '${file.name!}.${file.mediaFiles?[0].extension}');

    return response;
  }

  Future<Either<BaseError, LibraryItem>>? getFavoritesList() async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.getFavoritesUrl,
      withAuthentication: true,
    );

    return response!.fold(
      (error) => Left(error),
      (data) => Right(LibraryItem.fromJson(data.data!)),
    );
  }

  Future<Either<BaseError, LibraryItem>>? interactionFavorites(
      String fileId, String type) async {
    final response = await _httpHelper.postRequest(
      EndpointUrl.interactionFavoritesUrl,
      withAuthentication: true,
      rawDataString: jsonEncode({
        'id': fileId,
        'reqType': type,
        "favoriteType": "FOLDER",
      }),
    );

    return response!.fold(
      (error) => Left(error),
      (data) => Right(LibraryItem.fromJson(data.data!)),
    );
  }
}
