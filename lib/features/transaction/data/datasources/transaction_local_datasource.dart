// features/transactions/data/datasources/transaction_local_datasource.dart
import '../../../../core/database/local_db_helper.dart';

class TransactionLocalDatasource {
  final LocalDbHelper _dbHelper;
  TransactionLocalDatasource(this._dbHelper);

  // SQL JOIN — fetches category name alongside each transaction
  Future<List<Map<String, dynamic>>> getTransactionsWithCategory() async {
    final db = await _dbHelper.database;
    return db.rawQuery('''
      SELECT 
        t.id, t.amount, t.note, t.type,
        t.category_id, t.timestamp, t.is_synced, t.is_deleted,
        c.name AS category_name
      FROM transactions t
      INNER JOIN categories c ON t.category_id = c.id
      WHERE t.is_deleted = 0
      ORDER BY t.timestamp DESC
    ''');
  }

  Future<void> insertTransaction(Map<String, dynamic> data) async {
    final db = await _dbHelper.database;
    await db.insert('transactions', data,);
  }

  Future<void> softDelete(String id) async {
    final db = await _dbHelper.database;
    await db.update('transactions', {'is_deleted': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getUnsynced() async {
    final db = await _dbHelper.database;
    return db.query('transactions', where: 'is_synced = 0 AND is_deleted = 0');
  }

  Future<List<Map<String, dynamic>>> getPendingDeletion() async {
    final db = await _dbHelper.database;
    return db.query('transactions', where: 'is_deleted = 1');
  }

  Future<void> markSynced(List<String> ids) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (final id in ids) {
      batch.update('transactions', {'is_synced': 1}, where: 'id = ?', whereArgs: [id]);
    }
    await batch.commit(noResult: true);
  }

  Future<void> hardDelete(List<String> ids) async {
    final db = await _dbHelper.database;
    final placeholders = List.filled(ids.length, '?').join(',');
    await db.rawDelete('DELETE FROM transactions WHERE id IN ($placeholders)', ids);
  }
}