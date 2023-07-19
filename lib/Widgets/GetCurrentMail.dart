// ignore: file_names
import 'package:flutter/material.dart';
import 'package:temp_mail_app/util/tempmail.dart';

class InputWidget extends StatefulWidget {
  const InputWidget({super.key});

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  String _mail = "";

  Future<void> MailStart() async {
    await TempMail.getCookies();
    setState(() {
      _mail = TempMail.mail;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Row(
      children: <Widget>[
        const SizedBox(height: 50),
        Text(_mail,
            style: const TextStyle(fontSize: 20, color: Colors.amberAccent)),
        IconButton(
            onPressed: () async => await MailStart(),
            icon: const Icon(
              Icons.add_circle_outline,
              size: 35,
              color: Colors.purpleAccent,
            ))
      ],
    );
  }
}
