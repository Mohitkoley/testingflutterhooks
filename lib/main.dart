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

class HomePage extends HookWidget {
  HomePage({Key? key}) : super(key: key);
  final DateFormat _dateFormat = DateFormat("hh:mm:ss a");
  getTime() => Stream<String>.periodic(const Duration(seconds: 1), (_) {
        final formated = _dateFormat.format(DateTime.now());
        return formated.toString();
      });

  @override
  Widget build(BuildContext context) {
    const String url = "https://bit.ly/3bjrYVZ";

    final chachedImage = useMemoized(() => NetworkAssetBundle(Uri.parse(url))
        .load(url)
        .then((data) => data.buffer.asUint8List())
        .then((data) => Image.memory(data)));

    final image = useFuture(chachedImage);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hook Example"),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [image.data].compactMap().toList(),
      )),
    );
  }
}
