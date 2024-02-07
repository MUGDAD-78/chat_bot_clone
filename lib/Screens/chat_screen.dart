// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:chat_gpt_clone/Provider/change_theme.dart';
import 'package:chat_gpt_clone/constant/api_key.dart';
import 'package:chat_gpt_clone/constant/primary_color.dart';
import 'package:chat_gpt_clone/constant/text_filed_decoration.dart';
import 'package:chat_gpt_clone/constant/themes.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final openAI = OpenAI.instance.build(
      token: apiKey,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 10),
      ),
      enableLog: true);
// This is the current user
  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'Mugdad', lastName: 'Elneama');
// This is the user who will receive the meassage (Chat GPT API)
  final ChatUser _otherUser =
      ChatUser(id: '2', firstName: 'Chat', lastName: 'Bot');
  //List that the messages will be in.
  List<ChatMessage> chatMessagesList = <ChatMessage>[];
  // To show in the chat that user is typing
  List<ChatUser> typingUsers = [];
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Map<String, dynamic> userData = {};
  bool isLoading = false;

  /* This Function to get Data From Firebsae */ getDataFromDB() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('UserInformation')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = snapshot.data()!;
      setState(() {
        isLoading = true;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  /* To Update the connectivitiy status */ Future<void> _updateConnectionStatus(
      ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  /* create method to check if there is internet or not*/ Future<void>
      initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    getDataFromDB();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  /* To send a message to chat GPT AI  */ Future<void> sendChatMessages(
      ChatMessage m) async {
    setState(() {
      chatMessagesList.insert(0, m);
      typingUsers.add(_otherUser);
    });
    List<Messages> messagesHistory = chatMessagesList.reversed.map((e) {
      if (e.user == _currentUser) {
        return Messages(role: Role.user, content: e.text);
      } else {
        return Messages(role: Role.assistant, content: e.text);
      }
    }).toList();

    final request = ChatCompleteText(
      model: GptTurboChatModel(),
      messages: messagesHistory,
      maxToken: 200,
    );

    final response = await openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          chatMessagesList.insert(
              0,
              ChatMessage(
                user: _otherUser,
                createdAt: DateTime.now(),
                text: element.message!.content,
              ));
        });
      }
    }
    setState(() {
      typingUsers.remove(_otherUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    final changeThemeObject = Provider.of<ChangeTheme>(context, listen: false);
    return Scaffold(
      drawer: isLoading
          ? Drawer(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: primaryColor),
                    accountName: Text(userData['UserName'],
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'font2')),
                    accountEmail: Text(
                      userData['Email'],
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'font2'),
                    ),
                  ),
                  ListTile(
                      title: Text(
                        "Logout",
                        style: TextStyle(fontFamily: 'font2'),
                      ),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                      }),
                  SizedBox(
                    height: 500,
                  ),
                  Text("Developed by Mugdad Elneama © 2024",
                      style: TextStyle(fontSize: 13, fontFamily: 'font2')),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                changeThemeObject.changeTheme();
              },
              icon: Icon(Icons.sunny,
                  color: changeThemeObject.themeData == lightTheme
                      ? Colors.black
                      : Colors.white))
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Chat Me",
              style: TextStyle(fontFamily: 'font2'),
            ),
            Image.asset(
              'assets/img/splash_screen_icon.png',
              height: 100,
            ),
          ],
        ),
        backgroundColor: primaryColor,
      ),
      body: _connectionStatus.name == 'none'
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Image.asset(
                        'assets/img/no_internet-removebg-preview.png')),
                Text(
                  "No Internet available",
                  style: TextStyle(fontFamily: 'font3', fontSize: 20),
                ),
              ],
            )
          : DashChat(
              currentUser: _currentUser,
              onSend: (ChatMessage message) {
                sendChatMessages(message);
              },
              messages: chatMessagesList,
              typingUsers: typingUsers,
              messageOptions: MessageOptions(
                  spaceWhenAvatarIsHidden: 10,
                  textColor: Colors.black,
                  currentUserContainerColor: Colors.blueGrey,
                  containerColor: primaryColor,
                  currentUserTextColor: Colors.white),
              inputOptions: chatTextFiledDecoration),
    );
  }
}
