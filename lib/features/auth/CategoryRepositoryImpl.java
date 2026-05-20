import '../../domain/repository/category_repository.dart';
import '../datasource/category_local_datasource.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl
    implements CategoryRepository {
  final CategoryLocalDatasource
      localDatasource;

  CategoryRepositoryImpl(
    this.localDatasource,
  );

  @override
  Future<void> addCategory(
    CategoryModel category,
  ) {
    return localDatasource
        .addCategory(category);
  }

  @override
  Future<List<CategoryModel>>
      getCategories() {
    return localDatasource
        .getCategories();
  }

  @override
  Future<void> softDeleteCategory(
    String id,
  ) {
    return localDatasource
        .softDeleteCategory(id);
  }
}