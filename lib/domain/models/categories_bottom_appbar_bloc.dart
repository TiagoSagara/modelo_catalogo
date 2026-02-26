import 'package:api_produtos/data/repositories/categories_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<String> categories;
  CategoryLoaded(this.categories);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}

// category_event.dart
abstract class CategoryEvent {}

class FetchCategories extends CategoryEvent {}

// category_bloc.dart
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoriesRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitial()) {
    on<FetchCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final response = await repository.getCategoryList();
        // A API retorna List<dynamic>, convertemos para List<String>
        final List<String> categories = List<String>.from(response.data);
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError("Falha ao carregar categorias"));
      }
    });
  }
}
