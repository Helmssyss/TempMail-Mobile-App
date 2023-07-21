import 'dart:convert';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class TempMail {
  String getPHPSESSID = '';
  List<dynamic> getMailContent = [];
  // ignore: prefer_final_fields
  Map<String, String> _headers = {
    "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.5112.81 Safari/537.36",
    "X-Requested-With": "XMLHttpRequest",
    "Accept": "application/json, text/javascript, */*; q=0.01",
    "Accept-Encoding": "gzip, deflate, br",
    "Accept-Language": "tr-TR,tr;q=0.9,en-US;q=0.8,en;q=0.7",
    "Connection": "keep-alive",
    "Host": "www.fakemail.net",
    "Referer": "https://www.fakemail.net/"
  };
  Future<String> getCookies() async {
    await _getPHPSESSID();
    return await _createAccount();
  }

  Future<void> _getPHPSESSID() async {
    _headers.remove("Cookie");
    const String url = "https://www.fakemail.net/";
    var response = await http.get(Uri.parse(url));

    Map<String, String> phpsessid = response.headers;
    String value = phpsessid.entries.first.value;
    for (int i = 0; i < value.length; i++) {
      if (value[i] == ';') {
        break;
      } else {
        getPHPSESSID += value[i];
      }
    }
    getPHPSESSID = getPHPSESSID.split('=')[1];
    print(getPHPSESSID);
  }

  Future<String> _createAccount() async {
    String _getMail = '';
    const String url = "https://www.fakemail.net/index/index";
    var response = await http.get(Uri.parse(url), headers: _headers);
    String? tma = response.headers["set-cookie"];
    if (tma != null) {
      for (var i = 0; i < tma.split(' ')[0].length; i++) {
        if (tma[i] == ';') {
          break;
        } else {
          _getMail += tma[i];
        }
      }
      // print(_getMail);

      List<String> _mail = _getMail.split('=');
      String mail = _mail[1];
      // mail = _mail[1];
      // mail = mail.replaceAll(RegExp(r"%40"), '@');

      print(mail.replaceAll(RegExp(r"%40"), '@'));
      return mail;
    }
    return '';
  }

  // ignore: non_constant_identifier_names
  Future<String> mailContent() async {
    var response = await http.get(
        Uri.parse("https://www.fakemail.net/email/id/1"),
        headers: _headers);
    return response.body;
  }

  Future<void> inbox({required String tma}) async {
    final _Cookie = <String, String>{
      "Cookie": "PHPSESSID=$getPHPSESSID; TMA=$tma; wpcc=dismiss"
    };
    _headers.addEntries(_Cookie.entries);
    var response = await http.get(
        Uri.parse("https://www.fakemail.net/index/refresh"),
        headers: _headers);
    print(response.body);
    getMailContent = json.decode(response.body);
  }
}

// Future<void> main(List<String> args) async {
//   TempMail tempMail = TempMail();
//   int count = 0;
//   while (count < 3) {
//     await tempMail
//         .getCookies()
//         .then((String value) async => await tempMail.inbox(tma: value));
//     await tempMail.mailContent();
//     count++;
//   }
// }
