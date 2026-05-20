import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/uuid.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/category_usecase.dart';
import 'category_event.dart';
import '';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories _getCategories;
  final AddCategory _addCategory;
  final SoftDeleteCategory _softDelete;

  CategoryBloc(this._getCategories, this._addCategory, this._softDelete)
      : super(CategoryInitial()) {
    on<LoadCategories>(_onLoad);
    on<AddCategoryEvent>(_onAdd);
    on<DeleteCategoryEvent>(_onDelete);
  }

  Future<void> _onLoad(
      LoadCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final cats = await _getCategories();
      emit(CategoryLoaded(cats!));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onAdd(
      AddCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      final newCat = CategoryEntity(
        id: UuidHelper.generate(),
        name: event.name,
        isSynced: false,
      );
      await _addCategory(newCat);

      // Optimistic add to current list
      if (state is CategoryLoaded) {
        final current = (state as CategoryLoaded).categories;
        emit(CategoryLoaded([...current, newCat]));
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onDelete(
      DeleteCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      await _softDelete(event.id);

      // Instant reactive removal
      if (state is CategoryLoaded) {
        final current = (state as CategoryLoaded).categories;
        emit(CategoryLoaded(
          current.where((c) => c.id != event.id).toList(),
        ));
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}