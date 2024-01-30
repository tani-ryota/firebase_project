import 'package:flutter/material.dart';
import 'shifts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/shifts.dart';
import 'firebase_options.dart';

class HomeWidget1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListState();
  }
}
class ListState extends State<HomeWidget1> {
  var listItem = ["one", "two", "three"];
  FirebaseFirestore Firestore = FirebaseFirestore.instance;
  
  List<DocumentSnapshot> documentList = [];
  var index = '';
  @override
  
     void fire_get() async {
      
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      //firebase上のコレクションへのアクセス(変数名を _users にしているが、自由に決める)
      final  users =  await _firestore.collection('SHIFTS').get();
     
    users.docChanges.forEach((element) {
      final name = element.doc.get('user');
      final day = element.doc.get('day');
      index += "${name}";
    });
   
      
      // documentList = msg as List<DocumentSnapshot<Object?>>;
  }
                    
  Widget build(BuildContext context) {
    
    
          return Center(
              child: Row(
                children:[
                Center(
                
                child: ElevatedButton(
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                 
                                    title: Text("ログアウト"),
                                    content: Text("ログアウトします"),
                                    actions: <Widget>[
                                      // ボタン領域
                                      TextButton( 
                                        child: Text("Cancel"),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                        ),
                                        onPressed: () =>
                                          Navigator.pop<String>(context,'Cancel')
                                           
                                      ),
                                      TextButton(
                                        child: Text("OK"),
                                        onPressed: (){  

                                          Navigator.pushNamed(context, '/Login');
                                        }
                                      ),
                                    ],
                                  
                                )
                              );
                              
                              
                            },
                            child: Text("ログアウト"),
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 15),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white, // foreground
                              fixedSize: Size(400, 50),
                              alignment: Alignment.center,
                            )),
              )
                ],)
          );
        
      
  
  }
}
