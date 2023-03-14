import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // esiste variabile 'widget' per riferirsi al widget che ha questo come stato
  final List<Widget> _spaces = [];
  final List<int> _placed = [];
  bool _isX = true;

  _MyHomePageState() {
    for (int i = 0; i < 9; i++) {
      _placed.add(0);
      _spaces.add(const Icon(null));
    }
  }

  void _place(int i) {
    setState(() {
      if (_isX) {
        _spaces[i] = const Icon(Icons.close, color: Colors.red);
        _placed[i] = 1;
      } else {
        _spaces[i] =
            const Icon(Icons.radio_button_unchecked, color: Colors.blue);
        _placed[i] = 2;
      }
      _isX = !_isX;
    });
    _checkwin(i);
  }

  void _checkwin(int i) {
    // 1 is X, 2 is O
    int row = (i / 3).floor();
    int col = i % 3;
    int type = _isX ? 2 : 1;

    for (int j = row * 3; j < (row * 3) + 3; j++) {
      if (_placed[j] != type) {
        return;
      }
    }
    for (int j = col; j < 9; j += 3) {
      if (_placed[j] != type) {
        return;
      }
    }

    _win();
  }

  void _win() {
    print("you win");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                  child: Container(
                color: Colors.black,
                padding: const EdgeInsets.all(10),
                child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(10),
                          child: IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: _spaces[0],
                              iconSize: 100,
                              onPressed: () {
                                if (_placed[0] == 0) _place(0);
                              })),
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(10),
                          child: IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: _spaces[1],
                              iconSize: 100,
                              onPressed: () {
                                if (_placed[1] == 0) _place(1);
                              })),
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(10),
                          child: IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: _spaces[2],
                              iconSize: 100,
                              onPressed: () {
                                if (_placed[2] == 0) _place(2);
                              })),
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(10),
                          child: IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: _spaces[3],
                              iconSize: 100,
                              onPressed: () {
                                if (_placed[3] == 0) _place(3);
                              })),
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(10),
                          child: IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: _spaces[4],
                              iconSize: 100,
                              onPressed: () {
                                if (_placed[4] == 0) _place(4);
                              })),
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(10),
                          child: IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: _spaces[5],
                              iconSize: 100,
                              onPressed: () {
                                if (_placed[5] == 0) _place(5);
                              })),
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(10),
                          child: IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: _spaces[6],
                              iconSize: 100,
                              onPressed: () {
                                if (_placed[6] == 0) _place(6);
                              })),
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(10),
                          child: IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: _spaces[7],
                              iconSize: 100,
                              onPressed: () {
                                if (_placed[7] == 0) _place(7);
                              })),
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(10),
                          child: IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: _spaces[8],
                              iconSize: 100,
                              onPressed: () {
                                if (_placed[8] == 0) _place(8);
                              })),
                    ]),
              ))
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Place a random icon',
        child: const Icon(Icons.radio_button_unchecked),
      ),
    );
  }
}
