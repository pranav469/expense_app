import 'package:sqflite/sqflite.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../model/transaction_model.dart';
import 'package:dio/dio.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final Dio _dio; // inject this

  TransactionRepositoryImpl(this._dio);

  Future<Database> get _db => AppDatabase.database;

  // SQL JOIN to fetch category name alongside each transaction
  static const String _joinQuery = '''
    SELECT 
      t.id, t.amount, t.note, t.type, 
      t.category_id, t.timestamp, t.is_synced, t.is_deleted,
      c.name AS category_name
    FROM ${DbTables.transactions} t
    LEFT JOIN ${DbTables.categories} c ON t.category_id = c.id
    WHERE t.is_deleted = 0
  ''';

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final db = await _db;
    final rows = await db.rawQuery('$_joinQuery ORDER BY t.timestamp DESC');
    return rows.map(TransactionModel.fromJoinMap).toList();
  }

  @override
  Future<List<TransactionEntity>> getRecentTransactions({int limit = 10}) async {
    final db = await _db;
    final rows = await db.rawQuery(
      '$_joinQuery ORDER BY t.timestamp DESC LIMIT ?',
      [limit],
    );
    return rows.map(TransactionModel.fromJoinMap).toList();
  }

  @override
  Future<void> addTransaction(TransactionEntity txn) async {
    final db = await _db;
    await db.insert(
      DbTables.transactions,
      TransactionModel.fromEntity(txn).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> softDelete(String id) async {
    final db = await _db;
    await db.update(
      DbTables.transactions,
      {'is_deleted': 1, 'is_synced': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<TransactionEntity>> getUnsynced() async {
    final db = await _db;
    final rows = await db.rawQuery('''
      SELECT 
        t.id, t.amount, t.note, t.type, 
        t.category_id, t.timestamp, t.is_synced, t.is_deleted,
        c.name AS category_name
      FROM ${DbTables.transactions} t
      LEFT JOIN ${DbTables.categories} c ON t.category_id = c.id
      WHERE t.is_synced = 0 AND t.is_deleted = 0
    ''');
    return rows.map(TransactionModel.fromJoinMap).toList();
  }

  // @override
  // Future<List<TransactionEntity>> getDeletedTransactions() async {
  //   final db = await _db;
  //   final rows = await db.query(
  //     DbTables.transactions,
  //     where: 'is_deleted = ?',
  //     whereArgs: [1],
  //   );
  //   return rows
  //       .map((m) => TransactionModel.fromJoinMap({...m, 'category_name': ''}))
  //       .toList();
  // }

  @override
  Future<void> markSynced(List<String> ids) async {
    print('REACHED DB');
    if (ids.isEmpty) return;
    final db = await _db;
    final batch = db.batch();
    for (final id in ids) {
      print('INSIDE LOOP');
      batch.update(
        DbTables.transactions,
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> hardDelete(List<String> ids) async {
    if (ids.isEmpty) return;
    final db = await _db;
    final placeholders = ids.map((_) => '?').join(', ');
    await db.delete(
      DbTables.transactions,
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }

  @override
  Future<double> getCurrentMonthDebitTotal() async {
    final db = await _db;
    final now = DateTime.now();
    final startOfMonth =
    DateTime(now.year, now.month, 1).toIso8601String();
    final endOfMonth =
    DateTime(now.year, now.month + 1, 0, 23, 59, 59).toIso8601String();
    final result = await db.rawQuery('''
      SELECT COALESCE(SUM(amount), 0) AS total
      FROM ${DbTables.transactions}
      WHERE type = 'debit'
        AND is_deleted = 0
        AND timestamp >= ?
        AND timestamp <= ?
    ''', [startOfMonth, endOfMonth]);
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<List<TransactionEntity>> getPendingDeletion() async {
    final db = await _db;
    final rows = await db.query(
      DbTables.transactions,
      where: 'is_deleted = ?',
      whereArgs: [1],
    );
    return rows
        .map((m) => TransactionModel.fromJoinMap({...m, 'category_name': ''}))
        .toList();
  }

  @override
  Future<void> remoteDelete(List<String> ids) async {
    await _dio.delete(
      '/transactions/delete/',
      data: {'ids': ids},
    );
    // throws on non-2xx, so no need to check manually
  }

  @override
  Future<List<String>> remoteAdd(List<TransactionEntity> transactions) async {
    final payload = transactions.map((t) => {
      'id': t.id,
      'amount': t.amount,
      'note': t.note,
      'type': t.type,
      'category_id': t.categoryId,
      'timestamp': t.timestamp.toIso8601String()
          .replaceFirst('T', ' ')
          .split('.')[0], // "2023-10-27 10:00:00" format the API expects
    }).toList();

    final response = await _dio.post(
      '/transactions/add/',
      data: {'transactions': payload},
    );

    print('RES ${response.data['transactions']}');
    final ids = transactions.map((t) => t.id).toList();
    return ids;


    // final transactionsList = response.data['transactions'] as List;
    // return transactionsList.map((t) => t['id'] as String).toList();
  }
}