import 'package:flutter/material.dart';
import 'home.dart';
import 'allrecipes.dart';
import 'pickforme.dart';
import 'recipe.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, 
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepOrange.shade900,
          elevation: 0,
        ),
      ),
      home: MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int currentIndex = 0;
  String? selectedRecipeId;

  
  void _onDestinationSelected(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _onRecipeSelected(String recipeId) {
    setState(() {
      selectedRecipeId = recipeId;
      currentIndex = 3;
    });
  }


  List<Widget> get _pages => [
    const HomeScreen(),
    AllRecipesScreen(onRecipeSelected: _onRecipeSelected),
    PickForMeScreen(onRecipeSelected: _onRecipeSelected),
    RecipeScreen(recipeId: selectedRecipeId ?? '52874'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("The Daily Dish", 
          style: GoogleFonts.atma(
            textStyle: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: _pages[currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.deepOrange.shade900,
          onDestinationSelected: _onDestinationSelected,
          indicatorColor: Colors.white,
          selectedIndex: currentIndex,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home, color: Colors.white),
              selectedIcon: Icon(Icons.book, color: Colors.deepOrange.shade900),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu, color: Colors.white),
              selectedIcon: Icon(Icons.book, color: Colors.deepOrange.shade900),
              label: "All Recipes",
            ),
            NavigationDestination(
              icon: Icon(Icons.shuffle, color: Colors.white),
              selectedIcon: Icon(Icons.book, color: Colors.deepOrange.shade900),
              label: "Pick For Me",
            ),
            NavigationDestination(
              icon: Icon(Icons.book, color: Colors.white),
              selectedIcon: Icon(Icons.book, color: Colors.deepOrange.shade900),
              label: "Recipe",
            ),
          ],
        ),
      ),
    );
  }
}
