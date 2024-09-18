import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Research COTI Menu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MenuPage(),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Touch Demo Menu'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TouchForceDemoPage()),
              ),
              child: Text('Touch Area Demo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MissCounterPage()),
              ),
              child: Text('Miss Counter'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimerPage()),
              ),
              child: Text('Timer'),
            ),
          ],
        ),
      ),
    );
  }
}

class TouchForceDemoPage extends StatefulWidget {
  @override
  _TouchForceDemoPageState createState() => _TouchForceDemoPageState();
}

class _TouchForceDemoPageState extends State<TouchForceDemoPage> {
  double _force = 0.0;

  void _updateForce(double force) {
    setState(() {
      _force = force;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Touch Area Demo'),
      ),
      body: Listener(
        onPointerDown: (PointerDownEvent event) {
          _updateForce(event.size);
        },
        onPointerMove: (PointerMoveEvent event) {
          _updateForce(event.size);
        },
        onPointerUp: (PointerUpEvent event) {
          _updateForce(0.0);
        },
        child: Container(
          color: Colors.blue.withOpacity(0.1),
          child: Center(
            child: Text(
              'Area pressed: ${_force.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
      ),
    );
  }
}

class MissCounterPage extends StatefulWidget {
  @override
  _MissCounterPageState createState() => _MissCounterPageState();
}

class _MissCounterPageState extends State<MissCounterPage> {
  int _missCount = 0;

  int _currentNumber = 1;

  List<int> _numbers = [1, 2, 3, 4, 5, 6];

  // Handles the tapping of a circle
  void _handleCircleTap(int number) {
    if (number == _currentNumber) {
      setState(() {
        _currentNumber++;
        if (_currentNumber > 4) {
          _currentNumber = 1;
        }
      });
    } else {
      setState(() {
        _missCount++;

        _currentNumber = 1;
      });
    }
  }

  Widget _buildCircle(int number) {
    return GestureDetector(
      onTap: () => _handleCircleTap(number),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: number == _currentNumber ? Colors.green : Colors.blue,
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Miss Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Misses: $_missCount',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _numbers.map((number) => _buildCircle(number)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _result = '00:00:00';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {
        _result = _formatDuration(_stopwatch.elapsed);
      });
    });
  }

  void _stopTimer() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds =
        twoDigits(duration.inMilliseconds.remainder(1000) ~/ 10);
    return "$twoDigitMinutes:$twoDigitSeconds:$twoDigitMilliseconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _result,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _stopTimer,
              child: Text('Stop'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
