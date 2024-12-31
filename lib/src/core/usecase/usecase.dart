import 'package:equatable/equatable.dart';

import '../data/errors/base_error.dart';
import '../data/models/results/result.dart';

abstract class UseCase<Type, Params> {
  Future<Result<BaseError, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
