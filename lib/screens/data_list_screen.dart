import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data List")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('health_data').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          final documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index];
              return ListTile(
                title: Text('Heart Rate: ${data['heart_rate']}'),
                subtitle: Text('Blood Pressure: ${data['blood_pressure']}'),
              );
            },
          );
        },
      ),
    );
  }
}
