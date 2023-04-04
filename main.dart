import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MineSweeper',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'MineSweeper'),
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
  final int size = 10;
  final int difficulty = 2;
  late int bombs;
  late int flags;
  late Timer timer;
  int elapsed = 0;
  bool stopped = false;
  bool settingup = false;
  int revealed = 0;
  Color bgcolor = Colors.white;

  late List<Widget> _containers;
  late List<List<bool>> _bombs;
  late List<List<bool>> _clicked;

  final List<double> difficulties = [6.5, 5.25, 4.75, 4];
  Map<int, Color> colors = {
    1: const Color.fromARGB(255, 0, 0, 212),
    2: const Color.fromARGB(255, 3, 179, 3),
    3: const Color.fromARGB(255, 232, 12, 12),
    4: const Color.fromARGB(255, 183, 11, 246),
    5: Colors.amber,
    6: const Color.fromARGB(255, 79, 186, 200),
    7: const Color.fromARGB(255, 125, 25, 58),
    8: const Color.fromARGB(255, 23, 23, 23)
  };

  _MyHomePageState() {
    setup();
  }

  void setup() {
    if (settingup) {
      return;
    }

    settingup = true;

    _containers = [];
    _bombs = [];
    _clicked = [];

    bombs = (size * size / difficulties[difficulty - 1]).floor();
    elapsed = 0;
    revealed = 0;
    stopped = false;

    for (int i = 1; i < size + 1; i++) {
      for (int j = 1; j < size + 1; j++) {
        _containers.add(
          Container(
            color: const Color.fromARGB(255, 196, 196, 196),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(1),
            child: IconButton(
              icon: const Icon(null),
              onPressed: () {
                reveal(i, j);
              },
            ),
          ),
        );
      }
    }

    createfields();

    placebombs();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsed++;
      });
    });

    settingup = false;
  }

  void createfields() {
    for (int i = 0; i < size + 2; i++) {
      _bombs.add(<bool>[]);
      _clicked.add(<bool>[]);
      for (int j = 0; j < size + 2; j++) {
        _bombs[i].add(false);
        _clicked[i].add(false);
      }
    }
  }

  void placebombs() {
    Random r = Random();
    flags = bombs;
    while (bombs > 0) {
      int cx = r.nextInt(size) + 1;
      int cy = r.nextInt(size) + 1;
      if (_bombs[cy][cx] == false) {
        _bombs[cy][cx] = true;
        bombs--;
      }
    }
    bombs = flags;
  }

  int near(int y, int x) {
    int count = 0;
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (_bombs[y + i][x + j]) {
          count++;
        }
      }
    }
    return count;
  }

  void reveal(int y, int x) {
    if (stopped) {
      return;
    }

    if (y == 0 || y == size + 1 || x == 0 || x == size + 1) {
      return;
    }

    if (_clicked[y][x]) {
      return;
    }

    _clicked[y][x] = true;

    Widget toadd;

    if (_bombs[y][x]) {
      setState(() {
        _containers[(y - 1) * size + (x - 1)] = Container(
            color: Colors.white,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(1),
            child: const Icon(Icons.sunny, color: Colors.black));
      });
      lose();
      return;
    }

    revealed++;
    if(size*size - revealed == bombs) {
      win();
    }

    int num = near(y, x);

    if (num == 0) {
      toadd = Container(
          color: Colors.white,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(1),
          child: const Icon(null));

      for (int dy = -1; dy < 2; dy++) {
        for (int dx = -1; dx < 2; dx++) {
          reveal(y + dy, x + dx);
        }
      }
    } else {
      toadd = Container(
          color: Colors.white,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(1),
          child:
              Text("$num", style: TextStyle(fontSize: 26, color: colors[num])));
    }

    setState(() {
      _containers[(y - 1) * size + (x - 1)] = toadd;
    });
  }

  void lose() {
    timer.cancel();
    stopped = true;

    for (int i = 1; i < size + 1; i++) {
      for (int j = 1; j < size + 1; j++) {
        if (_bombs[i][j]) {
          setState(() {
            _containers[(i - 1) * size + (j - 1)] = Container(
                color: Colors.white,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(1),
                child: const Icon(Icons.sunny, color: Colors.black));
          });
        }
      }
    }
  }

  void win() {
    timer.cancel();
    stopped = true;

    bgcolor = Colors.green;
  }

  List<Widget> getcontainers() => _containers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(color: bgcolor,
        child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
              flex: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    const SizedBox(width: 30),
                    const Icon(Icons.flag, color: Colors.red, size: 32),
                    Text(" $flags ", style: const TextStyle(fontSize: 22)),
                  ]),
                  Row(children: [
                    Text("Elapsed: $elapsed",
                        style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 30),
                  ]),
                ],
              )),
          const Flexible(flex: 1, child: Icon(null)),
          Flexible(
            flex: 8,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                  color: bgcolor,
                  padding: const EdgeInsets.all(5),
                  child: Container(
                      color: Colors.black,
                      padding: const EdgeInsets.all(5),
                      child: GridView.count(
                          crossAxisCount: size,
                          shrinkWrap: true,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          children: List.from(_containers))))
            ]),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!settingup) {
            setup();
          }
        },
        tooltip: "Restarts the game",
        child: const Icon(Icons.restart_alt, color: Colors.white),
      ),
    );
  }
}

// TODO: add difficulties on restart buttons