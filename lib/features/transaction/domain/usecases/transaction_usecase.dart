import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository _repo;
  AddTransaction(this._repo);
  Future<void> call(TransactionEntity txn) => _repo.addTransaction(txn);
}

class GetTransactions {
  final TransactionRepository _repo;
  GetTransactions(this._repo);
  Future<List<TransactionEntity>> call() => _repo.getTransactions();
}

class GetRecentTransactions {
  final TransactionRepository _repo;
  GetRecentTransactions(this._repo);
  Future<List<TransactionEntity>> call({int limit = 10}) =>
      _repo.getRecentTransactions(limit: limit);
}

class SoftDeleteTransaction {
  final TransactionRepository _repo;
  SoftDeleteTransaction(this._repo);
  Future<void> call(String id) => _repo.softDelete(id);
}

class CheckBudgetLimit {
  final TransactionRepository _repo;
  CheckBudgetLimit(this._repo);

  /// Returns true if total monthly debits exceed the threshold
  Future<bool> call() async {
    final total = await _repo.getCurrentMonthDebitTotal();
    return total > 1000.0;
  }
}