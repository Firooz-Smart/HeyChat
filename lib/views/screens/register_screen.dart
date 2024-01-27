import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hey_chat/core/constants.dart';
import 'package:hey_chat/core/helpers.dart';
import 'package:hey_chat/main.dart';
import 'package:hey_chat/views/screens/chat_screen.dart';
import 'package:hey_chat/views/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.isRegistering});

  static Route<void> route({isRegistering = false}) {
    return MaterialPageRoute(
        builder: (context) => RegisterScreen(isRegistering: isRegistering));
  }

  final bool isRegistering;
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();

  Future<void> _signUp() async {
    bool valid = _formKey.currentState!.validate();

    if (!valid) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final email = _emailController.text;
    final pass = _passwordController.text;
    final username = _userNameController.text;

    try {
      await supabase.auth.signUp(
        email: email,
        password: pass,
        data: {'username': username},
      );
      Navigator.pushAndRemoveUntil(
          context, ChatScreen.route(), (route) => false);
    } on AuthException catch (e) {
      context.showErrorSnackBar(message: e.message);
    } catch (e) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: formPadding,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
            ),
            formSpacer,
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }

                if (value.length < 6) {
                  return 'Password must at least 6 characters';
                }

                return null;
              },
            ),
            formSpacer,
            TextFormField(
              controller: _userNameController,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (value) {
                {
                  if (value == null || value.isEmpty) {
                    return 'Username required';
                  }

                  final isValid =
                      RegExp(r'^[A-Za-z0-9_]{3,24}$').hasMatch(value);
                  if (!isValid) {
                    return '3-24 long with alphanumeric or underscore';
                  }

                  return null;
                }
              },
            ),
            formSpacer,
            ElevatedButton(
              onPressed: isLoading ? null : _signUp,
              child: const Text('Register'),
            ),
            formSpacer,
            TextButton(
              onPressed: () {
                //Goto login
                Navigator.of(context).push(LoginScreen.route());
              },
              child: const Text('I already have an account'),
            )
          ],
        ),
      ),
    );
  }
}
