import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'post.dart';
import 'my_page.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Future<void> sendPost(String text) async {
    // まずは user という変数にログイン中のユーザーデータを格納します
    final user = FirebaseAuth.instance.currentUser!;

    final posterId = user.uid; // ログイン中のユーザーのIDがとれます
    final posterName = user.displayName!; // Googleアカウントの名前がとれます
    final posterImageUrl = user.photoURL!; // Googleアカウントのアイコンデータがとれます

    // 先ほど作った postsReference からランダムなIDのドキュメントリファレンスを作成します
    // doc の引数を空にするとランダムなIDが採番されます
    final newDocumentReference = postsReference.doc();

    final newPost = Post(
      text: text,
      createdAt: Timestamp.now(), // 投稿日時は現在とします
      posterName: posterName,
      posterImageUrl: posterImageUrl,
      posterId: posterId,
      reference: newDocumentReference,
    );

    // 先ほど作った newDocumentReference のset関数を実行するとそのドキュメントにデータが保存されます。
    // 引数として Post インスタンスを渡します。
    // 通常は Map しか受け付けませんが、withConverter を使用したことにより Post インスタンスを受け取れるようになります。
    newDocumentReference.set(newPost);
  }

  // build の外でインスタンスを作ります。
  final controller = TextEditingController();

  /// この dispose 関数はこのWidgetが使われなくなったときに実行されます。
  @override
  void dispose() {
    // TextEditingController は使われなくなったら必ず dispose する必要があります。
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold 全体を GestureDetector で囲むことでタップ可能になります。
    return GestureDetector(
      onTap: () {
        // キーボードを閉じたい時はこれを呼びます。
        primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('チャット'),
          actions: [
            // tap 可能にするために InkWell を使います。
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const MyPage();
                    },
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  FirebaseAuth.instance.currentUser!.photoURL!,
                ),
              ),
            )
          ],
        ),
        body: Column(children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Post>>(
              // stream プロパティに snapshots() を与えると、コレクションの中のドキュメントをリアルタイムで監視することができます。
              stream: postsReference.orderBy('createdAt').snapshots(),
              // ここで受け取っている snapshot に stream で流れてきたデータが入っています。
              builder: (context, snapshot) {
                // docs には Collection に保存されたすべてのドキュメントが入ります。
                // 取得までには時間がかかるのではじめは null が入っています。
                // null の場合は空配列が代入されるようにしています。
                final docs = snapshot.data?.docs ?? [];
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    // data() に Post インスタンスが入っています。
                    // これは withConverter を使ったことにより得られる恩恵です。
                    // 何もしなければこのデータ型は Map になります。
                    final post = docs[index].data();
                    return PostWidget(post: post);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                // 未選択時の枠線
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.amber),
                ),
                // 選択時の枠線
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.amber,
                    width: 2,
                  ),
                ),
                // 中を塗りつぶす色
                fillColor: Colors.amber[50],
                // 中を塗りつぶすかどうか
                filled: true,
              ),
              onFieldSubmitted: (text) {
                sendPost(text);
                controller.clear();
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // 長押しされたときの処理
        if (FirebaseAuth.instance.currentUser!.uid != post.posterId) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'メッセージを削除しますか？',
                  style: TextStyle(fontSize: 12),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          // 削除ボタンを押すとメッセージを削除する
                          post.reference.delete();
                          // ダイアログを閉じる
                          Navigator.of(context).pop();
                        },
                        child: Text('削除'),
                      ),
                      TextButton(
                        onPressed: () {
                          // キャンセルボタンを押すとダイアログを閉じる
                          Navigator.of(context).pop();
                        },
                        child: Text('キャンセル'),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        }
      },
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(post.posterImageUrl),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      post.posterName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:
                        FirebaseAuth.instance.currentUser!.uid == post.posterId
                            ? Colors.amber[100]
                            : Colors.blue[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.text),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                // Move the time display here
                Text(
                  DateFormat('MM/dd HH:mm').format(post.createdAt.toDate()),
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final postsReference =
    FirebaseFirestore.instance.collection('posts').withConverter<Post>(
  // <> ここに変換したい型名をいれます。今回は Post です。
  fromFirestore: ((snapshot, _) {
    // 第二引数は使わないのでその場合は _ で不使用であることを分かりやすくしています。
    return Post.fromFirestore(snapshot); // 先ほど定期着した fromFirestore がここで活躍します。
  }),
  toFirestore: ((value, _) {
    return value.toMap(); // 先ほど適宜した toMap がここで活躍します。
  }),
);
