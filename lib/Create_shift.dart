import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ChatPage.dart';
import 'shifts_admin.dart';
import 'shift.dart';
import 'firebase_options.dart';

final textProvider = StateProvider.autoDispose((ref) {
  return TextEditingController(text: '');
});

// Firestoreの'arrays'コレクションのすべてのドキュメントを取得するプロバイダー。
// 初回に全件分、あとは変更があるたびStreamに通知される。
final firebaseArraysProvider = StreamProvider.autoDispose((_) {
  return FirebaseFirestore.instance.collection('SHIFT_CRAFT').snapshots();
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );

  runApp(
    const ProviderScope(child: create_shift()),
  );
}

class create_shift extends StatelessWidget {
  const create_shift({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/Chat': (context) => ChatPage(), 
        '/shift': (context) => shifts_admin(),
        
        
      },
      home: const PostArrayPage(),
    );
  }
}

class PostArrayPage extends ConsumerWidget {
  const PostArrayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = ref.watch(textProvider);

    final AsyncValue<QuerySnapshot> firebaseArrays =
        ref.watch(firebaseArraysProvider);

    DateTime? startDateTime;
    DateTime? endDateTime;

    return Scaffold(
      appBar: AppBar(
        title: const Text('シフト作成'),
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
            tooltip: '申請確認',
            onPressed: () {
                    Navigator.pushNamed(context, '/shift');
                  },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: '例：近藤武蔵',
                  labelText: '氏名',
                ),
                controller: nameController,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  startDateTime = await _selectDateTime(context);
                  if (startDateTime != null) {
                    endDateTime = await _selectDateTime(context);
                    if (endDateTime != null) {
                      await FirebaseFirestore.instance
                          .collection('SHIFT_CRAFT')
                          .add({
                        "values": [
                          nameController.text,
                          '${startDateTime.toString()} から ${endDateTime.toString()}まで',
                        ],
                      });

                      // Clear text field after submission
                      nameController.clear();
                    }
                  }
                },
                child: const Text('日時入力に進む'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: firebaseArrays.when(
                  data: (QuerySnapshot query) {
                    return ListView(
                      children: query.docs.map((document) {
                        var values = document['values'] as List;
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text('氏名: ${values[0]}'),
                            subtitle: Text('時間: ${values[1]}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('SHIFT_CRAFT')
                                    .doc(document.id)
                                    .delete();
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (e, stackTrace) {
                    return Text('エラー: $e');
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  isShift = true;
                  isDay = true;
                  day = DateTime.now();
                  QuerySnapshot shifts = await FirebaseFirestore.instance.collection('SHIFTS').get();
                  for (QueryDocumentSnapshot documentB in shifts.docs) {
                    await FirebaseFirestore.instance.collection('SHIFTS').doc(documentB.id).delete();
                  }
                  QuerySnapshot Craft_shift = await FirebaseFirestore.instance.collection('SHIFT_CRAFT').get();
                  for (QueryDocumentSnapshot documentA in Craft_shift.docs) {
      // コレクションBに新しいドキュメントを作成
                    await FirebaseFirestore.instance.collection('SHIFTS').doc(documentA.id).set(documentA.data() as Map<String, dynamic>);

                    // コレクションAのドキュメントを削除（オプション）
                    
                }},
                child: const Text('シフトを確定する'),
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
