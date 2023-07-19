import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class TempMail {
  static String getPHPSESSID = '';
  static String mail = '';
  static final Map<String, String> _headers = {
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

  static Future<void> getCookies() async {
    await _getPHPSESSID();
    await _createAccount();
  }

  static Future<void> _getPHPSESSID() async {
    const String url = "https://www.fakemail.net/";
    var response = await http.get(Uri.parse(url));

    Map<String, String> phpsessid = response.headers;
    String value = phpsessid.entries.first.value;
    for (int i = 0; i < value.length; i++) {
      if (value[i] == ';')
        break;
      else
        getPHPSESSID += value[i];
    }
    getPHPSESSID = getPHPSESSID.split('=')[1];
    print(getPHPSESSID);
  }

  static Future<void> _createAccount() async {
    const String url = "https://www.fakemail.net/index/index";
    var response = await http.get(Uri.parse(url), headers: _headers);
    String? tma = response.headers["set-cookie"];
    if (tma != null) {
      for (var i = 0; i < tma.length; i++) {
        if (tma[i] == ';')
          break;
        else
          mail += tma[i];
      }
    }
    mail = mail.split('=')[1];
    mail = mail.replaceAll(RegExp(r"%40"), '@');
    print(mail.replaceAll(RegExp(r"%40"), '@'));
  }

  static Future<void> inbox() async {
    _headers.addEntries(
        {"Cookie": "PHPSESSID=$getPHPSESSID; TMA=$mail; wpcc=dismiss"}.entries);

    var response = await http.get(
        Uri.parse("https://www.fakemail.net/email/id/1"),
        headers: _headers);
    // print(response.body);

    response = await http.get(
        Uri.parse("https://www.fakemail.net/index/refresh"),
        headers: _headers);

    print(response.body);
  }
}

// Future<void> main(List<String> args) async {
//   await TempMail.getCookies();
//   await TempMail.inbox();
// }
