import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';
import 'password_recovery_screen.dart';
import 'home_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? _emailErrorMessage;
  String? _passwordErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng Nhập'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.mail),
              ),
            ),
            SizedBox(height: 16),
            if (_emailErrorMessage != null)
              Text(
                _emailErrorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.password),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            if (_passwordErrorMessage != null)
              Text(
                _passwordErrorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _emailErrorMessage = null;
                  _passwordErrorMessage = null;
                });

                if (emailController.text.isEmpty) {
                  setState(() {
                    _emailErrorMessage = 'Vui lòng nhập địa chỉ email.';
                  });
                  return; // Kết thúc hàm onPressed
                }

                if (passwordController.text.isEmpty) {
                  setState(() {
                    _passwordErrorMessage = 'Vui lòng nhập mật khẩu.';
                  });
                  return; // Kết thúc hàm onPressed
                }

                // Xử lý đăng nhập
                String email = emailController.text;
                String password = passwordController.text;

                try {
                  // Gọi hàm signInWithEmailAndPassword để đăng nhập
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // Nếu đăng nhập thành công, chuyển hướng đến màn hình SettingsScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } catch (error) {
                  // Xử lý lỗi nếu có
                  print('Đăng nhập thất bại: $error');
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Lỗi'),
                        content: Text('Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin đăng nhập.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Đóng hộp thoại
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Đăng Nhập'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Chuyển hướng đến màn hình đăng ký
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Chưa có tài khoản? Đăng ký ngay'),
            ),
            TextButton(
              onPressed: () {
                // Chuyển hướng đến màn hình khôi phục mật khẩu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordRecoveryScreen()),
                );
              },
              child: Text('Quên mật khẩu?'),
            ),
          ],
        ),
      ),
    );
  }
}
