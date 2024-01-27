import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hey_chat/core/constants.dart';
import 'package:hey_chat/views/screens/register_screen.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _redirect();
  }

  void _redirect() async {
    //wait for widget to be fully mounted
    await Future.delayed(Duration.zero);

    final session = supabase.auth.currentSession;
    if (session == null) {
      //Register page
      Navigator.push(context, RegisterPage.route());
    } else {
      //Chat page
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: preloader,
    );
  }
}
