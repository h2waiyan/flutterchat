import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgCtrl = TextEditingController();

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  User? currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() {
    setState(() {
      currentUser = auth.currentUser; // user credentials - email, name, ph
    });
  }

  // getDataFromFirestore() async {
  //   // GET DATA ONLY ONCE
  //   // var mydata = await firestore.collection('flutterchatroom').get();
  //   // for (var message in mydata.docs) {
  //   //   print(message.data());
  //   // }

  //   print(">>>>>>>>>>>>>>>>>>>");
  //   // GET DATA with STREAM - Snapshots
  //   await for (var snapshot
  //       in firestore.collection('flutterchatroom').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatty"),
        backgroundColor: const Color.fromARGB(255, 197, 107, 213),
        actions: [
          IconButton(
              onPressed: () {
                // getDataFromFirestore();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder(
              stream: firestore.collection('flutterchatroom').snapshots(),
              builder: (context, snapshot) {
                List<Text> messageList = [];

                if (snapshot.hasData) {
                  for (var message in snapshot.data!.docs) {
                    messageList.add(
                        Text("${message['sender']} - ${message['message']}"));
                  }
                }
                return Column(
                  children: messageList,
                );
              }),
          // const Column(
          //   children: [
          //     Text("Hi"),
          //     Text("Hello"),
          //   ],
          // ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Jot something down . . ."),
                    controller: msgCtrl,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    try {
                      await firestore.collection('flutterchatroom').add({
                        "sender": currentUser!.email,
                        "message": msgCtrl.text
                      });
                    } catch (e) {
                      print("Show error msg $e");
                    }
                  },
                  icon: const Icon(
                    Icons.telegram,
                    size: 30,
                    color: Colors.green,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
