import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:renown/router.dart';
import 'package:renown/screens/signup.dart';
import 'package:renown/viewmodel/auth_viewmodel.dart';
import 'package:renown/viewmodel/chat_viewmodel.dart';
import 'package:renown/viewmodel/connectivity_viewmodel.dart';


void main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );

  // Enable offline persistence
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
        ChangeNotifierProvider(create: (_) => ConnectivityViewModel()),
      ],
      child: MaterialApp(
        title: 'chat',
          onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.home,
        home: SignUpView(), // Your main screen widget
      ),
    );
  }
}
