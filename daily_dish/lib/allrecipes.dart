import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'recipelistitem.dart'; 

class AllRecipesScreen extends StatefulWidget {
  final Function(String) onRecipeSelected;

  const AllRecipesScreen({super.key, required this.onRecipeSelected});

  @override
  State<AllRecipesScreen> createState() => _AllRecipesScreenState();
}

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  List<String> categories = [];
  String selectedCategory = 'Beef';
  List<dynamic> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        categories = List<String>.from(data['categories'].map((c) => c['strCategory']));
      });
      fetchRecipesByCategory(selectedCategory);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> fetchRecipesByCategory(String category) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        recipes = data['meals'];
        selectedCategory = category;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load recipes');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Browse Recipes', 
          style: TextStyle(color: Colors.deepOrange.shade900)
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: 'Select a Category',
                labelStyle: TextStyle(
                  color: Colors.deepOrange.shade900,
                  fontWeight: FontWeight.w500, 
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepOrange.shade900), 
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepOrange.shade900, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              dropdownColor: Colors.white,
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  fetchRecipesByCategory(newValue);
                }
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return GestureDetector(
                        onTap: () {
                          widget.onRecipeSelected(recipe['idMeal']);
                        },
                        child: RecipeListItem(
                          imageUrl: recipe['strMealThumb'],
                          title: recipe['strMeal'],
                          description: 'See recipe!',
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}