import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    // Lấy thông tin người dùng hiện tại
    User? user = FirebaseAuth.instance.currentUser;

    // Lấy dữ liệu từ Realtime Database
    DataSnapshot dataSnapshot = (await _databaseReference.child('users').child(user!.uid).once()).snapshot;

    // Trích xuất dữ liệu
    Map<dynamic, dynamic>? userData = dataSnapshot.value as Map<dynamic, dynamic>?;

    // Kiểm tra nếu userData không null trước khi trích xuất dữ liệu
    if (userData != null) {
      String username = userData['username'];
      String email = userData['email'];
      String birthdate = userData['birthdate'];

      // Hiển thị thông tin người dùng trong các TextField
      setState(() {
        nameController.text = username ?? '';
        emailController.text = email ?? '';
        birthdateController.text = birthdate ?? '';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ của bạn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Tên',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: birthdateController,
              decoration: InputDecoration(
                labelText: 'Ngày sinh',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Cập nhật thông tin người dùng
                  User? user = FirebaseAuth.instance.currentUser;
                  await user?.updateDisplayName(nameController.text);

                  // Cập nhật thông tin hồ sơ vào Realtime Database
                  _databaseReference.child('users').child(user!.uid).set({
                    'username': nameController.text,
                    'email': emailController.text,
                    'birthdate': birthdateController.text,
                  });

                  print('Profile updated successfully');
                } catch (e) {
                  print('Error updating profile: $e');
                  // Xử lý lỗi khi cập nhật hồ sơ thất bại
                }
              },
              child: Text('Cập nhật hồ sơ'),
            ),
          ],
        ),
      ),
    );
  }
}
