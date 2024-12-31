abstract class HomeState {}

class InitialHomeState extends HomeState {}

/// check user info

class GetUserInfoLoadingState extends HomeState {}

class GetUserInfoSucceedState extends HomeState {}

class GetUserInfoFailedState extends HomeState {}
