import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/account_page.dart';
import 'package:flutter_application_2/pages/favorites_page.dart';
import 'package:flutter_application_2/pages/home_product_page.dart';
import 'package:flutter_application_2/pages/categories_page.dart'; // Yeni eklenen sayfa

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomeProductPage(),
    FavoritesPage(),
    CategoriesPage(), // Yeni eklenen sayfa
    const Center(
      child: Text(
        'Sepetim',
        style: TextStyle(fontSize: 50, color: Colors.black),
      ),
    ),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? null
          : AppBar(
              backgroundColor: const Color(0xFF55aacc),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: const Color(0xFF55aacc),
              ),
              title: Text(
                _selectedIndex == 1
                    ? 'Favorilerim'
                    : _selectedIndex == 2
                        ? 'Kategoriler' // Değişti
                        : _selectedIndex == 3
                            ? 'Sepetim'
                            : 'Hesabım',
                style: const TextStyle(color: Colors.white),
              ),
            ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        selectedItemColor: Color.fromARGB(255, 0, 50, 158),
        unselectedItemColor: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color(0xFF55aacc),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Anasayfa'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: 'Favorilerim'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Kategoriler'), // Değişti
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: 'Sepetim'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: 'Hesabım'),
        ],
      ),
    );
  }
}
