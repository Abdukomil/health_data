import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataInputPage extends StatefulWidget {
  @override
  _DataInputPageState createState() => _DataInputPageState();
}

class _DataInputPageState extends State<DataInputPage> {
  final TextEditingController _dataController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _submitData() async {
    final user = _auth.currentUser;

    if (user != null) {
      // 사용자 UID에 따라 데이터 저장
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(user.uid) // UID로 문서 생성
          .collection('data') // 데이터 컬렉션
          .add({
        'data': _dataController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      Navigator.pop(context); // 입력 후 이전 페이지로 돌아가기
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Data')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _dataController,
              decoration: InputDecoration(labelText: 'Enter data'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
