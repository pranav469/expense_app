import '../../data/models/category_model.dart';

abstract class CategoryRepository {
  Future<void> addCategory(
      CategoryModel category,
      );

  Future<List<CategoryModel>>
  getCategories();

  Future<void> softDeleteCategory(
      String id,
      );
}