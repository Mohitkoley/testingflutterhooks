import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([E? Function(T?)? transform]) =>
      map(transform ?? (e) => e).where((e) => e != null).cast();
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

class CountDown extends ValueNotifier {
  late StreamSubscription sub;
  CountDown({required int form}) : super(form) {
    sub = Stream.periodic(const Duration(seconds: 1), (v) => form - v)
        .takeWhile((value) => value >= 0)
        .listen(
          (value) => this.value = value,
        );
  }
}

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cachedValue = useMemoized(() => CountDown(form: 20));
    final count = useListenable(cachedValue);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hook Example"),
        centerTitle: true,
      ),
      body: Center(child: Text(count.value.toString())),
    );
  }
}
