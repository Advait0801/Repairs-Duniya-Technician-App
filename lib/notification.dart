import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:technician_app/presentation/technician_home_screen/technician_home_screen.dart';

class PushNotificationSystem {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // for termination state
  Future whenNotificationReceived(BuildContext context) async {
    try {
      _user = _auth.currentUser;

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
          // Future.delayed(Duration(seconds: 2), () {
          //   showToast("New notification received!");
          // });
        }
      });

      // for foreground state
      FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
        if (remoteMessage != null) {
          openAppShowAndShowNotification(
            remoteMessage.data["phonenumber"],
            remoteMessage.data["documentName"],
            remoteMessage.data["user"],
            context,
          );
          // showToast("New notification received!");
        }
      });

      // for background state
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage? remoteMessage) {
        if (remoteMessage != null) {
          openAppShowAndShowNotification(
            remoteMessage.data["phonenumber"],
            remoteMessage.data["documentName"],
            remoteMessage.data["user"],
            context,
          );
          // showToast("New notification received!");
        }
      });
    } catch (error) {
      log("Error in whenNotificationReceived: $error");
    }
  }

  openAppShowAndShowNotification(
      phoneNumber, documentName, user, context) async {
    try {
      log(user);
      log(_user!.uid);
      log(documentName);
      log(phoneNumber);

      if (_user != null &&
          phoneNumber != null &&
          documentName != null &&
          user != null) {
        String customerTokenId = '';

        await FirebaseFirestore.instance
            .collection('customers')
            .doc(user)
            .get()
            .then((snapshot) {
          if (snapshot.data()!['device_token'] != null) {
            customerTokenId = snapshot.data()!['device_token'].toString();
            log(customerTokenId);
          }
        });

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
            int time = snapshot.data()?['timeIndex'] ?? -1;
            DateTime date = snapshot.data()?['serviceDate'] ?? DateTime.now();
            bool urgentBooking = snapshot.data()?['urgentBooking'] ?? false;
            String address = snapshot.data()?['address']?.toString() ?? "hello";
            String service =
                snapshot.data()?['serviceName']?.toString() ?? 'hello';

            String timing = '';
            if (time == 0) {
              timing = 'Morning';
            } else if (time == 1) {
              timing = 'Afternoon';
            } else if (time == 2) {
              timing = 'Evening';
            }

            await _firestore
                .collection('technicians')
                .doc(_user!.uid)
                .collection('serviceList')
                .doc(documentName)
                .set({
              'jobAcceptance': job,
              'timeIndex': timing,
              'date': date,
              'serviceName': service,
              'serviceId': documentName,
              'customerPhone': phoneNumber,
              'urgentBooking': urgentBooking,
              'customerAddress': address,
              'status': 'p',
              'customerId': user,
              'customerTokenId': customerTokenId
            }, SetOptions(merge: true));

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const TechnicianHomeScreen()));
          } else {
            // Handle the case where the document does not exist
            log("Document does not exist.");
          }
        });
      } else {
        // Handle the case where _user is null
        log("something is null.");
      }
    } catch (error) {
      log("Error in openAppShowAndShowNotification: $error");
    }
  }
}
