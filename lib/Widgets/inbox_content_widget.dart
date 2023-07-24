// ignore: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:temp_mail_app/src/tempmail.dart';
import 'package:flutter/services.dart';

class MailWidget extends StatefulWidget {
  const MailWidget({super.key});

  @override
  State<MailWidget> createState() => _MailWidgetState();
}

class _MailWidgetState extends State<MailWidget> {
  late Timer _inboxTimer;
  late final TempMail _tempMail;
  final SizedBox constSizeBox = const SizedBox(height: 100);

  List<dynamic> _getMailContent = [];
  final List<bool> _isReadedMails = [];
  String _mailAddr = '';

  void _setMailIcon({required int index}) {
    _tempMail.isReadMails[index] = false;
    print(_tempMail.isReadMails);
  }

  Widget _createMailDesign() {
    if (_mailAddr != '') {
      return Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            constSizeBox,
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: InkWell(
                onLongPress: () async {
                  await Clipboard.setData(ClipboardData(
                          text: _mailAddr.replaceAll(RegExp(r"%40"), '@')))
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kopyalandı!')));
                  });
                },
                child: Text(
                  _mailAddr.replaceAll(RegExp(r"%40"), '@'),
                  style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.w800,
                      fontSize: 20),
                ),
              ),
            ),
            IconButton(
                onPressed: () async {
                  if (_tempMail.isReadMails.isNotEmpty) {
                    _tempMail.isReadMails
                        .removeRange(0, _tempMail.isReadMails.length);
                  }
                  await initMail();
                },
                icon: const Icon(
                  Icons.add_box,
                  size: 30,
                  color: Colors.amber,
                )),
            IconButton(
              onPressed: () async =>
                  await _tempMail.inbox(tma: _mailAddr).then((_) => setState(
                        () {
                          if (_inboxTimer.isActive) {
                            _inboxTimer.cancel();
                            setInboxTimerManager();
                          }
                          _getMailContent = _tempMail.getMailContent;
                        },
                      )),
              icon: const Icon(Icons.refresh_sharp,
                  size: 30, color: Colors.amber),
            ),
          ],
        ),
      );
    } else {
      return constSizeBox;
    }
  }

  Container _createInboxDesign() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      color: Colors.indigo,
      child: Column(
        children: [
          Row(
            children: [_createMailDesign()],
          ),
          Expanded(
              child: _tempMail.isReadMails.isNotEmpty
                  ? ListView.builder(
                      itemCount: _tempMail.isReadMails.length,
                      itemBuilder: (context, index) => InkWell(
                            child: ListTile(
                              title: Text(
                                _getMailContent[index]['od']
                                    .toString()
                                    .split('<')[1]
                                    .replaceAll(RegExp(r">"), ''),
                                style: const TextStyle(
                                    color: Colors.amber,
                                    fontStyle: FontStyle.italic),
                              ),
                              subtitle: Text(
                                _getMailContent[index]['predmet'],
                                style:
                                    const TextStyle(color: Colors.amberAccent),
                              ),
                              leading: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  _tempMail.isReadMails.elementAt(index)
                                      ? Icons.mark_email_unread_rounded
                                      : Icons.mark_email_read_outlined,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                              ),
                              trailing: _tempMail.isReadMails.elementAt(index)
                                  ? const Text("")
                                  : const Text(
                                      "O K U N D U",
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          wordSpacing: 1),
                                    ),
                            ),
                            onTap: () async {
                              print("index = $index");

                              await _tempMail
                                  .mailContent(id: _getMailContent[index]['id'])
                                  .then((value) {
                                Navigator.of(context)
                                    .pushNamed("/mail_content", arguments: [
                                  _getMailContent[index]['od']
                                      .toString()
                                      .split('<')[1]
                                      .replaceAll(RegExp(r">"), ''),
                                  value
                                ]);
                                setState(() => _setMailIcon(index: index));
                                _inboxTimer.cancel();
                                setInboxTimerManager();
                              });
                            },
                          ))
                  : const Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 200),
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      ),
                    )),
        ],
      ),
    );
  }

  void setInboxTimerManager() {
    _inboxTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _tempMail.inbox(tma: _mailAddr).then((_) => setState(
            () {
              _getMailContent = _tempMail.getMailContent;
              print("object");
            },
          ));
    });
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

    initMail().then((_) {
      setInboxTimerManager();
      _isReadedMails.add(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _createInboxDesign();
  }
}
