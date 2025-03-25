part of 'withdraw_cubit.dart';

@immutable
sealed class WithdrawState {}

final class WithdrawInitial extends WithdrawState {}
final class WithdrawChangedState extends WithdrawState {}
final class WithdrawLoadingState extends WithdrawState {}
final class WithdrawLoadingInfoState extends WithdrawState {}
final class WithdrawFailState extends WithdrawState {}
