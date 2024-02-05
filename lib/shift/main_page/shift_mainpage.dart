
import 'package:firebase_project/shifts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_project/shift/cell_calendar.dart';
import 'sample_Events.dart';
import 'package:firebase_project/ChatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/shift.dart';
import 'package:firebase_project/Create_shift.dart';
import 'package:firebase_project/shifts_admin.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final textProvider = StateProvider.autoDispose((ref) {
  return TextEditingController(text: '');
});

final firebaseArraysProvider = StreamProvider.autoDispose((_) {
  return FirebaseFirestore.instance.collection('SHIFT_CRAFT').snapshots();
});

class isLogin extends StatelessWidget {
  const  isLogin({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if(FirebaseAuth.instance.currentUser?.displayName == 'Admin'){
      return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                  
    }else{
      return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/Chat': (context) => ChatPage(),
        '/Shift': (context) => shift_final(),
      },
      home: const MyHomePage(title: 'シフト申請'),
    );
                  }
    
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final events = sampleEvents();
    final cellCalendarPageController = CellCalendarPageController();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: (const Color.fromARGB(255, 255, 155, 147)),
      ),
      body: CellCalendar(
        cellCalendarPageController: cellCalendarPageController,
        events: events,
        daysOfTheWeekBuilder: (dayIndex) {
          final labels = ["日", "月", "火", "水", "木", "金", "土"];
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              labels[dayIndex],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
        monthYearLabelBuilder: (datetime) {
          final year = datetime!.year.toString();
          final month = datetime.month.monthName;

         
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  "$year / $month",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: 'today',
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    cellCalendarPageController.animateToDate(
                      DateTime.now(),
                      curve: Curves.linear,
                      duration: const Duration(milliseconds: 300),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.task),
                  tooltip: 'シフト確認',
                  onPressed: () {
                    
                    Navigator.pushNamed(context, '/Shift');
                  
                  },
                  
                ),
                IconButton(
                  icon: const Icon(Icons.chat),
                  tooltip: 'チャット',
                  onPressed: () {
                    Navigator.pushNamed(context, '/Chat');
                  },
                ),
              
              ],
            ),
          );
        },
        onCellTapped: (date) {
          final eventsOnTheDate = events.where((event) {
            final eventDate = event.eventDate;
            return eventDate.year == date.year &&
                eventDate.month == date.month &&
                eventDate.day == date.day;
          }).toList();
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text("${date.month.monthName} ${date.day}"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: eventsOnTheDate
                          .map(
                            (event) => Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 10),
                              color: event.eventBackgroundColor,
                              child: Text(
                                event.eventName,
                                style: event.eventTextStyle,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ));
        },
        onPageChanged: (firstDate, lastDate) {
          /// Called when the page was changed
          /// Fetch additional events by using the range between [firstDate] and [lastDate] if you want
        },
      ),
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

