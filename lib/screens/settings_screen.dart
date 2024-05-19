import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_screen.dart';
import 'change_password_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login screen after logging out
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Error logging out: $e');
      // You might want to show a snackbar or some feedback to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Hồ sơ'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Đổi mật khẩu'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Đăng xuất'),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }
}
