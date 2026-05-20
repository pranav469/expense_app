import '../../data/models/category_model.dart';
import '../repository/category_repository.dart';

class AddCategoryUsecase {
  final CategoryRepository repository;

  AddCategoryUsecase(this.repository);

  Future<void> call(
      CategoryModel category,
      ) {
    return repository.addCategory(
      category,
    );
  }
}