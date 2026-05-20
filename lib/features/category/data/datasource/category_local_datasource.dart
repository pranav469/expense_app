import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables.dart';
import '../models/category_model.dart';

class CategoryLocalDatasource {
  Future<void> addCategory(
      CategoryModel category,
      ) async {
    final Database db =
    await AppDatabase.database;

    await db.insert(
      DbTables.categories,
      category.toMap(),
    );
  }

  Future<List<CategoryModel>>
  getCategories() async {
    final Database db =
    await AppDatabase.database;

    final result = await db.query(
      DbTables.categories,
      where: 'is_deleted = ?',
      whereArgs: [0],
      orderBy: 'name ASC',
    );

    return result
        .map(
          (e) => CategoryModel.fromMap(e),
    )
        .toList();
  }

  Future<void> softDeleteCategory(
      String id,
      ) async {
    final Database db =
    await AppDatabase.database;

    await db.update(
      DbTables.categories,
      {
        'is_deleted': 1,
        'is_synced': 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}