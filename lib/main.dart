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
    home: const HomePage(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
  ));
}

const String url = "https://images8.alphacoders.com/124/thumb-1920-1242638.jpg";
const imageHeight = 300.0;

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final opacity = useAnimationController(
        initialValue: 1.0, lowerBound: 0.0, upperBound: 1.0);

    final size = useAnimationController(
        initialValue: 1.0, lowerBound: 0.0, upperBound: 1.0);

    final controller = useScrollController();

    useEffect(() {
      controller.addListener(() {
        final newOpacity = max(imageHeight - controller.offset, 0.0);
        final normalized = newOpacity.normalize(0.0, imageHeight).toDouble();
        opacity.value = normalized;
        size.value = normalized;
      });
      return null;
    }, [controller]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hook Example"),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          SizeTransition(
            sizeFactor: size,
            axis: Axis.vertical,
            axisAlignment: -1.0,
            child: FadeTransition(
              opacity: opacity,
              child: Image.network(
                url,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: 100,
              itemBuilder: (context, index) => ListTile(
                title: Text("Person ${index + 1}"),
              ),
            ),
          )
        ],
      )),
    );
  }
}
