import 'package:sqflite/sqflite.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables.dart';
import '../../../category/data/models/category_model.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
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
}