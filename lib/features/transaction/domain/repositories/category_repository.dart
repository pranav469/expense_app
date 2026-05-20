// domain/repositories/category_repository.dart
import '../../domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>?> getLocalCategories();
  Future<void> addCategory(CategoryEntity category);
  Future<void> softDeleteCategory(String id);
  Future<List<CategoryEntity>> getUnsyncedCategories();
  Future<List<CategoryEntity>> getDeletedCategories();
  Future<void> markSynced(List<String> ids);
  Future<void> hardDeleteCategories(List<String> ids);
}