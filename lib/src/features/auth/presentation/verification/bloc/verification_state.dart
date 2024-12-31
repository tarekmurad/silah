abstract class VerificationState {}

class InitialVerificationState extends VerificationState {}

/// check user info

class VerifyAccountLoadingState extends VerificationState {}

class VerifyAccountSucceedState extends VerificationState {}

class VerifyAccountFailedState extends VerificationState {}
