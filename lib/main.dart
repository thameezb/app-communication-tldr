import 'package:app_communication_tldr/database_service.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'firebase_options.dart';

DBService _dbService = DBService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Communication ShortCircuit',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Communication ShortCircuit'),
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
  bool currentState = false;
  final _firebaseFunctions = FirebaseFunctions.instance;

  void _updateDB(bool currentState) {
    try {
      _dbService.refCurrentState.set(_getText(currentState));
    } on FirebaseException catch (error) {
      print(error.code);
      print(error.plugin);
      print(error.message);
    }
  }

  Future _sendMessage(bool currentState) async {
    try {
      await _firebaseFunctions
          .httpsCallable('notifyTopic')
          .call(<String, dynamic>{
        "messageTopic": "TLDR",
        "messageTitle": "Communication Status Updated",
        "messageBody": "Current state: ${_getText(currentState)}",
      });
    } on FirebaseFunctionsException catch (error) {
      print(error.code);
      print(error.details);
      print(error.message);
    }
  }

  void _update(bool value) {
    _updateDB(value);
    _sendMessage(value);
    setState(() {
      currentState = value;
    });
  }

  String _getText(bool currentState) {
    return currentState ? "Let me Rant!" : "Solutions Please";
  }

  IconData _getIcon(bool currentState) {
    return currentState ? Icons.coronavirus_rounded : Icons.tag_faces_rounded;
  }

  MaterialColor _getColour(bool currentState) {
    return currentState ? Colors.red : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedToggleSwitch<bool>.dual(
              current: currentState,
              first: false,
              second: true,
              dif: 50.0,
              borderColor: Colors.transparent,
              borderWidth: 5.0,
              height: 55,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1.5),
                ),
              ],
              onChanged: (value) => _update(value),
              colorBuilder: (value) => _getColour(value),
              iconBuilder: (value) => Icon(_getIcon(value)),
              textBuilder: (value) => Center(child: Text(_getText(value))),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
