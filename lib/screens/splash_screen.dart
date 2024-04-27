import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zohoclone/helper/firebase_helper.dart';
import 'package:zohoclone/screens/register_screen.dart';
import 'package:zohoclone/utils/app_constants.dart';

import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String route = AppConstants.splashRoute ;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance ;
      if (firebaseAuth.currentUser != null){
        FireBaseHelper.readUserInfoFromRealTime();
        Navigator.pushReplacementNamed(context, MainScreen.route);
      }else {
        Navigator.pushReplacementNamed(context, RegisterScreen.route);
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(child: Text ("Trippo" , style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontSize: 25
        ))),
      ),
    );
  }
}
