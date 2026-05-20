import '../../data/models/category_model.dart';
import '../repository/category_repository.dart';

class DeleteCategoryUsecase {
  final CategoryRepository repository;

  DeleteCategoryUsecase(this.repository);

  Future<void> call(CategoryModel category) {
    return repository.softDeleteCategory(category.id);
  }
}
