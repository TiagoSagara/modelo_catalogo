import 'package:api_produtos/data/repositories/categories_repository.dart';
import 'package:api_produtos/domain/models/categories_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;
  CategoryLoaded(this.categories);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}

class CategoryBloc extends Cubit<CategoryState> {
  final CategoriesRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitial());

  Future<void> fetchCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await repository.getCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError("Falha ao carregar categorias"));
    }
  }
}
