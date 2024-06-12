// firebase_service.dart
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  Future<void> getData() async {
    DataSnapshot snapshot = await databaseReference
        .child(
            'https://console.firebase.google.com/u/0/project/tourapp-f8426/database/tourapp-f8426-default-rtdb/data/~2F')
        .once();
    print('Data : ${snapshot.value}');
  }
}
