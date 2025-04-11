import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // performs network requests
import 'package:xml/xml.dart'; // parses XML


void main() {
  runApp(const DailyDishApp());
}

class DailyDishApp extends StatelessWidget {
  const DailyDishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DailyDishHome(),
    );
  }
}

class DailyDishHome extends StatefulWidget {
  const DailyDishHome({super.key});

  @override
  State<DailyDishHome> createState() => _DailyDishHomeState();
}

class _DailyDishHomeState extends State<DailyDishHome> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Dish", style: TextStyle(color: Colors.deepOrange.shade900)),
        backgroundColor: Colors.deepOrange.shade900,
      ),
      backgroundColor: Colors.orange.shade50,
      body: <Widget>[
        const Center(child: Text("Home Placeholder")),
        const Center(child: Text("Cuisines Placeholder")),
        const Center(child: Text("Recipe Placeholder")),
        const Center(child: Text("Pick For Me Placeholder")),
      ][currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.deepOrange.shade900,
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        indicatorColor: Colors.white,
        selectedIndex: currentIndex,
        destinations: <Widget>[
          NavigationDestination(
              icon: Icon(Icons.home, color: Colors.white),
              selectedIcon: const Icon(Icons.home, color: Colors.deepOrange.shade900),
              label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.restaurant_menu, color: Colors.white),
              selectedIcon: const Icon(Icons.restaurant_menu, color: Colors.deepOrange.shade900),
              label: "Cuisines"),
          NavigationDestination(
              icon: Icon(Icons.shuffle, color: Colors.white),
              selectedIcon: const Icon(Icons.shuffle, color: Colors.deepOrange.shade900),
              label: "Pick For Me"),
          NavigationDestination(
              icon: Icon(Icons.book, color: Colors.white),
              selectedIcon: const Icon(Icons.book, color: Colors.deepOrange.shade900),
              label: "Recipe"),
        ],
      ),
    );
  }
}
