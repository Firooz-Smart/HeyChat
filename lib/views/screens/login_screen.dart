import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hey_chat/core/constants.dart';
import 'package:hey_chat/core/helpers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool loading = false;
  Future<void> _login() async {
    setState(() {
      loading = true;
    });
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }

    try {
      final email = _emailController.text;
      final pass = _passwordController.text;

      final authResponse = await supabase.auth
          .signInWithPassword(password: pass.trim(), email: email);

      if (authResponse.session != null) {
        Navigator.pushAndRemoveUntil(
            context, ChatScreen.route(), (route) => false);
      }
    } on AuthException catch (e) {
      context.showErrorSnackBar(message: e.message);
    } catch (e) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: formPadding,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is requried';
                }

                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            formSpacer,
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }

                return null;
              },
            ),
            formSpacer,
            ElevatedButton(
                onPressed: loading ? null : _login, child: const Text('Login'))
          ],
        ),
      ),
    );
  }
}
