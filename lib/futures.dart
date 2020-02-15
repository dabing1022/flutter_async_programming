import 'dart:async';
import 'dart:io';

void runFuturesDemo() async {
  print("runFuturesDemo start...");

  // future1 ------------------------------------
  Future future1 = new Future(() => null);
  future1.then((_) {
    print("future1 then 1");
  }).catchError((e) {
    print("future1 catchError");
  }).whenComplete(() {
    print("future1 whenComplete");
  });

  // future2 ------------------------------------
  Future future2 = Future(() {
    print("future2 init");
  });

  future2.then((_) {
    print("future2 then");
    future1.then((_) {
      print("future1 then3");
    });
  }).catchError((e) {
    print("future2 catchError");
  }).whenComplete(() {
    print("future2 whenComplete");
  });

  future1.then((_) {
    print("future1 then2");
  });

  // future3 ------------------------------------
  Future future3 = Future.microtask(() {
    print("future3 init");
  });

  // future4 ------------------------------------
  Future future4 = Future.sync(() {
    print("future4 init");
  });

  // future5 ------------------------------------
  Future future5 = Future(() {
    print("future5 init");
  });

  // future6 ------------------------------------
  Future future6 = Future.delayed(Duration(seconds: 3), () {
    print("future6 init");
  });

  print("runFuturesDemo end...");
}

/**
void runFuturesDemo2() {
  queryName(100).then((name) {
    print("id 100 user name is $name");
  }, onError: (e) {
    print(e.toString());
  }).whenComplete(() {
    print("finally finished.");
  });
}

Future queryName(int id) {
  var completer = new Completer();
  // 查询数据库，然后根据成功或者失败执行相应的callback回调，这个过程是异步的
  database.query("select name from user where id = $id", (results) {
    // when complete
    completer.complete(results);
  }, (error) {
    completer.completeError(error);
  });

  // return 在query结果出来之前就会被执行
  return completer.future;
}
*/
