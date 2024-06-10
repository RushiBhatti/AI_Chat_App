import "dart:convert";

import "package:ai_chat_app/Globals/globals.dart";
import 'package:ai_chat_app/utils/chat_message.dart';
import "package:http/http.dart" as http;
import "package:flutter/material.dart";

class MyChatScreen extends StatefulWidget {
  const MyChatScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyChatScreenState();
  }
}

class _MyChatScreenState extends State<MyChatScreen> {

  String geminiReply = "";
  String userMSG = "";
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  final String _ourUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${Globals.MyAPIKey}";
  final _header = {'Content-Type': 'application/json'};


  // sending msg to gemini and also handling response
  void _sendMessage() async {
    setState(() {
      _messages.insert(0, ChatMessage(msg: _controller.text, sender: "user"));
      userMSG = _controller.text.toString();
      _messages.insert(
          0, ChatMessage(msg: "Gemini is typing...", sender: "Gemini"));
    });

    _controller.clear();
    var data = {
      "contents": [
        {
          "parts": [
            {"text": userMSG}
          ]
        }
      ]
    };

    await http
        .post(Uri.parse(_ourUrl), headers: _header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);

        geminiReply = result['candidates'][0]['content']['parts'][0]['text'];

        _messages.removeAt(0);

        setState(() {
          _messages.insert(0, ChatMessage(msg: geminiReply, sender: "Gemini"));
        });
      } else {
        geminiReply = "Sorry, Some Error Occur!";
        setState(() {
          _messages.removeAt(0);
          _messages.insert(0, ChatMessage(msg: geminiReply, sender: "Gemini"));
        });
      }
    }).catchError((e) {});
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: TextField(
              onSubmitted: (value) => _sendMessage(),
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter a message...",
                contentPadding: const EdgeInsets.all(8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          IconButton(
            onPressed: () => _sendMessage(),
              icon: const Icon(Icons.send_rounded)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Chat with AI",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _messages[index];
                    }
                    )
            ),

            const Divider(thickness: 1, color: Colors.black26),

            Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                height: 60,
                child: _buildTextComposer(),
              ),
            ),

            const SizedBox(height: 12,),

          ],
        ),
      ),
    );
  }
}
