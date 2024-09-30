import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _newPassword;

  Future<void> _changePassword() async {
    final user = _auth.currentUser;
    if (user != null && _newPassword != null) {
      try {
        await user.updatePassword(_newPassword!);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('비밀번호가 성공적으로 번경됨.'),
        ));
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('비밀번호 변경에 실패했습.'),
        ));
      }
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // 로그인 페이지로 이동
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('My Page')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로그인 상태일 때만 이메일과 비밀번호 변경 기능 보이기
            if (user != null) ...[
              Text('이메일: ${user.email}'),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: '새 비밀번호'),
                obscureText: true,
                onChanged: (value) {
                  _newPassword = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changePassword,
                child: Text('비밀번호 변경'),
              ),
            ] else ...[
              Text('로그인 해주세요'),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout, // 로그아웃 버튼은 로그인 여부와 상관없이 표시
              child: Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }
}
