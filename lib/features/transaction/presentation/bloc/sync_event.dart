import'package:equatable/equatable.dart';

//part of 'sync_bloc.dart';

abstract class SyncEvent extends Equatable {
  const SyncEvent();
  @override
  List<Object?> get props => [];
}

class TriggerSync extends SyncEvent {
  const TriggerSync();
}