import 'package:flutter/material.dart';
import 'package:englishapp/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final AuthService _authService = AuthService();

  String? _emailErrorMessage;
  String? _passwordErrorMessage;
  String? _confirmPasswordErrorMessage;
  String? _usernameErrorMessage;
  String? _birthdateErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng Ký'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Tên người dùng',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16),
              if (_usernameErrorMessage != null)
                Text(
                  _usernameErrorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16),
              if (_emailErrorMessage != null)
                Text(
                  _emailErrorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              TextField(
                controller: birthdateController,
                decoration: InputDecoration(
                  labelText: 'Ngày sinh',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime? date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    birthdateController.text = date.toLocal().toString().split(' ')[0];
                  }
                },
              ),
              SizedBox(height: 16),
              if (_birthdateErrorMessage != null)
                Text(
                  _birthdateErrorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              if (_passwordErrorMessage != null)
                Text(
                  _passwordErrorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Xác nhận Mật khẩu',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              if (_confirmPasswordErrorMessage != null)
                Text(
                  _confirmPasswordErrorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _emailErrorMessage = null;
                    _passwordErrorMessage = null;
                    _confirmPasswordErrorMessage = null;
                    _usernameErrorMessage = null;
                    _birthdateErrorMessage = null;
                  });

                  if (usernameController.text.isEmpty) {
                    setState(() {
                      _usernameErrorMessage = 'Vui lòng nhập tên người dùng.';
                    });
                    return;
                  }

                  if (emailController.text.isEmpty) {
                    setState(() {
                      _emailErrorMessage = 'Vui lòng nhập địa chỉ email.';
                    });
                    return;
                  }

                  if (birthdateController.text.isEmpty) {
                    setState(() {
                      _birthdateErrorMessage = 'Vui lòng chọn ngày sinh.';
                    });
                    return;
                  }

                  if (passwordController.text.isEmpty) {
                    setState(() {
                      _passwordErrorMessage = 'Vui lòng nhập mật khẩu.';
                    });
                    return;
                  }

                  if (confirmPasswordController.text.isEmpty) {
                    setState(() {
                      _confirmPasswordErrorMessage = 'Vui lòng nhập xác nhận mật khẩu.';
                    });
                    return;
                  }

                  if (passwordController.text != confirmPasswordController.text) {
                    setState(() {
                      _confirmPasswordErrorMessage = 'Mật khẩu và xác nhận mật khẩu không khớp.';
                    });
                    return;
                  }

                  // Kiểm tra tuổi phải trên 12
                  DateTime birthdate = DateTime.parse(birthdateController.text);
                  DateTime currentDateTime = DateTime.now();
                  DateTime minimumBirthdate = DateTime(currentDateTime.year - 12, currentDateTime.month, currentDateTime.day);
                  if (birthdate.isAfter(minimumBirthdate)) {
                    setState(() {
                      _birthdateErrorMessage = 'Tuổi phải lớn hơn hoặc bằng 12.';
                    });
                    return;
                  }

                  try {
                    await _authService.register(
                      emailController.text,
                      passwordController.text,
                      usernameController.text,
                      birthdateController.text,
                    );

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Đăng ký thành công'),
                          content: Text('Tài khoản của bạn đã được tạo thành công.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    print('Error registering user: $e');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Lỗi'),
                          content: Text('Đăng ký thất bại. Vui lòng thử lại.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Đăng Ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
