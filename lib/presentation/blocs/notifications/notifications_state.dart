part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  final AuthorizationStatus status;
  final List<dynamic> notifiactions;

  const NotificationsState(
      {this.status = AuthorizationStatus.notDetermined,
      this.notifiactions = const []});

  NotificationsState copyWith(
          {AuthorizationStatus? status, List<dynamic>? notifiactions}) =>
      NotificationsState(
          notifiactions: notifiactions ?? this.notifiactions,
          status: status ?? this.status);

  @override
  List<Object> get props => [status, notifiactions];
}
