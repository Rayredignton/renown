import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renown/screens/chat_view.dart';
import 'package:renown/screens/profile_view.dart';
import 'package:renown/screens/users.dart';
import 'package:renown/viewmodel/auth_viewmodel.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens to display
  final List<Widget> _screens = [
    ChatUsersView(), // First tab
    ProfileView(),  // Second tab
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: Scaffold(
        body: _screens[_selectedIndex], // Display the selected screen
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, // Set the current selected index
          onTap: _onItemTapped, // Handle tap events
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
