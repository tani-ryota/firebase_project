

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ChatPage.dart';
import 'shifts_admin.dart';

import 'firebase_options.dart';
import 'shift/main_page/shift_mainpage.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
 final query = _db.collection("SHIFTS").where("values").get() ;



final textProvider = StateProvider.autoDispose((ref) {
  return TextEditingController(text: '');
});


// Firestoreの'arrays'コレクションのすべてのドキュメントを取得するプロバイダー。
// 初回に全件分、あとは変更があるたびStreamに通知される。
final firebaseArraysProvider = StreamProvider.autoDispose((_) {
  return FirebaseFirestore.instance.collection('SHIFTS').snapshots();
});

var day;
var isShift = false;
var isDay = false;

class shift_final extends StatelessWidget {
  const shift_final({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/Chat': (context) => ChatPage(), 
        '/shift': (context) => isLogin(),
        
        
      },
      home:  const PostArrayPage(),
    );
  }
}

class PostArrayPage extends ConsumerWidget {
  const PostArrayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    
    final AsyncValue<QuerySnapshot> firebaseArrays =
        ref.watch(firebaseArraysProvider);

    
  
    DateTime? startDateTime;
    DateTime? endDateTime;

    return Scaffold(
      appBar: AppBar(
        title: const Text('シフト確認'),
        actions: [
          
          IconButton(
            icon: Icon(Icons.chat),
            tooltip: 'チャット',
            onPressed: () {
                    Navigator.pushNamed(context, '/Chat');
                  },
          ),
          IconButton(
            icon: Icon(Icons.people),
            tooltip: 'シフト申請',
            onPressed: () {
                    Navigator.pushNamed(context, '/shift');
                  },
          ),
        ],
        backgroundColor: (const Color.fromARGB(255, 255, 155, 147)),
      ),
      body: SafeArea(
        
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              const SizedBox(height: 16), 
              
              Expanded(
                child: firebaseArrays.when(
                  
                  data: (QuerySnapshot query) {
                    if(query.docs.isNotEmpty){
                    return ListView(
                      children: query.docs.map((document) {
                        var values = document['values'] as List;
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text('氏名: ${values[0]}'),
                            subtitle: Text('時間: ${values[1]}'),
                          
                          ),
                        );
                      }).toList(),
                    );}else{
                      return Scaffold(
                        body: Center(child: Text('まだシフトは作成されていません')),
                      );
                    }
                  },
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (e, stackTrace) {
                    return Text('エラー: $e');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _selectDateTime(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (selectedTime != null) {
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }

    return null; // Return null if the selection is canceled
  }
}
