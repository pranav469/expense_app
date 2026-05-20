import'package:equatable/equatable.dart';

//part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {
  const LoadTransactions();
}

class AddTransactionEvent extends TransactionEvent {
  final double amount;
  final String note;
  final String type;
  final String categoryId;

  const AddTransactionEvent({
    required this.amount,
    required this.note,
    required this.type,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [amount, note, type, categoryId];
}

class DeleteTransactionEvent extends TransactionEvent {
  final String id;
  const DeleteTransactionEvent(this.id);
  @override
  List<Object?> get props => [id];
}

// abstract class TransactionEvent extends Equatable {
//   @override List<Object?> get props => [];
// }
// class LoadTransactions extends TransactionEvent {}
// class AddTransactionEvent extends TransactionEvent {
//   final String note, type, categoryId;
//   final double amount;
//   AddTransactionEvent({required this.note, required this.type, required this.categoryId, required this.amount});
//   @override List<Object?> get props => [note, type, categoryId, amount];
// }
// class DeleteTransactionEvent extends TransactionEvent {
//   final String id;
//   DeleteTransactionEvent(this.id);
//   @override List<Object?> get props => [id];
// }