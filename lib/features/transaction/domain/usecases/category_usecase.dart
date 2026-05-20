import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository _repo;
  GetCategories(this._repo);
  Future<List<CategoryEntity>?> call() => _repo.getLocalCategories();
}

class AddCategory {
  final CategoryRepository _repo;
  AddCategory(this._repo);
  Future<void> call(CategoryEntity category) => _repo.addCategory(category);
}

class SoftDeleteCategory {
  final CategoryRepository _repo;
  SoftDeleteCategory(this._repo);
  Future<void> call(String id) => _repo.softDeleteCategory(id);
}