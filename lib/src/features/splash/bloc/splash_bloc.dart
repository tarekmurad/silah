import 'package:bloc/bloc.dart';

import '../../../core/utils/global_config.dart';
import '../../../injection_container.dart';
import '../../auth/data/repositories/authentication_repository_impl.dart';
import 'bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepositoryImpl _authenticationRepository;

  SplashBloc(this._authenticationRepository) : super(InitialSplashState()) {
    on<GetUserInfo>((event, emit) async {
      emit(LoadingState());

      final userToken = await _authenticationRepository.getUserToken();
      getIt<GlobalConfig>().token = userToken;

      if (userToken.isNotEmpty) {
        emit(NavigateToHomeScreenState());
      } else {
        emit(NavigateToSignUpScreenState());
      }
    });
  }
}
