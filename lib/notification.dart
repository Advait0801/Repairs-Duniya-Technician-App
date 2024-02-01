import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:technician_app/dialog.dart';
import 'dart:developer';
import 'package:technician_app/presentation/technician_home_screen/technician_home_screen.dart';

class PushNotificationSystem {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final int _timerDuration = 250;

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
            Timestamp timeStamp =
                snapshot.data()?['DateTime'] ?? Timestamp.now();
            DateTime bookingTime = timeStamp.toDate();
            DateTime currentTime = DateTime.now();

            String timing = '';
            if (time == 0) {
              timing = 'Morning';
            } else if (time == 1) {
              timing = 'Afternoon';
            } else if (time == 2) {
              timing = 'Evening';
            }

            if (currentTime.difference(bookingTime) <=
                const Duration(minutes: 3)) {
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
                'customerId': user,
                'customerTokenId': customerTokenId,
                'status': 'p',
              }, SetOptions(merge: true));

              await _firestore
                  .collection('technicians')
                  .doc(_user!.uid)
                  .collection('notifications')
                  .add({
                'message': 'You have received a new service from $phoneNumber',
                'timestamp': FieldValue.serverTimestamp()
              });
            }

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const TechnicianHomeScreen()),
                ((route) => false));

            // Set the threshold for showing the dialog (2 minutes)
            const int thresholdSeconds = 300;

            // Calculate the remaining time in seconds
            int remainingSeconds = _timerDuration;

            if (remainingSeconds <= thresholdSeconds &&
                currentTime.difference(bookingTime) <=
                    const Duration(minutes: 3)) {
              // Show the dialog
              showDialog(
                context: context,
                builder: (context) => NotificationDialog(
                  remainingSeconds: remainingSeconds,
                  docname: documentName,
                  serviceName: service,
                  time: timing,
                  date: date,
                  urgent: urgentBooking,
                  phoneNumber: phoneNumber,
                  address: address,
                  user: user,
                ),
              );
            }
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
