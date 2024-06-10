// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String msg;
  final String sender;

  Color? _bgColor;
  Color? _circleColor;

  ChatMessage({super.key, required this.msg, required this.sender});

  @override
  Widget build(BuildContext context) {
    if (sender == "Gemini") {
      _bgColor = Colors.brown.shade200;
      _circleColor = Colors.lightBlue.shade200;
    } else {
      _bgColor = Colors.lightBlue.shade200;
      _circleColor = Colors.blue.shade600;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: _circleColor,
                child: Text(sender[0], style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black
                ),),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sender,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Expanded(
                        child: Text(
                          msg,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
