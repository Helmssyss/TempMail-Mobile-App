import 'package:flutter/material.dart';
import 'package:temp_mail_app/Widgets/inbox_content_widget.dart';
import 'package:temp_mail_app/src/constants.dart';
import 'package:temp_mail_app/src/page_routes.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => PageRouters.GoRouters(settings: settings),
    );
  }
}

class Home extends StatelessWidget {
  final String urlImage =
      "https://avatars.githubusercontent.com/u/84701901?s=400&u=159a0e92650378c13f9319b0568e73a206ad4ec0&v=4";
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Geçici Mail Oluştur"),
          backgroundColor: Colors.indigoAccent,
          elevation: 5,
          actions: [
            IconButton(
                onPressed: () {},
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(urlImage),
                  radius: 30,
                ))
          ],
        ),
        body: const MailWidget(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigoAccent,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: const Text("Nasıl Çalışıyor?",
                    style: TextStyle(color: Colors.white)),
                content: const Text(
                  how_to_work,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 18),
                ),
                elevation: 3,
                actions: [
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      child: const Text(
                        "Tamam",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ))
                ],
                backgroundColor: Colors.indigo),
          ),
          child: const Icon(
            Icons.question_mark_rounded,
            color: Colors.amberAccent,
            size: 40,
          ),
        ));
  }
}
