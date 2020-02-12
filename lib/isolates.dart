import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

class CrossIsolatesMessage<T> {
  final SendPort sender;
  final T content;

  CrossIsolatesMessage({
    @required this.sender,
    this.content,
  });
}

String stringInMainIsolate;
void runIsolateDemo() {
  stringInMainIsolate = "HelloFlutter!";
  ReceivePort receivePort = ReceivePort();

  Isolate.spawn(entryPoint, receivePort.sendPort, debugName: "myNewIsolate");

//  receivePort.listen((message) {
//    SendPort sendPort = message.sender;
//    int questionId = message.content["questionId"];
//    String content = message.content["question"];
//    print("${Isolate.current.debugName} receive sub isolate message: $content");
//    if (questionId == 1) {
//      sendPort.send(CrossIsolatesMessage(sender: receivePort.sendPort, content: "Yes, let's go to swim!"));
//    } else if (questionId == 2) {
//      sendPort.send(CrossIsolatesMessage(sender: receivePort.sendPort, content: "No, I'll stay at home."));
//    }
//  });

  Stream receiveStream = receivePort.asBroadcastStream();
  receiveStream.listen((message) {
    // logic 1
    SendPort sendPort = message.sender;
    int questionId = message.content["questionId"];
    String content = message.content["question"];
    print("${Isolate.current.debugName} receive sub isolate message: $content");
    if (questionId == 1) {
      sendPort.send(CrossIsolatesMessage(sender: receivePort.sendPort, content: "No!"));
    } else if (questionId == 2) {
      sendPort.send(CrossIsolatesMessage(sender: receivePort.sendPort, content: "Yes!"));
    }
  });

  receiveStream.listen((message) {
    // logic 2
    SendPort sendPort = message.sender;
    int questionId = message.content["questionId"];
    String content = message.content["question"];
    print("${Isolate.current.debugName} receive sub isolate message: $content");
    if (questionId == 1) {
      sendPort.send(CrossIsolatesMessage(sender: receivePort.sendPort, content: "Yes, let's go to swim!"));
    } else if (questionId == 2) {
      sendPort.send(CrossIsolatesMessage(sender: receivePort.sendPort, content: "No, I'll stay at home."));
    }
  });
}

void entryPoint(SendPort sendPort) {
  print("stringInMainIsolate: $stringInMainIsolate");

  ReceivePort receivePort = ReceivePort();
  sendPort.send(CrossIsolatesMessage(sender: receivePort.sendPort, content: {"questionId": 1, "question": "Go to swim?"}));
  sendPort.send(CrossIsolatesMessage(sender: receivePort.sendPort, content: {"questionId": 2, "question": "Go to play basketball?"}));

  receivePort.listen((message) {
    String content = message.content;
    print("${Isolate.current.debugName} receive main isolate message: $content");
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
