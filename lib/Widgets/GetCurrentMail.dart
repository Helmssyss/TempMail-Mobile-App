// ignore: file_names
import 'package:flutter/material.dart';
import 'package:temp_mail_app/Widgets/Inbox.dart';
import 'package:temp_mail_app/util/tempmail.dart';

class GetCurrentMailWidget extends StatefulWidget {
  const GetCurrentMailWidget({super.key});

  @override
  State<GetCurrentMailWidget> createState() => _GetCurrentMailWidgetState();
}

class _GetCurrentMailWidgetState extends State<GetCurrentMailWidget> {
  late final TempMail _tempMail;
  List<dynamic> _getMailContent = [];
  List<Widget> _InboxWidgets = [];
  String _mailAddr = '';

  Row _createMailDesign() {
    return Row(
      children: [
        const SizedBox(
          height: 100,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: InkWell(
            onLongPress: () => print("Copy?"),
            child: Text(
              _mailAddr.replaceAll(RegExp(r"%40"), '@'),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        IconButton(
            onPressed: () async {
              await initMail();
            },
            icon: const Icon(
              Icons.add_box,
              size: 31,
              color: Color.fromARGB(255, 45, 29, 71),
            )),
        IconButton(
          onPressed: () async =>
              await _tempMail.inbox(tma: _mailAddr).then((_) => setState(
                    () {
                      // _InboxWidgets.add(
                      //     InboxWidget(mailContent: _getMailContent));
                      _getMailContent = _tempMail.getMailContent;
                    },
                  )),
          icon: const Icon(Icons.refresh_sharp,
              size: 31, color: Color.fromARGB(255, 45, 29, 71)),
        )
      ],
    );
  }

  Future<void> initMail() async {
    await _tempMail.getCookies().then((String value) async {
      await _tempMail.inbox(tma: value);
      _mailAddr = value;
    });
    setState(() {
      _getMailContent = _tempMail.getMailContent;
    });
  }

  @override
  void initState() {
    super.initState();
    _tempMail = TempMail();
    initMail().then(
        (_) => _InboxWidgets.add(InboxWidget(mailContent: _getMailContent)));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        _createMailDesign(),
        InboxWidget(mailContent: _getMailContent)
      ],
    ));
  }
}
