import 'package:bloc/bloc.dart';

import '../../../../auth/data/repositories/authentication_repository_impl.dart';
import 'bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepositoryImpl _authenticationRepository;

  ProfileBloc(this._authenticationRepository) : super(InitialProfileState()) {
    on<Logout>((event, emit) async {
      emit(LogoutLoadingState());

      // try {
      String deviceId = await _authenticationRepository.getAppGUID();
      final result = await _authenticationRepository.logout(deviceId);

      if (result.hasDataOnly) {
        await _authenticationRepository.clearUserInfo();

        emit(LogoutSucceed());
      } else if (result.hasErrorOnly) {
        emit(LogoutFailed());
      }
      // } catch (e) {
      //   emit(LogoutFailed());
      // }
    });
  }
}
