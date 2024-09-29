import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'DataEditPage.dart';
import 'MyPage.dart';
import 'data_input_screen.dart'; // MyPage import

class DataDisplayPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Data Display'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              );
            },
          ),
        ],
      ),
      body: user != null
          ? StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userData')
            .doc(user.uid)
            .collection('data')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final dataDocs = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: dataDocs.length + 1,
            itemBuilder: (context, index) {
              if (index == dataDocs.length) {
                return ListTile(
                  title: Text('Add Data'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DataInputPage()),
                    );
                  },
                );
              }

              return ListTile(
                title: Text(dataDocs[index]['data']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DataEditPage(
                              docId: dataDocs[index].id,
                              currentData: dataDocs[index]['data'],
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        dataDocs[index].reference.delete();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      )
          : Center(child: Text('로그인 해주세요')),
    );
  }
}
