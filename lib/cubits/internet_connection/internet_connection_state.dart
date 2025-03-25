part of 'internet_connection_cubit.dart';

@immutable
sealed class InternetConnectionState {}

final class InternetConnectionInitial extends InternetConnectionState {}
final class InternetConnectionChangedState extends InternetConnectionState {}
final class InternetConnectionLoadingState extends InternetConnectionState {}
