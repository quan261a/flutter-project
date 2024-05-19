import 'package:flutter/material.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Text(
        'Chào mừng bạn đến với trang chủ!',
        style: TextStyle(fontSize: 24),
      ),
    ),
    Center(
      child: Text(
        'Lời giải',
        style: TextStyle(fontSize: 24),
      ),
    ),
    Center(
      child: Text(
        'Thêm mới',
        style: TextStyle(fontSize: 24),
      ),
    ),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ'),
        backgroundColor: Colors.blueGrey,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Lời giải',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Thêm mới',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.green,  // Change this to your desired color
        onTap: _onItemTapped,
      ),
    );
  }
}
