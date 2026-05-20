// import 'package:equatable/equatable.dart';
//
// import '../../data/models/category_model.dart';
//
// class CategoryState extends Equatable {
//   final bool isLoading;
//
//   final List<CategoryModel> categories;
//
//   final String? error;
//
//   const CategoryState({
//     this.isLoading = false,
//     this.categories = const [],
//     this.error,
//   });
//
//   CategoryState copyWith({
//     bool? isLoading,
//     List<CategoryModel>? categories,
//     String? error,
//   }) {
//     return CategoryState(
//       isLoading:
//       isLoading ?? this.isLoading,
//       categories:
//       categories ?? this.categories,
//       error: error,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//     isLoading,
//     categories,
//     error,
//   ];
// }