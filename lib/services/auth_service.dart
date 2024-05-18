import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  // Ví dụ phương pháp đăng ký
  Future<void> register(String email, String password, String username, String birthdate) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ghi dữ liệu người dùng vào Realtime Database
      _databaseReference.child('users').child(userCredential.user!.uid).set({
        'username': username,
        'email': email,
        'birthdate': birthdate,
      });

      print('User registered: ${userCredential.user}');
    } catch (e) {
      print("Đăng ký thất bại: $e");
      throw e;
    }
  }


  // Ví dụ phương pháp đăng nhập
  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Đăng nhập thành công, bạn có thể thực hiện các thao tác tiếp theo ở đây
    } catch (e) {
      // Xử lý lỗi khi đăng nhập
      print("Đăng nhập thất bại: $e");
      throw e;
    }
  }


  // Ví dụ phương pháp khôi phục mật khẩu
  Future<void> recoverPassword(String email) async {
    try {
      // Gửi email khôi phục mật khẩu
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('Password reset email sent successfully');
    } catch (e) {
      print('Error sending password reset email: $e');
      // Xử lý lỗi khi gửi email khôi phục mật khẩu thất bại
    }
  }

  // Ví dụ phương pháp cập nhật hồ sơ
  Future<void> updateProfile(String name, String email) async {
    try {
      // Lấy thông tin người dùng hiện tại
      User? user = FirebaseAuth.instance.currentUser;

      // Cập nhật tên người dùng
      await user?.updateDisplayName(name);

      // Cập nhật email người dùng
      await user?.verifyBeforeUpdateEmail(email);

      // Hiển thị thông báo hoặc thực hiện các hành động khác nếu cập nhật thành công
      print('Profile updated successfully');
    } catch (e) {
      // Xử lý lỗi khi cập nhật hồ sơ thất bại
      print('Error updating profile: $e');
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      // Lấy thông tin người dùng hiện tại
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Tạo một Credential xác thực bằng mật khẩu hiện tại
        AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: currentPassword);

        // Reauthenticate người dùng với credential
        await user.reauthenticateWithCredential(credential);

        // Thực hiện đổi mật khẩu mới
        await user.updatePassword(newPassword);

        // Xử lý khi đổi mật khẩu thành công
        print('Password changed successfully');
      } else {
        // Xử lý khi không có người dùng nào đang đăng nhập
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user is currently signed in.',
        );
      }
    } catch (e) {
      // Xử lý khi có lỗi xảy ra
      print('Error changing password: $e');
      throw e; // Ném lỗi để xử lý ở nơi gọi
    }
  }

}
