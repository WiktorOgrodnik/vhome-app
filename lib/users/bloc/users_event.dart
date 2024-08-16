part of 'users_bloc.dart';

sealed class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

final class UsersSubscriptionRequested extends UsersEvent {
  const UsersSubscriptionRequested();
}

final class UsersUploadProfilePictureRequested extends UsersEvent {
  const UsersUploadProfilePictureRequested();
}
