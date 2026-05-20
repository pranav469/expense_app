import 'package:expense_manager/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:expense_manager/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/uuid.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/usecases/transaction_usecase.dart';


class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final AddTransaction _addTransaction;
  final GetTransactions _getTransactions;
  final SoftDeleteTransaction _softDelete;
  final CheckBudgetLimit _checkBudgetLimit;
  final NotificationService _notificationService;

  TransactionBloc({
    required AddTransaction addTransaction,
    required GetTransactions getTransactions,
    required SoftDeleteTransaction softDelete,
    required CheckBudgetLimit checkBudgetLimit,
    required NotificationService notificationService,
  })  : _addTransaction = addTransaction,
        _getTransactions = getTransactions,
        _softDelete = softDelete,
        _checkBudgetLimit = checkBudgetLimit,
        _notificationService = notificationService,
        super(TransactionInitial()) {
    on<LoadTransactions>(_onLoad);
    on<AddTransactionEvent>(_onAdd);
    on<DeleteTransactionEvent>(_onDelete);
  }

  Future<void> _onLoad(
      LoadTransactions event, Emitter<TransactionState> emit) async {
    print('taking trans');
    emit(TransactionLoading());
    try {
      final txns = await _getTransactions();
      emit(TransactionLoaded(txns));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onAdd(
      AddTransactionEvent event, Emitter<TransactionState> emit) async {
    try {
      final newTxn = TransactionEntity(
        id: UuidHelper.generate(), // UUID generated locally
        amount: event.amount,
        note: event.note,
        type: event.type,
        categoryId: event.categoryId,
        categoryName: '', // will be populated after reload
        timestamp: DateTime.now(),
        isSynced: false,
      );

      await _addTransaction(newTxn);

      // Optimistic update: reload from DB to get category name via JOIN
      final txns = await _getTransactions();
      emit(TransactionLoaded(txns));

      // Budget limit check only for debit
      if (event.type == 'debit') {
        final exceeded = await _checkBudgetLimit();
        if (exceeded) {
          final total = txns
              .where((t) =>
          t.type == 'debit' &&
              t.timestamp.month == DateTime.now().month &&
              t.timestamp.year == DateTime.now().year)
              .fold(0.0, (sum, t) => sum + t.amount);
          await _notificationService.showBudgetAlert(total);
        }
      }
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onDelete(
      DeleteTransactionEvent event, Emitter<TransactionState> emit) async {
    try {
      await _softDelete(event.id);

      // Instant reactive removal from UI — no reload needed
      if (state is TransactionLoaded) {
        final current = (state as TransactionLoaded).transactions;
        emit(TransactionLoaded(
          current.where((t) => t.id != event.id).toList(),
        ));
      }
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}

// import 'package:bloc/bloc.dart';
// import 'package:expense_manager/features/transaction/presentation/bloc/transaction_event.dart';
// import 'package:expense_manager/features/transaction/presentation/bloc/transaction_state.dart';
//
// class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
//   final AddTransaction _addTransaction;
//   final GetTransactions _getTransactions;
//   final SoftDeleteTransaction _softDelete;
//   final NotificationService _notificationService;
//   final CheckBudgetLimit _checkBudgetLimit;
//
//   TransactionBloc({
//     required AddTransaction addTransaction,
//     required GetTransactions getTransactions,
//     required SoftDeleteTransaction softDelete,
//     required NotificationService notificationService,
//     required CheckBudgetLimit checkBudgetLimit,
//   })  : _addTransaction = addTransaction,
//         _getTransactions = getTransactions,
//         _softDelete = softDelete,
//         _notificationService = notificationService,
//         _checkBudgetLimit = checkBudgetLimit,
//         super(TransactionInitial()) {
//     on<LoadTransactions>(_onLoad);
//     on<AddTransactionEvent>(_onAdd);
//     on<DeleteTransactionEvent>(_onDelete);
//   }
//
//   Future<void> _onLoad(LoadTransactions event, Emitter<TransactionState> emit) async {
//     emit(TransactionLoading());
//     try {
//       final txns = await _getTransactions();
//       emit(TransactionLoaded(txns));
//     } catch (e) {
//       emit(TransactionError(e.toString()));
//     }
//   }
//
//   Future<void> _onAdd(AddTransactionEvent event, Emitter<TransactionState> emit) async {
//     final newTxn = TransactionEntity(
//       id: UuidHelper.generate(),        // local UUID
//       amount: event.amount,
//       note: event.note,
//       type: event.type,
//       categoryId: event.categoryId,
//       categoryName: '',
//       timestamp: DateTime.now(),
//       isSynced: false,
//     );
//     await _addTransaction(newTxn);
//
//     // Optimistic update — instant UI
//     if (state is TransactionLoaded) {
//       final current = (state as TransactionLoaded).transactions;
//       emit(TransactionLoaded([newTxn, ...current]));
//     }
//
//     // Budget alert for debit transactions
//     if (event.type == 'debit') {
//       final exceeded = await _checkBudgetLimit();
//       if (exceeded) await _notificationService.showBudgetAlert();
//     }
//   }
//
//   Future<void> _onDelete(DeleteTransactionEvent event, Emitter<TransactionState> emit) async {
//     await _softDelete(event.id);
//
//     // Instant reactive removal from UI
//     if (state is TransactionLoaded) {
//       final current = (state as TransactionLoaded).transactions;
//       emit(TransactionLoaded(current.where((t) => t.id != event.id).toList()));
//     }
//   }
// }