import 'package:apptalk/firebase/auth_service.dart';
import 'package:apptalk/pages/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:apptalk/pages/login.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
  runApp(
      ChangeNotifierProvider(
          create: (context) => AuthService(),
      child: const MyApp(),
      )
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // final CameraDescription camera;

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:MainMenu(),

    );
  }
}
