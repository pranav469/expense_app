import '../repositories/transaction_repository.dart';
import '../repositories/category_repository.dart';

class SyncUsecase {
  final TransactionRepository _txnRepo;
  final CategoryRepository _catRepo;

  SyncUsecase(this._txnRepo, this._catRepo);

  Future<void> purgeDeleted() async {
    print('START');
    final deletedTxns = await _txnRepo.getPendingDeletion();

    // Only send to API if they were previously synced to cloud
    final syncedDeletedTxns = deletedTxns.where((t) => t.isSynced == 1).toList();
    print('${deletedTxns.length} || ${syncedDeletedTxns.length}');
    if (syncedDeletedTxns.isNotEmpty) {
      print('1');
      final ids = syncedDeletedTxns.map((t) => t.id).toList();
      await _txnRepo.remoteDelete(ids);
    }

    // Hard delete ALL locally (synced or not — they're deleted either way)
    if (deletedTxns.isNotEmpty) {
      print('2');
      await _txnRepo.hardDelete(deletedTxns.map((t) => t.id).toList());
    }

    final deletedCats = await _catRepo.getDeletedCategories();

    final syncedDeletedCats = deletedCats.where((c) => c.isSynced == 1).toList();
    if (syncedDeletedCats.isNotEmpty) {
      print('3');
      final ids = syncedDeletedCats.map((c) => c.id).toList();
      await _catRepo.remoteDelete(ids);
    }

    if (deletedCats.isNotEmpty) {
      print('4');
      await _catRepo.hardDeleteCategories(deletedCats.map((c) => c.id).toList());
    }
  }

  Future<void> syncCategories() async {
    final unsynced = await _catRepo.getUnsyncedCategories();
    if (unsynced.isEmpty) return;
    final syncedIds = await _catRepo.remoteAdd(unsynced);
    if (syncedIds.isNotEmpty) {
      await _catRepo.markSynced(syncedIds);
    }
  }

  Future<void> syncTransactions() async {
    print('ENTERED');
    final unsynced = await _txnRepo.getUnsynced();
    print('UNSYNCED?? $unsynced');
    if (unsynced.isEmpty) return;
    final syncedIds = await _txnRepo.remoteAdd(unsynced);

    print('SYNCED ID $syncedIds');
    if (syncedIds.isNotEmpty) {
      await _txnRepo.markSynced(syncedIds);
    }
  }
}