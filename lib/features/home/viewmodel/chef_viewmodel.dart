import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:esame/features/home/model/chef_model.dart';

class ChefViewModel extends ChangeNotifier {
  List<ChefModel> _chefs = [];
  bool _isLoading = false;
  String? _error;
  final Set<String> _followingIds = {};

  List<ChefModel> get chefs => _chefs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  

  Set<String> get followingIds => _followingIds;
  int get followingCount => _followingIds.length;
  
  List<ChefModel> get followingChefs {
    return _chefs.where((chef) => _followingIds.contains(chef.id)).toList();
  }

  bool isFollowing(String chefId) => _followingIds.contains(chefId);

  void toggleFollow(String chefId) {
    if (_followingIds.contains(chefId)) {
      _followingIds.remove(chefId);
    } else {
      _followingIds.add(chefId);
    }
    notifyListeners();
  }

  Future<void> fetchChefs() async {
    if (_chefs.isNotEmpty) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {

      final areas = ['Italian', 'Mexican', 'Chinese', 'Indian', 'Japanese', 'French', 'American', 'Thai'];
      List<ChefModel> allChefs = [];

      for (final area in areas) {
        final response = await http.get(
          Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?a=$area'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['meals'] != null && (data['meals'] as List).isNotEmpty) {
            final meal = data['meals'][0];
            allChefs.add(ChefModel(
              id: area,
              name: 'Chef $area',
              specialty: '$area Cuisine',
              imageUrl: meal['strMealThumb'] ?? '',
              country: area,
              recipesCount: (data['meals'] as List).length,
              rating: 4.0 + (area.hashCode % 10) / 10,
            ));
          }
        }
      }

      _chefs = allChefs;
    } catch (e) {
      _error = 'Failed to load chefs: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
