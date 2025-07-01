import 'package:bloc/bloc.dart';

import '../../../../../core/data/errors/http_error.dart';
import '../../../data/repositories/authentication_repository_impl.dart';
import 'bloc.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  AuthRepositoryImpl authRepository;

  VerificationBloc(this.authRepository) : super(InitialVerificationState()) {
    on<VerificationCodeChanged>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    VerificationCodeChanged event,
    Emitter<VerificationState> emit,
  ) async {
    emit(VerifyAccountLoadingState());

    // try {
    final result = await authRepository.verify(
        event.name, event.email, event.password, event.code);

    if (result.hasDataOnly) {
      emit(VerifyAccountSucceedState());
    } else if (result.hasErrorOnly) {
      if (result.error is HttpError) {
        emit(VerifyAccountFailedState(
            message: (result.error as HttpError).message));
      } else {
        emit(VerifyAccountFailedState());
      }
    }

    // } catch (e) {
    //   print(e);
    //   emit(VerifyAccountFailedState());
    // }
  }
}
