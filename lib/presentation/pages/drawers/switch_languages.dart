import 'package:beda_invest/domain/controllers/settings_controller.dart';
import 'package:beda_invest/presentation/pages/home/home_page.dart';
import 'package:beda_invest/presentation/pages/nav_page/nav_page.dart';
import 'package:flutter/material.dart';
import 'package:beda_invest/src/app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchLanguages extends StatelessWidget {
  final SettingsController settingsController;

  SwitchLanguages({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(
          currentPage: 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.selectLanguage)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: TextButton(
                style: TextButton.styleFrom(), // Change the button text color
                child: const Text(
                  "🇺🇸 English",
                  style: TextStyle(fontSize: 18.0),
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('lan', 'en');
                  MyApp.of(context)
                      .setLocale(Locale.fromSubtags(languageCode: 'en'));
                  _navigateToHome(context);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: TextButton(
                style: TextButton.styleFrom(), // Change the button text color
                child: const Text(
                  "🇷🇺 Русский",
                  style: TextStyle(fontSize: 18.0),
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('lan', 'ru');
                  MyApp.of(context)
                      .setLocale(Locale.fromSubtags(languageCode: 'ru'));
                  _navigateToHome(context);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: TextButton(
                style: TextButton.styleFrom(), // Change the button text color
                child: const Text(
                  "🇺🇿 O'zbekcha",
                  style: TextStyle(fontSize: 18.0),
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('lan', 'uz');
                  MyApp.of(context)
                      .setLocale(Locale.fromSubtags(languageCode: 'uz'));
                  _navigateToHome(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
