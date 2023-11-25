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
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 197, 107, 213),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder(
              stream: firestore
                  .collection('gameroom')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                List<MessageBubble> messageList = [];

                if (snapshot.hasData) {
                  for (var message in snapshot.data!.docs) {
                    messageList.add(MessageBubble(
                      isMe: message['sender'] == currentUser!.email,
                      sender: message['sender'],
                      msg: message['message'],
                    ));
                  }
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    children: messageList,
                  ),
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
                      await firestore.collection('gameroom').add({
                        "sender": currentUser!.email,
                        "message": msgCtrl.text,
                        "timestamp": FieldValue.serverTimestamp()
                      });

                      msgCtrl.clear();
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

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {super.key, required this.msg, required this.sender, required this.isMe});

  final String sender;
  final String msg;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(sender),
              Container(
                decoration: BoxDecoration(
                  color: isMe ? Colors.green : Colors.blue,
                  borderRadius: BorderRadius.only(
                      topLeft: isMe
                          ? const Radius.circular(15)
                          : const Radius.circular(0),
                      topRight: isMe
                          ? const Radius.circular(0)
                          : const Radius.circular(15),
                      bottomLeft: const Radius.circular(15),
                      bottomRight: const Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Text(msg),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
