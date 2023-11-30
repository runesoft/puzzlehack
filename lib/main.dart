import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Runes godylt fede spil'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Pos {
  int row;
  int column;
  int value;
  Pos(this.row, this.column, this.value);
}

class _MyHomePageState extends State<MyHomePage> {
  int rowcount = 4;
  int columncount = 4;
  List<Pos> pos = [];
  double tilesize = 80.0;
  void reset() {
    int count = 0;
    for (int r = 0; r < rowcount; r++) {
      for (int c = 0; c < columncount; c++) {
        pos.add(Pos(r, c, ++count));
      }
    }
    pos.removeLast();
  }

  void move(Pos p) {
    var row = pos.where((element) => element.row == p.row);
    if (row.length < columncount) {
      var moveto = [
        0,
        1,
        2,
        3,
        4,
        5
      ].firstWhere((columnid) => !row.any((tile) => tile.column == columnid));
      if (moveto > p.column) {
        setState(() {
          for (var r in row.where((element) =>
              element.column >= p.column && element.column < moveto)) {
            r.column++;
          }
        });
      } else {
        setState(() {
          for (var r in row.where((element) =>
              element.column <= p.column && element.column > moveto)) {
            r.column--;
          }
        });
      }

      return;
    }
    var column = pos.where((element) => element.column == p.column);
    if (column.length < rowcount) {
      var moveto = [0, 1, 2, 3, 4, 5]
          .firstWhere((rowid) => !column.any((tile) => tile.row == rowid));
      if (moveto > p.row) {
        setState(() {
          for (var r in column.where(
              (element) => element.row >= p.row && element.row < moveto)) {
            r.row++;
          }
        });
      } else {
        setState(() {
          for (var r in column.where(
              (element) => element.row <= p.row && element.row > moveto)) {
            r.row--;
          }
        });
      }
      return;
    }
  }

  void shuffle() {
    Random rnd = Random();
    setState(() {
      for (int i = 0; i < 50; i++) {
        move(pos[rnd.nextInt(pos.length)]);
        //Swap(pos[rnd.nextInt(pos.length)], pos[rnd.nextInt(pos.length)]);
      }
      //var end = pos[rnd.nextInt(pos.length)];
      //end.column = 5;
      //end.row = 5;
    });
  }

  void Swap(Pos p1, Pos p2) {
    int c = p1.column;
    int r = p1.row;

    p1.column = p2.column;
    p1.row = p2.row;
    p2.column = c;
    p2.row = r;
  }

  _MyHomePageState() {
    reset();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: SizedBox(
        width: tilesize * columncount + 10,
        height: tilesize * rowcount + 10,
        child: Stack(
          children: pos
              .map((p) => AnimatedPositioned(
                  height: tilesize - 20,
                  width: tilesize - 20,
                  top: 10 + (p.row * tilesize),
                  left: 10 + (p.column * tilesize),
                  child: GestureDetector(
                      onTap: () {
                        move(p);
                      },
                      child: Container(
                        color: Colors.blue,
                        child: Center(child: Text(p.value.toString())),
                      )),
                  duration: Duration(milliseconds: 300)))
              .toList(),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => shuffle(),
        child: Icon(Icons.rotate_right),
      ),
    );
  }
}
