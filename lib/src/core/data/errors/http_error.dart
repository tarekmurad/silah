import 'base_error.dart';

class HttpError extends BaseError {
  final String? message;

  HttpError({this.message});

  @override
  List<Object> get props => [];
}
