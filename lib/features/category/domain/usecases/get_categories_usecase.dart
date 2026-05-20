import '../repository/category_repository.dart';

class GetCategoryUsecase {
  final CategoryRepository repository;

  GetCategoryUsecase(this.repository);

  Future<void> call() {
    return repository.getCategories();
  }
}
