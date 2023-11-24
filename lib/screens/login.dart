import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/screens/chat.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
          child: Column(
        children: [
          TextField(
            controller: email,
          ),
          TextField(
            controller: pass,
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential newUser =
                      await auth.signInWithEmailAndPassword(
                          email: email.text, password: pass.text);

                  if (context.mounted) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ChatScreen();
                    }));
                  }
                } on FirebaseAuthException catch (e) {
                  print(e.code);
                } catch (e) {
                  print(e);
                }
              },
              child: const Text("Login"))
        ],
      )),
    );
  }
}
