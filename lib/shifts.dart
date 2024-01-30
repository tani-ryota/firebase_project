
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ChatPage.dart';
import 'firebase_options.dart';
import 'shift/main_page/shift_mainpage.dart';
import 'post.dart';

// タイトルを入れるプロバイダー
final textProvider = StateProvider.autoDispose((ref) {
  return TextEditingController(text: '');
});
// 数値を入れるプロバイダー
final doubleProvider = StateProvider.autoDispose((ref) {
  return TextEditingController(text: '');
});
// FireStoreの'arrays'コレクションのすべてのドキュメントを取得するプロバイダー。初回に全件分、あとは変更があるたびStreamに通知される。
final firebaseArraysProvider = StreamProvider.autoDispose((_) {
  return FirebaseFirestore.instance.collection('SHIFT_HOLIDAY').snapshots();
});
class shifts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/Chat': (context) => ChatPage(), 
        '/shift': (context) => shift(),
        
        
      },
      
      home:  MyPageView()  
    );
  }
}

class MyPageView extends ConsumerWidget {
  const MyPageView({
    Key? key,

    }) : super(key: key);
   
  
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleC = ref.watch(textProvider);
    
    
    final doubleC = ref.watch(doubleProvider);
    final AsyncValue<QuerySnapshot> firebaseArrays =
        ref.watch(firebaseArraysProvider);
    final FocusNode nodeText = FocusNode();

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
      ),
      body: SafeArea(
        child: Column(
          children: [
            
            Expanded(
                // Streamに通知が来た（＝初回もしくは変更時の）
                child: firebaseArrays.when(
              // データがあった（データはqueryの中にある）
              data: (QuerySnapshot query) {
                // post内のドキュメントをリストで表示する
                return ListView(
                  // post内のドキュメント１件ずつをCard枠を付けたListTileのListとしてListViewのchildrenとする
                  children: query.docs.map((document) {
                    var day = document['day'];
                    var user = document['user']; // List型に変換する.
                    return GestureDetector(
                     
                    child : Card(
                      child: ListTile(
                        // postで送った内容を表示する（titleは丸ごと、subtitleは配列の第一要素）
                        title: Text('出勤日: ${day}'),
                        subtitle: Row(
                          children: [
                            Text('出勤者: ${user}'),
                          
                          ],
                        ),
                      ),
                    ));
                  }).toList(),
                );
              },

              // データの読み込み中（FireStoreではあまり発生しない）
              loading: () {
                return const Text('Loading');
              },
              
              // エラー（例外発生）時
              error: (e, stackTrace) {
                return Text('error: $e');
              },
            ),
            
            ),
            
          ],
        ),
      ),
    );
  }
}

