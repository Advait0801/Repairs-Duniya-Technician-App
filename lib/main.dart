import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:technician_app/firebase_options.dart';
import 'package:technician_app/presentation/login_screen/login_screen.dart';
import 'package:technician_app/presentation/technician_home_screen/technician_home_screen.dart';
import 'package:technician_app/theme/theme_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String page = 'location';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeHelper().themeData(),
      title: 'rd_technician_app',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkLoginStatus(), // Check login status asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Return the appropriate screen based on the login status
            return snapshot.data == true
                ? const TechnicianHomeScreen()
                : const LoginScreen();
          } else {
            // Return a loading indicator or splash screen while checking login status
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? status = prefs.getString('userToken');
    if (status != null) {
      page = 'home';
      return true;
    }

    status = prefs.getString('uploads');
    if (status != null) {
      page = 'service';
      return true;
    }

    status = prefs.getString('location');
    if (status != null) {
      page = 'upload';
      return true;
    }

    return false;
  }
}
