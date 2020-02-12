import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void runEventLoopDemo() {
  runApp(EventLoopDemo());
}

class EventLoopDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("event loop demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tap button will request https://www.baidu.com',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // future D
          Future.delayed(Duration(seconds: 2), () {
            sleep(Duration(seconds: 10));
            print("print 2 from future delayed 2 seconds");
          });

          // future C
          Future.delayed(Duration(seconds: 1), () {
            print("print 1 from future delayed 1 seconds");
          });

          // future B
          final myFuture = http.get('https://www.baidu.com');
          myFuture.then((response) {
            if (response.statusCode == 200) {
              print('Success!');
            } else {
              print('Something wrong happened: ${response.statusCode}');
            }
          });

          // microtask 1
          Future.microtask(() {
            print("this is microtask, it will execute at high level");
          });

          // microtask 2
          Future.microtask(() {
            print("this is microtask2, it will execute at high level after microtask1");
          });

          // future A
          Future.delayed(Duration(seconds: 0), () {
            print("print 0 from future delayed 0 seconds");
          });
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
