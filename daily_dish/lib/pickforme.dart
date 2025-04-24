import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'package:google_fonts/google_fonts.dart';


class PickForMeScreen extends StatefulWidget {
  final Function(String) onRecipeSelected;

  const PickForMeScreen({super.key, required this.onRecipeSelected});

  @override
  _PickForMeScreenState createState() => _PickForMeScreenState();
}

class _PickForMeScreenState extends State<PickForMeScreen> {
  Map<String, dynamic>? randomRecipe;
  bool isLoading = false;

  Future<void> fetchRandomRecipe() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        randomRecipe = data['meals'][0]; 
        isLoading = false;
      });
    } else {
      setState(() {
        randomRecipe = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pick For Me', 
          style: GoogleFonts.atma(
            textStyle: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange.shade900,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: fetchRandomRecipe,
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.deepOrange.shade900, width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: Colors.white,
                  overlayColor: Colors.deepOrange.shade900.withValues(alpha: 0.1),
                ),
                child: const Text('Pick a Random Recipe', style: TextStyle(color: Colors.black),),
              ),
              const SizedBox(height: 16),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (randomRecipe == null)
                const Center(child: Text('Press the button to start!'))
              else ...[
                Text(
                  randomRecipe!['strMeal'],
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${randomRecipe!['strCategory']} • ${randomRecipe!['strArea']}',
                ),
                const SizedBox(height: 16),
                Image.network(randomRecipe!['strMealThumb']),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (randomRecipe != null) {
                      widget.onRecipeSelected(randomRecipe!['idMeal']);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.deepOrange.shade900, width: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Colors.white,
                    overlayColor: Colors.deepOrange.shade900.withValues(alpha: 0.1),
                  ),
                  child: const Text('See Recipe', style: TextStyle(color: Colors.black),),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
