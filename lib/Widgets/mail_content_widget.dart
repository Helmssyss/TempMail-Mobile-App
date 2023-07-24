import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InboxContent extends StatefulWidget {
  const InboxContent({super.key});

  @override
  State<InboxContent> createState() => _InboxContentState();
}

class _InboxContentState extends State<InboxContent> {
  late final _getContent =
      ModalRoute.of(context)!.settings.arguments as List<String>;
  late WebViewController controller;

  Future<void> htmlPage() async {
    final url = Uri.dataFromString(_getContent[1],
            mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
        .toString();
    controller.loadUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.amberAccent, size: 28),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: Text(
          _getContent[0],
          style: const TextStyle(fontSize: 18, color: Colors.amberAccent),
        ),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          this.controller = controller;
          htmlPage();
        },
      ),
    );
  }
}
