# DOCS: Game Stats Acquisition and Analysis

### Github of the test application made: 



## Touch force quantification


To quantify touch force, we can use the **ForcePressGestureRecognizer** class in Flutter. This class returns a value ranging from 0.0 (indicating no discernible pressure) to 1.0 (indicating normal pressure), with the possibility of values exceeding 1.0 for stronger touches. On devices that do not support pressure detection, it always returns 1.0.

However, since only a few devices currently support this feature, we can opt for **touch area quantification** instead. By using the **size** property of the **PointerEvent** class:

```dart
onPointerDown: (PointerDownEvent  event) {
_updateForce(event.size);
},
onPointerMove: (PointerMoveEvent  event) {
_updateForce(event.size);
},
```

Which represents the area of the screen being pressed, we can achieve similar results. This value is scaled between 0 and 1 and can help identify the type of touch, such as:

![Area_Pressed](/uploads/9c4fed9ac2e36d2c9e1163f6a3dd2069/Area_Pressed.png)

On android devices:
- 0.1 for a fingertip touch,
- 0.2 for a full finger press,
- 0.3 for a palm press.

With this information, we can better assess the level of **accessibility** required, such as adjusting button **sizes**.



## Quantity of miss clicks

We can track the number of mistakes by checking if the button clicked matches the correct next number. Each time the user clicks the wrong button, the `missCount` is incremented. Here's an example:

```dart
int  _missCount = 0;
int  _currentNumber = 1;
List<int> _numbers = [1, 2, 3, 4, 5 ,6];

void  _handleCircleTap(int  number) {
if (number == _currentNumber) {
	setState(() {
	_currentNumber++;
	if (_currentNumber > 6) {
		_currentNumber = 1;
	}
});
	} else {
		setState(() {
		_missCount++;
		_currentNumber = 1;
	});
}

onTap: () => _handleCircleTap(number),
```

#### In the test application:

![image](/uploads/20faa2634f7520cb65f70821daabd282/image.png){width=361 height=740}

## Mean time per level 

To measure the time spent per level, we can utilize the **`Stopwatch`** class in Flutter, which provides a simple way to track elapsed time during the memory game.

The **`Stopwatch`** measures elapsed time while it's running, making it ideal for tracking player progress through different levels. It offers precise control over starting, stopping, and resetting the timer.

#### Using the Stopwatch
 To start measuring time, simply call the `start()` method, which initiates the timer and begins tracking time. 

Usage in the example bellow:
```dart
final stopwatch = Stopwatch();

void startLevel() {
  stopwatch.start();
}

void endLevel() {
  stopwatch.stop();
  print('Time taken: ${stopwatch.elapsedMilliseconds} ms');  // Output the elapsed time
  stopwatch.reset();
}
```

#### In the test application:

![image](/uploads/7795840c6ff0252fe08caf987460380c/image.png){width=362 height=738}


## Tracking the Step with the Most Misses (with visible or hidden spheres)

To effectively track which step has the most misses, you can maintain a map that records the number of misses for each step. Here's how you can use it:
```dart
int _missCount = 0;
int _currentNumber = 1;
List<int> _numbers = [1, 2, 3, 4, 5, 6];
Map<int, int> _missesPerStep = {};

void _handleCircleTap(int number) {
  if (number == _currentNumber) {
    setState(() {
      _currentNumber++;
      if (_currentNumber > 6) {
        _currentNumber = 1;
      }
    });
  } else {
    setState(() {
      _missCount++;
      _missesPerStep[_currentNumber] = (_missesPerStep[_currentNumber] ?? 0) + 1;
      _currentNumber = 1;
    });
  }
}

int stepWithMostMisses() {
  return _missesPerStep.entries
      .reduce((a, b) => a.value > b.value ? a : b)
      .key;
}
```

### Explanation:

-   `_missCount` keeps track of the total number of misses.
-   `_currentNumber` tracks the current step.
-   `_missesPerStep` is a map that records the number of misses for each step.

The `_handleCircleTap` method updates the current step or increments the miss count based on if the tapped number matches the current step. The `stepWithMostMisses` method finds and returns the step with the highest number of misses by reducing the entries in `_missesPerStep` to the entry with the maximum value.
