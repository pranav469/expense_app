import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../../transaction/domain/repositories/transaction_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final TransactionRepository _txnRepo;

  DashboardRepositoryImpl(this._txnRepo);

  @override
  Future<DashboardEntity> getDashboardStats() async {
    print('REACHED HERE');
    final recent = await _txnRepo.getRecentTransactions();
    final all = await _txnRepo.getTransactions();

    double income = 0;
    double expense = 0;
    for (final txn in all) {
      if (txn.isCredit) {
        income += txn.amount;
      } else {
        expense += txn.amount;
      }
    }

    return DashboardEntity(
      totalIncome: income,
      totalExpense: expense,
      recentTransactions: recent, balance: 1,
    );
  }
}