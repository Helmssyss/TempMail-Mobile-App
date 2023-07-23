import 'package:flutter/material.dart';
import 'package:temp_mail_app/Widgets/mail_content_widget.dart';
import 'package:temp_mail_app/Widgets/main.dart';

class PageRouters {
  static Route<dynamic>? GoRouters({required RouteSettings settings}) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const Home(),
        );

      case '/mail_content':
        return MaterialPageRoute(
            settings: settings, builder: (context) => const InboxContent());
      default:
        break;
    }
  }
}
