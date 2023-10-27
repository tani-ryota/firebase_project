import 'package:flutter/material.dart';
import 'image_widget.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App Home Page'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('中世記念堂'),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('中世記念堂とは'),
                    content: Text(
                        '初代総統である蔣介石の顕彰施設で、台湾の3大観光名所の1つであり、\n中国の伝統的な宮殿陵墓式が採用されている。'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('閉じる'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: MyImageWidget(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('台北市'),
            ],
          )
        ],
      )),
    );
  }
}
