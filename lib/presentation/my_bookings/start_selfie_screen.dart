import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:technician_app/core/app_export.dart';
import 'package:technician_app/presentation/my_bookings/my_bookings_screen.dart';
import 'package:technician_app/widgets/custom_elevated_button.dart';

class StartSelfieScreen extends StatefulWidget {
  const StartSelfieScreen({super.key, required this.docName});
  final String docName;

  @override
  State<StartSelfieScreen> createState() => _StartSelfieScreenState();
}

class _StartSelfieScreenState extends State<StartSelfieScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? _user;
  File? imageSelfiePath;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  Future<void> _uploadFile(File path) async {
    try {
      setState(() {
        isUploading = true;
      });
      File pickedFile = path;

      final Reference storageReference = _storage
          .ref()
          .child('uploads/${_user!.uid}/${widget.docName}_startingSelfie');
      final TaskSnapshot snapshot = await storageReference.putFile(pickedFile);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await _firestore
          .collection('technicians')
          .doc(_user!.uid)
          .collection('serviceList')
          .doc(widget.docName)
          .set({'startingSelfie': downloadUrl}, SetOptions(merge: true));

      await _firestore
          .collection('technicians')
          .doc(_user!.uid)
          .collection('serviceList')
          .doc(widget.docName)
          .update({'status': 's', 'jobAcceptance': true});

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyBookingsScreen(id: 's')),
          (route) => false);
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isUploading == true
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.2,
                      decoration:
                          AppDecoration.outlineOnPrimaryContainer.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder14,
                      ),
                      child: imageSelfiePath != null
                          ? GestureDetector(
                              onTap: () async {
                                try {
                                  final image = await ImagePicker()
                                      .pickImage(source: ImageSource.camera);
                                  if (image == null) return;

                                  final path = File(image.path);
                                  setState(() {
                                    imageSelfiePath = path;
                                  });
                                } on PlatformException catch (e) {
                                  log(e.toString());
                                }
                              },
                              child: Image.file(
                                imageSelfiePath!,
                                width: MediaQuery.of(context).size.width * 0.03,
                                height: MediaQuery.of(context).size.width * 0.2,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () async {
                                  try {
                                    final image = await ImagePicker()
                                        .pickImage(source: ImageSource.camera);
                                    if (image == null) return;

                                    final path = File(image.path);
                                    setState(() {
                                      imageSelfiePath = path;
                                    });
                                  } on PlatformException catch (e) {
                                    log(e.toString());
                                  }
                                },
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 20.v,
                    ),
                    Text(
                      "Selfie",
                      style: theme.textTheme.bodySmall,
                    ),
                    SizedBox(
                      height: 20.v,
                    ),
                    imageSelfiePath != null
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.v, horizontal: 30.h),
                            child: CustomElevatedButton(
                              buttonStyle: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.black)),
                              text: "Verify",
                              onPressed: () {
                                _uploadFile(imageSelfiePath!);
                              },
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.v, horizontal: 30.h),
                            child: CustomElevatedButton(
                              text: "Verify",
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
