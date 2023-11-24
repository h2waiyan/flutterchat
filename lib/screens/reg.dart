import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/screens/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
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
                      await auth.createUserWithEmailAndPassword(
                          email: email.text, password: pass.text);

                  if (context.mounted) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const Login();
                    }));
                  }
                } on FirebaseAuthException catch (e) {
                  print(e.code);
                } catch (e) {
                  print(e);
                }
              },
              child: const Text("Register"))
        ],
      )),
    );
  }
}
