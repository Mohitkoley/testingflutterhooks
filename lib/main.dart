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
    home: const HomePage(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
  ));
}

const String url = "https://images8.alphacoders.com/124/thumb-1920-1242638.jpg";

class HomePage extends HookWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lifecycle = useAppLifecycleState();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hook Example"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Opacity(
          opacity: lifecycle == AppLifecycleState.resumed ? 1.0 : 0.0,
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black.withAlpha(100),
                spreadRadius: 10,
              ),
            ]),
            child: Center(child: Image.asset("assets/card.jpg")),
          ),
        ),
      ),
    );
  }
}
