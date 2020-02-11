import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

String stringInMainIsolate;
void runIsolateDemo() {
  stringInMainIsolate = "HelloFlutter!";
  ReceivePort receivePort = ReceivePort();

  Isolate.spawn(entryPoint, receivePort.sendPort, debugName: "myNewIsolate");

  receivePort.listen((message) {
    if (message is SendPort) {
      message.send("Yes, let's go to swim!");
    } else {
      print("${Isolate.current.debugName} receive sub isolate message: $message");
    }
  });

//  Stream receiveStream = receivePort.asBroadcastStream();
//  receiveStream.listen((message) {
//    if (message is SendPort) {
//      message.send("1: Yes, let's go to swim!");
//    } else {
//      print("1: ${Isolate.current.debugName} isolate receive sub isolate message: $message");
//    }
//  });
//
//  receiveStream.listen((message) {
//    if (message is SendPort) {
//      message.send("2: Yes, let's go to swim!");
//    } else {
//      print("2: ${Isolate.current.debugName} isolate receive sub isolate message: $message");
//    }
//  });
}

void entryPoint(SendPort sendPort) {
  print("stringInMainIsolate: $stringInMainIsolate");

  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  sendPort.send("go swimming?");

  receivePort.listen((message) {
    print("${Isolate.current.debugName} receive main isolate message: $message");
  });
}

// ----------------------------------------------------------------------------------------------------------------
// 启动新的Isolate，并监听消息
runIsolateDemo2() async {
  ReceivePort receivePort = ReceivePort();
  Isolate isolate = await Isolate.spawn(entryPoint2, receivePort.sendPort, debugName: 'newIsolate');

  receivePort.listen((message) {
    print('${Isolate.current.debugName}: receive msg $message');
  });
  print('${Isolate.current.debugName}: spawn');
}

// 新Isolate入口函数
entryPoint2(SendPort sendPort) {
  int counter = 0;
  Timer.periodic(Duration(seconds: 1), (Timer t) {
    print('${Isolate.current.debugName}: send msg ${counter++}');
    sendPort.send(DateTime.now());
  });
}

// ----------------------------------------------------------------------------------------------------------------
// use compute to spawn isolate
// flutter example: https://flutter.dev/docs/cookbook/networking/background-parsing
runIsolateDemo3() {
  print("${Isolate.current.debugName}: print before doSomeLongTimeWork");
  compute(doSomeLongTimeWork, 2);
  print("${Isolate.current.debugName}: print after doSomeLongTimeWork");
}

void doSomeLongTimeWork(seconds) {
  // simulate heavy long time task...
  sleep(Duration(seconds: seconds));

  print("${Isolate.current.debugName}: finished long time work.");
}
