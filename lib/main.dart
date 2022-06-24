import 'dart:async';

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

class HomePage extends HookWidget {
  HomePage({Key? key}) : super(key: key);

  late final StreamController<double> streamController =
      useStreamController<double>(onListen: () {
    streamController.sink.add(0.0);
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hook Example"),
        centerTitle: true,
      ),
      body: StreamBuilder<double>(
          stream: streamController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final rotation = snapshot.data ?? 0.0;
              return GestureDetector(
                onTap: () => streamController.sink.add(rotation + 0.1),
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(rotation / 360.0),
                  child: Center(
                    child: Image.network(
                      url,
                      //fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
