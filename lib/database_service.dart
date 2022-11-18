import 'package:firebase_database/firebase_database.dart';

class DBService {
  late final DatabaseReference refCurrentState;
  late String _initialState;

  Future init() async {
    refCurrentState = FirebaseDatabase.instance.ref('currentState');

    DataSnapshot cs = await refCurrentState.get();
    _initialState = cs.value.toString();
  }

  String getInitialState() {
    return _initialState;
  }
}
