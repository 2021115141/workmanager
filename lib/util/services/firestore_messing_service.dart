import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class FirestoreMessagingService {
  // ignore: unused_field
  final FirebaseMessaging _firebaseMessaging;
  FirestoreMessagingService(this._firebaseMessaging);
  String currentToken = '';
  String serverKey =
      'BC0YIsJvvZUXrzJKMKzZNe8cPjapG-mbDhNXV5czMDfaIizH6YoTqhFhvh6YuB_We2dIWczD_tCSWvjIvT8Qizo';

  getToken() {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      FirebaseMessaging.instance
          .getToken()
          .then((value) => {currentToken = value!, saveToken(uid, value)});
    }
  }

  saveToken(String uid, String token) {
    FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .update({"messingToken": token});
  }

  Future<String> sendPushMessaging(
      String desToken, String title, String body) async {
    // ignore: unnecessary_null_comparison
    if (desToken == null) {
      return "no token exists";
    }

    try {
      // ignore: unused_local_variable
      var res = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          'token': currentToken,
          'notification': <String, dynamic>{'title': title, 'body': body},
          "android": {"priority": "normal"},
          "apns": {
            "headers": {"apns-priority": "5"}
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          "fcm_options": {
            //'send': '$currentToken',
          },
          'to': desToken,
        }),
      );

      return "success send message";
    } catch (e) {
      return "error while sending message";
    }
  }
}
