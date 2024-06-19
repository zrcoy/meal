import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_provider.dart';

enum FilterEnum {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersProvider extends StateNotifier<Map<FilterEnum, bool>> {
  FiltersProvider()
      : super({
          FilterEnum.glutenFree: false,
          FilterEnum.lactoseFree: false,
          FilterEnum.vegetarian: false,
          FilterEnum.vegan: false,
        });

  void setFilter(FilterEnum filter, bool isActive) {
    state = {...state, filter: isActive};
  }

  void setFilters(Map<FilterEnum, bool> filters) {
    state = filters;
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersProvider, Map<FilterEnum, bool>>((ref) {
  return FiltersProvider();
});

final filterMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final selectedFilters = ref.watch(filtersProvider);

  final availableMeals = meals.where((meal) {
    if (selectedFilters[FilterEnum.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (selectedFilters[FilterEnum.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (selectedFilters[FilterEnum.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (selectedFilters[FilterEnum.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();

  return availableMeals;
});
