import 'package:flutter/material.dart';
import 'package:ats/contact_list.dart';
import 'package:ats/home.dart';
import 'main.dart';

class BottomNavbar extends StatefulWidget {
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = <Widget>[
    HomeScreen(),
    MyInputForm(),
  ];

// Function to change the current page index
  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.contacts), label: 'Contact List'),
        ],
        currentIndex: _currentPageIndex,
        selectedItemColor: Color(0xFF075E54),
        onTap: _onItemTapped,
      ),
    );
  }
}
