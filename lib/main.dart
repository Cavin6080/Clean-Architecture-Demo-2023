import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(DemoController());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              left: logic.switchPos.value ? 20 : null,
              right: 20,
              child: Container(
                height: 200,
                width: 200,
                color: Colors.red,
              ),
              duration: Duration(
                milliseconds: 1000,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: logic.setInt,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DemoController extends GetxController {
  Rx<double?>? pos = 0.0.obs;
  Rx<bool> switchPos = false.obs;
  setInt() {
    // if (switchPos.value) {
    //   // pos?.value = null;
    // } else {
    //   pos?.value = 20;
    // }
    switchPos.value = !switchPos.value;
  }
}
