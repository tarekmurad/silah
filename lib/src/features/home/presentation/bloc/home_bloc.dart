import 'package:bloc/bloc.dart';

import '../../../../core/utils/global_config.dart';
import '../../../../injection_container.dart';
import '../../../auth/data/repositories/authentication_repository_impl.dart';
import 'bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepositoryImpl _authenticationRepository;

  HomeBloc(this._authenticationRepository) : super(InitialHomeState()) {
    on<Event>((event, emit) async {
      emit(InitialHomeState());
    });
    on<GetUserInfo>((event, emit) async {
      emit(GetUserInfoLoadingState());

      try {
        final result = await _authenticationRepository.getUserInfo();

        if (result.hasDataOnly) {
          getIt<GlobalConfig>().currentUser = result.data!;

          emit(GetUserInfoSucceedState());
        } else if (result.hasErrorOnly) {
          emit(GetUserInfoFailedState());
        }
      } catch (e) {
        emit(GetUserInfoFailedState());
      }
    });
  }
}
