import 'package:equatable/equatable.dart';
import 'package:expense_manager/features/transaction/domain/entities/transaction_entity.dart';

class DashboardEntity extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final List<TransactionEntity> recentTransactions;

  const DashboardEntity({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.recentTransactions,
  });

  @override
  List<Object?> get props =>
      [totalIncome, totalExpense, balance, recentTransactions];
}