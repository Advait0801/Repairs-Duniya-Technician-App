// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_final_fields, avoid_init_to_null, unused_local_variable, unused_field, prefer_const_declarations

import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:technician_app/core/app_export.dart';
import 'package:technician_app/presentation/id_verification_screen/id_verification_screen.dart';
import 'package:technician_app/widgets/custom_elevated_button.dart';
import 'package:technician_app/widgets/custom_text_form_field.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class ConfirmLocationScreen extends StatefulWidget {
  const ConfirmLocationScreen({super.key});

  @override
  State<ConfirmLocationScreen> createState() => _ConfirmLocationScreenState();
}

class _ConfirmLocationScreenState extends State<ConfirmLocationScreen> {
  final List<String> codes = [
    '516001',
    '516002',
    '516003',
    '516004',
    '560076',
    '560102',
  ];
  LatLng? _currentPosition = null;
  String _postalCode = '';
  String _currentAddress = '';
  TextEditingController _controller = TextEditingController();
  var uuid = const Uuid();
  String? sessionToken = '1234';
  List<dynamic> _placesList = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  Future<void> getUsersCurrentLocation() async {
    bool _serviceEnabled;
    LocationPermission _permission;

    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      return Future.error('Location Services are disabled');
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();

      if (_permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are denied forever, cannot request permission');
    }

    Position _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(_position.latitude, _position.longitude);
    Placemark place = placemarks[0];

    setState(() {
      _currentPosition = LatLng(_position.latitude, _position.longitude);
      _currentAddress =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      _postalCode = place.postalCode!;
    });
  }

  void onChange() {
    if (sessionToken == null) {
      setState(() {
        sessionToken = uuid.v4();
      });
    }

    getSuggestion(_controller.text);
  }

  void getSuggestion(String s) async {
    String requestUrl =
        '$GOOGLE_MAPS_PLACES_API?input=$s&key=$GOOGLE_MAPS_API_KEY&sessiontoken=$sessionToken';
    var response = await http.get(Uri.parse(requestUrl));
    print(response.body.toString());

    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed........');
    }
  }

  Future<void> uploadLocation() async {
    try {
      await _firestore
          .collection('technician-users')
          .doc(_user!.uid)
          .set({'location': _currentAddress});
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getUsersCurrentLocation();
    _controller.addListener(() {
      onChange();
    });
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPickALocationFrame(context),
            _controller.text.isEmpty
                ? Expanded(
                    child: _currentPosition == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _currentPosition!,
                              zoom: 13,
                            ),
                            zoomControlsEnabled: false,
                            markers: {
                              Marker(
                                  markerId: const MarkerId('currentLcoation'),
                                  icon: BitmapDescriptor.defaultMarker,
                                  position: _currentPosition!)
                            },
                          ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _placesList.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () async {
                          List<Location> l = await locationFromAddress(
                              _placesList[index]['description']);
                          LatLng latLng =
                              LatLng(l.last.latitude, l.last.longitude);
                          List<Placemark> places =
                              await placemarkFromCoordinates(
                                  latLng.latitude, latLng.longitude);
                          Placemark place = places[0];
                          setState(() {
                            _currentPosition = latLng;
                            _currentAddress =
                                '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
                            _postalCode = place.postalCode!;
                          });
                          _controller.clear();
                        },
                        title: Text(
                          _placesList[index]['description'],
                          style: CustomTextStyles.bodySmallGray800,
                        ),
                      ),
                    ),
                  ),
            _buildConfirmLocationFrame(context)
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildPickALocationFrame(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 11.v,
      ),
      decoration: AppDecoration.gradientPrimaryToGray,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 17.v),
          Text(
            "Pick a location",
            style: CustomTextStyles.headlineSmallOnError,
          ),
          SizedBox(height: 9.v),
          CustomTextFormField(
            onChanged: (value) {},
            controller: _controller,
            hintText: "Willowbrook Heights, New Delhi - 110001, India",
            textInputAction: TextInputAction.done,
            prefix: Container(
              margin: EdgeInsets.fromLTRB(19.h, 9.v, 8.h, 9.v),
              child: CustomImageView(
                imagePath: ImageConstant.imgVector22x20,
                height: 22.v,
                width: 20.h,
              ),
            ),
            prefixConstraints: BoxConstraints(
              maxHeight: 40.v,
            ),
            suffix: Container(
              margin: EdgeInsets.fromLTRB(30.h, 6.v, 12.h, 6.v),
              child: CustomImageView(
                imagePath: ImageConstant.imgDownChevron,
                height: 28.v,
                width: 24.h,
              ),
            ),
            suffixConstraints: BoxConstraints(
              maxHeight: 40.v,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 11.v),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildConfirmLocationFrame(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 23.h,
        vertical: 24.v,
      ),
      decoration: AppDecoration.gradientOnErrorToGray,
      child: Column(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgImage72,
            height: 66.adaptSize,
            width: 66.adaptSize,
          ),
          SizedBox(height: 3.v),
          Text(
            "Confirm your location",
            style: theme.textTheme.headlineSmall,
          ),
          SizedBox(height: 18.v),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.h),
            padding: EdgeInsets.symmetric(
              horizontal: 31.h,
              vertical: 14.v,
            ),
            decoration: AppDecoration.fillGray.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder15,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgVector22x20,
                  height: 24.v,
                  width: 22.h,
                  margin: EdgeInsets.only(
                    top: 1.v,
                    bottom: 9.v,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 261.h,
                    margin: EdgeInsets.only(
                      left: 19.h,
                      top: 1.v,
                      right: 6.h,
                    ),
                    child: Text(
                      _currentAddress,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.bodySmallGray800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.v),
          CustomElevatedButton(
            onPressed: () {
              if (codes.contains(_postalCode) == true) {
                uploadLocation();
                final snackBar = const SnackBar(
                  content: Text('Location set successfully!!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const IdVerificationScreen()));
              } else {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: Text('Invalid pincode....',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.1)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'OK',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: mediaQueryData.size.width * 0.05),
                              ),
                            )
                          ],
                        ));
              }
            },
            text: "Yes, that’s my location",
            buttonStyle: CustomButtonStyles.none,
            decoration: CustomButtonStyles.gradientPrimaryToGrayDecoration,
          ),
          SizedBox(height: 19.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgArrowLeft,
                height: 20.adaptSize,
                width: 20.adaptSize,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: Text(
                  "Back",
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ],
          ),
          SizedBox(height: 28.v),
        ],
      ),
    );
  }
}
