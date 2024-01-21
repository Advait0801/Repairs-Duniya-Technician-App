import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PushNotificationSystem {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  User? _user;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // for termination state
  Future whenNotificationReceived(BuildContext context) async {
    try {
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? remoteMessage) {
        if (remoteMessage != null) {
          openAppShowAndShowNotification(
            remoteMessage.data["phonenumber"],
            remoteMessage.data["documentName"],
            remoteMessage.data["user"],
            context,
          );
          Future.delayed(const Duration(seconds: 2), () {
            showToast("New notification received!");
          });
        }
      });

      // for foreground state
      FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
        if (remoteMessage != null) {
          openAppShowAndShowNotification(
            remoteMessage.data?["phonenumber"],
            remoteMessage.data?["documentName"],
            remoteMessage.data?["user"],
            context,
          );
          showToast("New notification received!");
        }
      });

      // for background state
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage? remoteMessage) {
        if (remoteMessage != null) {
          openAppShowAndShowNotification(
            remoteMessage.data?["phonenumber"],
            remoteMessage.data?["documentName"],
            remoteMessage.data?["user"],
            context,
          );
          showToast("New notification received!");
        }
      });
    } catch (error) {
      log("Error in whenNotificationReceived: $error");
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  openAppShowAndShowNotification(
      phoneNumber, documentName, user, context) async {
    try {
      log(user);
      showToast(user);

      if (_user != null) {
        await FirebaseFirestore.instance
            .collection("customers")
            .doc(user)
            .collection("serviceDetails")
            .doc(documentName)
            .get()
            .then((snapshot) async {
          if (snapshot.exists) {
            bool job = snapshot.data()?['jobAcceptance'] ?? false;
            String phoneNumber = snapshot.data()?['userPhoneNumber'] ?? "error";
            int time = snapshot.data()?['timeIndex'] ?? 0;
            DateTime date = snapshot.data()?['timeIndex'] ?? DateTime.now();
            bool urgentBooking = snapshot.data()?['urgentBooking'] ?? false;
            String address = snapshot.data()?['address']?.toString() ?? "hello";

            await _firestore
                .collection('technicians')
                .doc(_user!.uid)
                .collection('serviceList')
                .doc(documentName)
                .set({
              'jobAcceptance': job,
              'timeIndex': time,
              'date': date,
              'customerPhone': phoneNumber,
              'urgentBooking': urgentBooking,
              'customerAddress': address,
              'status': 'p',
            }, SetOptions(merge: true));
          } else {
            // Handle the case where the document does not exist
            log("Document does not exist.");
          }
        });
      } else {
        // Handle the case where _user is null
        log("_user is null.");
      }
    } catch (error) {
      log("Error in openAppShowAndShowNotification: $error");
    }
  }
}
