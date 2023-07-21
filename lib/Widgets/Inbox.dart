import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:temp_mail_app/util/tempmail.dart';

class InboxWidget extends StatefulWidget {
  List<dynamic> mailContent = [];
  InboxWidget({Key? key, required this.mailContent}) : super(key: key);

  @override
  State<InboxWidget> createState() => _InboxWidgetState();
}

class _InboxWidgetState extends State<InboxWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.mailContent.isNotEmpty) {
      print(widget.mailContent.length);
      return Expanded(
        child: ListView.builder(
          itemCount: widget.mailContent.length,
          itemBuilder: (context, index) => InkWell(
            child: ListTile(
              leading: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.mail),
              ),
              trailing: IconButton(
                  onPressed: () => print("object"),
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 28,
                  )),
              title: Text(
                widget.mailContent[0]["od"],
                style: const TextStyle(
                    color: Colors.amber, fontStyle: FontStyle.italic),
              ),
              subtitle: Text(widget.mailContent[0]["predmetZkraceny"],
                  style: const TextStyle(
                    color: Colors.amber,
                  )),
            ),
            onTap: () => print("object"),
          ),
        ),
      );
    } else {
      return const CircularProgressIndicator(
        color: Colors.amber,
      );
    }
  }
}
