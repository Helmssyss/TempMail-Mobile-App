import 'package:flutter/material.dart';
import 'package:temp_mail_app/Widgets/GetCurrentMail.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.red),
        home: Scaffold(
          backgroundColor: Colors.deepPurple,
          appBar: AppBar(
            elevation: 20,
            backgroundColor: Colors.purpleAccent,
            leading: const Icon(
              Icons.mail,
              size: 30,
            ),
            centerTitle: true,
            title: const Text("Geçici Mail"),
          ),
          body: Padding(
            padding:
                const EdgeInsets.only(left: 15, top: 10, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Mail Oluştur",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                // SizedBox(height: 50),
                GetCurrentMailWidget(),
              ],
            ),
          ),
        ));
  }
}
