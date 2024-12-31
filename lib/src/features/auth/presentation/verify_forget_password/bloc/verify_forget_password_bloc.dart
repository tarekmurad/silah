import 'package:bloc/bloc.dart';

import '../../../data/repositories/authentication_repository_impl.dart';
import 'bloc.dart';

class VerifyForgetPasswordBloc
    extends Bloc<VerificationEvent, VerificationState> {
  AuthRepositoryImpl authRepository;

  VerifyForgetPasswordBloc(this.authRepository)
      : super(InitialVerificationState()) {
    on<VerificationCodeChanged>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    VerificationCodeChanged event,
    Emitter<VerificationState> emit,
  ) async {
    emit(VerifyAccountLoadingState());

    // try {
    final result =
        await authRepository.verifyForgetPassword(event.email, event.code);

    if (result.hasDataOnly) {
      emit(VerifyAccountSucceedState());
    } else if (result.hasErrorOnly) {
      emit(VerifyAccountFailedState());
    }
    // } catch (e) {
    //   print(e);
    //   emit(VerifyAccountFailedState());
    // }
  }
}
