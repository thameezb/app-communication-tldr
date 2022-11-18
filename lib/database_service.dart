import 'package:firebase_database/firebase_database.dart';

class DBService {
  final DatabaseReference refCurrentState =
      FirebaseDatabase.instance.ref('currentState');
}
