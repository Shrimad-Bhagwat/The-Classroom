import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final _currentUser = _auth.currentUser;
final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

// Custom UID
String myemail = _currentUser!.email.toString();
String? customUID = myemail.split("@")[0];


class Notice {
  final String title;
  final String content;

  Notice({required this.title, required this.content});
}

final List<Notice> notices = [];

Future<void> fetchNoticeData()async {
  final ref = FirebaseDatabase.instance
      .ref('notices');

  final dataSnapshot = await ref.get();

  // Clear the existing data in the result list.
  notices.clear();

  if (dataSnapshot.value != null) {
    // Convert the Firebase data to a Map.
    Map<dynamic, dynamic> data = dataSnapshot.value as Map<dynamic, dynamic>;
    print(data);
    // Loop through the data and create ResultData objects.
    data.forEach((key, value) {
      Notice notice = Notice(
        title: value['title'],
        content: value['content'],
      );
      notices.add(notice);
    });
  }
}

void storeNoticeData() {
  if (_currentUser != null) {
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    databaseReference
        .child('notices/$id')
        // .child('users/${_currentUser!.uid}_$customUID/result/$resultId')
        .set({
      // == Result ==
      'id': id,
      'title': 'Notice 3',
      'content': "Placement Drive to begin from August '23",

    });
  }
}
