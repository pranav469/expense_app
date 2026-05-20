import 'package:equatable/equatable.dart';

class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCategoriesEvent
    extends CategoryEvent {}

class AddCategoryEvent
    extends CategoryEvent {
  final String name;

  AddCategoryEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class DeleteCategoryEvent
    extends CategoryEvent {
  final String id;

  DeleteCategoryEvent(this.id);

  @override
  List<Object?> get props => [id];
}