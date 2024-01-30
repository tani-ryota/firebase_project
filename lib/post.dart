import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.text,
    required this.createdAt,
    required this.posterName,
    required this.posterImageUrl,
    required this.posterId,
    required this.reference,
  });

  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;
    return Post(
      text: map['text'],
      createdAt: map['createdAt'],
      posterName: map['posterName'],
      posterImageUrl: map['posterImageUrl'],
      posterId: map['posterId'],
      reference: snapshot.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'createdAt': createdAt,
      'posterName': posterName,
      'posterImageUrl': posterImageUrl,
      'posterId': posterId,
    };
  }

  final String text;
  final Timestamp createdAt;
  final String posterName;
  final String posterImageUrl;
  final String posterId;
  final DocumentReference reference;
}
class Doc {
  Doc({
    required this.day,
    required this.user,
    required this.reference,
  });

  factory Doc.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;
    return Doc(
      day: map['day'],
      user: map['user'],
      
      reference: snapshot.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'user': user,
      };
  }

  final Timestamp day;
  final String user;
  final DocumentReference reference;
}
