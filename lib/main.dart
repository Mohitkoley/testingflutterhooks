import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([E? Function(T?)? transform]) =>
      map(transform ?? (e) => e).where((e) => e != null).cast();
}

extension Normalize on num {
  num normalize(num selfRangeMin, num selfRangeMax,
          [num normalizedRangeMin = 0.0, num normalizedRangeMax = 1.0]) =>
      (normalizedRangeMax - normalizedRangeMin) *
          (this - selfRangeMin) /
          (selfRangeMax - selfRangeMin) +
      normalizedRangeMin;
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
  ));
}

const String url = "https://images8.alphacoders.com/124/thumb-1920-1242638.jpg";

enum Action { rotateLeft, rotateRight, lessVisible, moreVisible }

class State {
  final double alpha;
  final double rotation;

  State({required this.alpha, required this.rotation});

  State.zero()
      : alpha = 1.0,
        rotation = 0.0;

  rotateRight() => State(alpha: alpha, rotation: rotation + 10.0);

  rotateLeft() => State(alpha: alpha, rotation: rotation - 10.0);

  increaseAlpha() => State(alpha: min(alpha + 0.1, 1.0), rotation: rotation);

  decreaseAlpha() => State(alpha: max(alpha - 0.1, 0.0), rotation: rotation);
}

State reducer(State oldState, Action? action) {
  switch (action) {
    case Action.lessVisible:
      return oldState.decreaseAlpha();
    case Action.moreVisible:
      return oldState.increaseAlpha();
    case Action.rotateLeft:
      return oldState.rotateLeft();
    case Action.rotateRight:
      return oldState.rotateRight();
    default:
      return oldState;
  }
}

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Action?>(reducer,
        initialState: State.zero(), initialAction: null);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hook Example"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      store.dispatch(Action.rotateLeft);
                    },
                    child: const Text("Rotate Left")),
                TextButton(
                    onPressed: () {
                      store.dispatch(Action.rotateRight);
                    },
                    child: const Text("Rotate Right")),
                TextButton(
                    onPressed: () {
                      store.dispatch(Action.moreVisible);
                    },
                    child: const Text("+ Alpha")),
                TextButton(
                    onPressed: () {
                      store.dispatch(Action.lessVisible);
                    },
                    child: const Text("- Alpha")),
              ],
            ),
            const SizedBox(height: 10),
            Opacity(
              opacity: store.state.alpha,
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(store.state.rotation / 360.0),
                child: Image.network(
                  url,
                  //fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
