import "package:ai_chat_app/screens/chat_screen.dart";
import "package:flutter/material.dart";

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ai Chat App by RB",

      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),

      home: const MyChatScreen(),
    );
  }
}