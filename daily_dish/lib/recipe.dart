import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecipeScreen extends StatefulWidget {
  final String? recipeId;
  const RecipeScreen({super.key, this.recipeId});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  Map<String, dynamic>? recipe;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.recipeId != null) {
      fetchRecipe(widget.recipeId!);
    }
  }

  Future<void> fetchRecipe(String id) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          setState(() {
            recipe = data['meals'][0];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'No recipe found for this ID.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load recipe data.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching recipe: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.recipeId == null) {
      return const Center(child: Text("Select a recipe to view details."));
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    if (recipe == null) {
      return const Center(child: Text("No recipe found."));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(recipe!['strMeal'], style: Theme.of(context).textTheme.headlineMedium),
          Text('${recipe!['strCategory']} • ${recipe!['strArea']}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
          const SizedBox(height: 16),
          Image.network(recipe!['strMealThumb']),
          const SizedBox(height: 24),
          Text("Ingredients", style: Theme.of(context).textTheme.titleLarge),
          ...List.generate(20, (i) {
            final ingredient = recipe!['strIngredient${i + 1}'];
            final measure = recipe!['strMeasure${i + 1}'];
            if (ingredient == null || ingredient.trim().isEmpty) return const SizedBox.shrink();
            return Text("• $ingredient - $measure", style: Theme.of(context).textTheme.bodyLarge,);
          }),
          const SizedBox(height: 24),
          Text("Instructions", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          // Display the instructions as a large blob of text
          Text(
            recipe!['strInstructions'] ?? "No instructions available.",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
