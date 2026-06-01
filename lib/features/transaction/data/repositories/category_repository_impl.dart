import 'package:sqflite/sqflite.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import 'package:dio/dio.dart';

import '../model/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final Dio _dio; // inject this

  CategoryRepositoryImpl(this._dio);

  Future<Database> get _db => AppDatabase.database;

  @override
  Future<List<CategoryEntity>?> getLocalCategories() async {
    final db = await _db;
    final rows = await db.query(
      DbTables.categories,
      where: 'is_deleted = ?',
      whereArgs: [0],
      orderBy: 'name ASC',
    );
    return rows.map(CategoryModel.fromMap).toList();
  }

  @override
  Future<void> addCategory(CategoryEntity category) async {
    final db = await _db;
    await db.insert(
      DbTables.categories,
      CategoryModel.fromEntity(category).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> softDeleteCategory(String id) async {
    final db = await _db;
    await db.update(
      DbTables.categories,
      {'is_deleted': 1, 'is_synced': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<CategoryEntity>> getUnsyncedCategories() async {
    final db = await _db;
    final rows = await db.query(
      DbTables.categories,
      where: 'is_synced = ? AND is_deleted = ?',
      whereArgs: [0, 0],
    );
    return rows.map(CategoryModel.fromMap).toList();
  }

  @override
  Future<List<CategoryEntity>> getDeletedCategories() async {
    final db = await _db;
    final rows = await db.query(
      DbTables.categories,
      where: 'is_deleted = ?',
      whereArgs: [1],
    );
    return rows.map(CategoryModel.fromMap).toList();
  }

  @override
  Future<void> markSynced(List<String> ids) async {
    if (ids.isEmpty) return;
    final db = await _db;
    final batch = db.batch();
    for (final id in ids) {
      batch.update(
        DbTables.categories,
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> hardDeleteCategories(List<String> ids) async {
    if (ids.isEmpty) return;
    final db = await _db;
    final placeholders = ids.map((_) => '?').join(', ');
    await db.delete(
      DbTables.categories,
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }

  /// Upsert categories fetched from cloud (used during pull sync)
  Future<void> upsertFromCloud(List<CategoryEntity> categories) async {
    final db = await _db;
    final batch = db.batch();
    for (final cat in categories) {
      batch.insert(
        DbTables.categories,
        CategoryModel.fromEntity(cat).toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> remoteDelete(List<String> ids) async {
    await _dio.delete(
      '/categories/delete/',
      data: {'ids': ids},
    );
  }

  @override
  Future<List<String>> remoteAdd(List<CategoryEntity> categories) async {
    final List<String> syncedIds = [];
    for (final cat in categories) {
      try {
        final response = await _dio.post(
          '/categories/add/',
          data: {
            'category_id': cat.id,
            'name': cat.name,
          },
        );
        final ids = List<String>.from(response.data['synced_ids']);
        syncedIds.addAll(ids);
      } on DioException catch (e) {
        final message = e.response?.data['message'] ?? '';
        if (message == 'Category already exists') {
          // Already on the cloud — just mark it as synced locally
          syncedIds.add(cat.id);
        } else {
          rethrow; // real errors should still bubble up
        }
      }
    }
    return syncedIds;
  }
}