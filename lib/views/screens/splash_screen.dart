import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hey_chat/core/constants.dart';
import 'package:hey_chat/views/screens/chat_screen/chat_screen.dart';
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
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushAndRemoveUntil(RegisterScreen.route(), (route) => false);
    } else {
      //Chat page
      Navigator.of(context)
          .pushAndRemoveUntil(ChatScreen.route(), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: preloader,
    );
  }
}
