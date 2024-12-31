import 'package:bloc/bloc.dart';

import '../../../../auth/data/repositories/authentication_repository_impl.dart';
import 'bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepositoryImpl _authenticationRepository;

  ProfileBloc(this._authenticationRepository) : super(InitialProfileState()) {
    on<Logout>((event, emit) async {
      emit(LogoutLoadingState());

      try {
        await _authenticationRepository.clearUserInfo();
        emit(LogoutSucceed());
      } catch (e) {
        emit(LogoutFailed());
      }
    });
  }
}
