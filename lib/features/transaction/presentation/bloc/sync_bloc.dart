import 'package:bloc/bloc.dart';
import 'package:expense_manager/features/transaction/presentation/bloc/sync_event.dart';
import 'package:expense_manager/features/transaction/presentation/bloc/sync_state.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/sync_usecase.dart';


class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncUsecase _syncUsecase;

  SyncBloc(this._syncUsecase) : super(SyncIdle()) {
    on<TriggerSync>(_onSync);
  }

  Future<void> _onSync(TriggerSync event, Emitter<SyncState> emit) async {
    try {
      // Step A: purge soft-deleted records from cloud, then hard delete locally
      emit(const SyncInProgress('Cleaning deletions...'));
      await _syncUsecase.purgeDeleted();

      // Step B1: sync categories first (transactions depend on them)
      emit(const SyncInProgress('Syncing categories...'));
      await _syncUsecase.syncCategories();

      // Step B2: sync transactions after categories are confirmed synced
      emit(const SyncInProgress('Syncing transactions...'));
      await _syncUsecase.syncTransactions();

      emit(SyncSuccess());
    } catch (e) {
      emit(SyncFailure(e.toString()));
    }
  }
}

//import '../../domain/usecases/sync_usecase.dart';

// class SyncBloc extends Bloc<SyncEvent, SyncState> {
//   final SyncUsecase _syncUsecase;
//   SyncBloc(this._syncUsecase) : super(SyncIdle()) {
//     on<TriggerSync>(_onSync);
//   }
//
//   Future<void> _onSync(TriggerSync event, Emitter<SyncState> emit) async {
//     emit( SyncInProgress('Cleaning up deletions...'));
//     try {
//       // Step A: purge soft-deleted from cloud, then hard-delete locally
//       await _syncUsecase.purgeDeleted();
//
//       emit( SyncInProgress('Syncing categories...'));
//       // Step B1: categories first
//       await _syncUsecase.syncCategories();
//
//       emit( SyncInProgress('Syncing transactions...'));
//       // Step B2: transactions after categories are confirmed synced
//       await _syncUsecase.syncTransactions();
//
//       emit(SyncSuccess());
//     } catch (e) {
//       emit(SyncFailure(e.toString()));
//     }
//   }
// }