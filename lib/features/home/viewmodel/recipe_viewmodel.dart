import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:esame/features/home/model/recipe_model.dart';

class RecipeViewModel extends ChangeNotifier {
  List<RecipeModel> _recipes = [];
  List<RecipeModel> _popularRecipes = [];
  List<RecipeModel> _reelsRecipes = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  String? _error;

  List<RecipeModel> get recipes => _recipes;
  List<RecipeModel> get popularRecipes => _popularRecipes;
  List<RecipeModel> get reelsRecipes => _reelsRecipes;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  List<RecipeModel> get favoriteRecipes {
    final allRecipes = <RecipeModel>[];
    allRecipes.addAll(_recipes);
    allRecipes.addAll(_popularRecipes);
    allRecipes.addAll(_reelsRecipes);
    
    final uniqueRecipes = <String, RecipeModel>{};
    for (var recipe in allRecipes) {
      if (_favoriteIds.contains(recipe.id)) {
        uniqueRecipes[recipe.id] = recipe;
      }
    }
    return uniqueRecipes.values.toList();
  }

  bool isFavorite(String recipeId) => _favoriteIds.contains(recipeId);

  void toggleFavorite(String recipeId) {
    if (_favoriteIds.contains(recipeId)) {
      _favoriteIds.remove(recipeId);
    } else {
      _favoriteIds.add(recipeId);
    }
    notifyListeners();
  }

  Future<void> initializeHome() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.wait([
      fetchCategories(),
      fetchPopularRecipes(),
      fetchRecipesByQuery('b'),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?c=list'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          _categories = ['All'] + (data['meals'] as List)
              .map((c) => c['strCategory'] as String)
              .toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }
  }

  Future<void> fetchPopularRecipes() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?f=s'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          _popularRecipes = (data['meals'] as List)
              .take(5)
              .map((meal) => RecipeModel.fromJson(meal))
              .toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching popular recipes: $e");
    }
  }

  Future<void> filterByCategory(String category) async {
    _selectedCategory = category;
    _isLoading = true;
    notifyListeners();

    try {
      if (category == 'All') {
        await fetchRecipesByQuery('b');
      } else {
        final response = await http.get(
          Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$category'),
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['meals'] != null) {
            _recipes = (data['meals'] as List)
                .map((meal) => RecipeModel.fromJson(meal))
                .toList();
          } else {
            _recipes = [];
          }
        }
      }
    } catch (e) {
      _error = "An error occurred: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchRecipes(String query) async {
    if (query.isEmpty) {
      await filterByCategory(_selectedCategory);
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          _recipes = (data['meals'] as List)
              .map((meal) => RecipeModel.fromJson(meal))
              .toList();
        } else {
          _recipes = [];
        }
      }
    } catch (e) {
      _error = "An error occurred: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRecipesByQuery(String query) async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?f=$query'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          _recipes = (data['meals'] as List)
              .map((meal) => RecipeModel.fromJson(meal))
              .toList();
        } else {
          _recipes = [];
        }
      }
    } catch (e) {
      _error = "An error occurred: $e";
    }
  }
  Future<void> fetchReels() async {
    if (_reelsRecipes.isNotEmpty) return; 
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?f=c'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          _reelsRecipes = (data['meals'] as List)
              .map((meal) => RecipeModel.fromJson(meal))
              .where((r) => r.youtubeUrl.isNotEmpty)
              .toList();
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<RecipeModel?> fetchDetailedRecipe(String id) async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return RecipeModel.fromJson(data['meals'][0]);
        }
      }
    } catch (e) {
      debugPrint("Error fetching detailed recipe: $e");
    }
    return null;
  }
}
