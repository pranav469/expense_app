import '../repositories/category_repository.dart';
import '../repositories/transaction_repository.dart';


class SyncUsecase {
  final TransactionRepository _txnRepo;
  final CategoryRepository _catRepo;

  SyncUsecase(this._txnRepo, this._catRepo);

  /// Step A: Cloud purge → local hard delete (transactions before categories)
  Future<void> purgeDeleted() async {
    // Transactions first to avoid FK constraint issues
    // final deletedTxns = await _txnRepo.getPendingDeletion();
    // if (deletedTxns.isNotEmpty) {
    //   final ids = deletedTxns.map((t) => t.id).toList();
    //   await _txnRepo.remoteDelete(ids);
    //   await _txnRepo.hardDelete(ids);
    // }
    //
    // // Categories after transactions
    // final deletedCats = await _catRepo.getPendingDeletion();
    // if (deletedCats.isNotEmpty) {
    //   final ids = deletedCats.map((c) => c.id).toList();
    //   await _catRepo.remoteDelete(ids);
    //   await _catRepo.hardDelete(ids);
    // }
  }

  /// Step B1: Upload unsynced categories
  Future<void> syncCategories() async {
    // final unsynced = await _catRepo.getUnsynced();
    // if (unsynced.isEmpty) return;
    // final syncedIds = await _catRepo.remoteAdd(unsynced);
    // if (syncedIds.isNotEmpty) {
    //   await _catRepo.markSynced(syncedIds);
    // }
  }

  /// Step B2: Upload unsynced transactions (run after syncCategories)
  Future<void> syncTransactions() async {
  //   final unsynced = await _txnRepo.getUnsynced();
  //   if (unsynced.isEmpty) return;
  //   final syncedIds = await _txnRepo.remoteAdd(unsynced);
  //   if (syncedIds.isNotEmpty) {
  //     await _txnRepo.markSynced(syncedIds);
  //   }
   }
}


// // domain/usecases/sync_usecase.dart
// import '../../../category/domain/repository/category_repository.dart';
// import '../repositories/transaction_repository.dart';
//
// class SyncUsecase {
//   final TransactionRepository _txnRepo;
//   final CategoryRepository _catRepo;
//
//   SyncUsecase(this._txnRepo, this._catRepo);
//
//   Future<void> purgeDeleted() async {
//     // Transactions first (FK constraint), then categories
//     final deletedTxns = await _txnRepo.getPendingDeletion();
//     if (deletedTxns.isNotEmpty) {
//       final ids = deletedTxns.map((t) => t.id).toList();
//       await _txnRepo.remoteDelete(ids);   // DELETE /transactions/delete/
//       await _txnRepo.hardDelete(ids);     // DELETE FROM transactions
//     }
//
//     final deletedCats = await _catRepo.getPendingDeletion();
//     if (deletedCats.isNotEmpty) {
//       final ids = deletedCats.map((c) => c.id).toList();
//       await _catRepo.remoteDelete(ids);   // DELETE /categories/delete/
//       await _catRepo.hardDelete(ids);
//     }
//   }
//
//   Future<void> syncCategories() async {
//     final unsynced = await _catRepo.getUnsynced();
//     if (unsynced.isEmpty) return;
//     final syncedIds = await _catRepo.remoteAdd(unsynced);   // POST /categories/add/
//     await _catRepo.markSynced(syncedIds);
//   }
//
//   Future<void> syncTransactions() async {
//     final unsynced = await _txnRepo.getUnsynced();
//     if (unsynced.isEmpty) return;
//     final syncedIds = await _txnRepo.remoteAdd(unsynced);   // POST /transactions/add/
//     await _txnRepo.markSynced(syncedIds);
//   }
// }