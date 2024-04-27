import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zohoclone/config/app_provider.dart';
import 'package:zohoclone/config/theming.dart';
import 'package:zohoclone/screens/forget_password_screen.dart';
import 'package:zohoclone/screens/login_screen.dart';
import 'package:zohoclone/screens/main_screen.dart';
import 'package:zohoclone/screens/register_screen.dart';
import 'package:zohoclone/screens/search_places_screen.dart';
import 'package:zohoclone/screens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppProvider() ,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: SplashScreen.route,
      routes: {
        SplashScreen.route : (context)=> const SplashScreen(),
        RegisterScreen.route : (context)=> const RegisterScreen(),
        LoginScreen.route : (context)=> const LoginScreen() ,
        MainScreen.route : (context)=> const MainScreen() ,
        ForgetPasswordScreen.route : (context)=> const ForgetPasswordScreen(),
        SearchPlacesScreen.route : (context)=> const SearchPlacesScreen(),
      },
      themeMode: ThemeMode.system,
      darkTheme: AppTheming.dartTheme,
      theme: AppTheming.lightTheme,
    ),);
  }
}

