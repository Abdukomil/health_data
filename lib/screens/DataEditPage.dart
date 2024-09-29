import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataEditPage extends StatefulWidget {
  final String docId; // 수정할 데이터의 문서 ID
  final String currentData; // 현재 데이터

  DataEditPage({required this.docId, required this.currentData});

  @override
  _DataEditPageState createState() => _DataEditPageState();
}

class _DataEditPageState extends State<DataEditPage> {
  final TextEditingController _dataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dataController.text = widget.currentData; // 기존 데이터로 초기화
  }

  void _updateData() async {
    await FirebaseFirestore.instance.collection('userData').doc(widget.docId).update({
      'data': _dataController.text,
    });
    Navigator.pop(context); // 수정 후 이전 페이지로 돌아가기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Data')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _dataController,
              decoration: InputDecoration(labelText: 'Edit data'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateData,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
