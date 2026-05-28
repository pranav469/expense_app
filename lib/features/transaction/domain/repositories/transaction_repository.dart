 import '../entities/transaction_entity.dart';

 abstract class TransactionRepository {
   Future<List<TransactionEntity>> getTransactions();
   Future<List<TransactionEntity>> getRecentTransactions({int limit = 10});
   Future<void> addTransaction(TransactionEntity txn);
   Future<void> softDelete(String id);
   Future<List<TransactionEntity>> getUnsynced();

   // ADD THESE BACK:
   Future<List<TransactionEntity>> getPendingDeletion();
   Future<void> remoteDelete(List<String> ids);
   Future<List<String>> remoteAdd(List<TransactionEntity> transactions);

   Future<void> markSynced(List<String> ids);
   Future<void> hardDelete(List<String> ids);
   Future<double> getCurrentMonthDebitTotal();
 }

//
// abstract class TransactionRepository {
//   /// Fetches all non-deleted transactions with category names via SQL JOIN
//   Future<List<TransactionEntity>> getTransactions();
//
//   /// Fetches only the 10 most recent for dashboard
//   Future<List<TransactionEntity>> getRecentTransactions({int limit = 10});
//
//   Future<void> addTransaction(TransactionEntity txn);
//
//   /// Sets is_deleted = 1 (soft delete)
//   Future<void> softDelete(String id);
//
//   /// Records with is_synced = 0 AND is_deleted = 0
//   Future<List<TransactionEntity>> getUnsynced();
//
//   /// Records with is_deleted = 1, waiting to be purged from cloud
//  // Future<List<TransactionEntity>> getPendingDeletion();
//
//   /// Calls DELETE /transactions/delete/ then hard-deletes from SQLite
//  // Future<void> remoteDelete(List<String> ids);
//
//   /// Calls POST /transactions/add/ (batch)
//  // Future<List<String>> remoteAdd(List<TransactionEntity> transactions);
//
//   /// Updates is_synced = 1 for given IDs
//   Future<void> markSynced(List<String> ids);
//
//   /// Hard DELETE FROM transactions WHERE id IN (...)
//   Future<void> hardDelete(List<String> ids);
//
//   /// Sum of all debit amounts in the current calendar month
//   Future<double> getCurrentMonthDebitTotal();
// }