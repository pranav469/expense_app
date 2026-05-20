import'package:equatable/equatable.dart';

abstract class SyncState extends Equatable {
  const SyncState();
  @override
  List<Object?> get props => [];
}

class SyncIdle extends SyncState {}

class SyncInProgress extends SyncState {
  final String message;
  const SyncInProgress(this.message);
  @override
  List<Object?> get props => [message];
}

class SyncSuccess extends SyncState {}

class SyncFailure extends SyncState {
  final String error;
  const SyncFailure(this.error);
  @override
  List<Object?> get props => [error];
}