import 'package:beda_invest/presentation/pages/home/home_page.dart';
import 'package:beda_invest/presentation/pages/nav_page/nav_page.dart';
import 'package:beda_invest/src/model_theme.dart';

import 'package:beda_invest/presentation/pages/splash/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/controllers/settings_controller.dart';
import '../presentation/pages/settings/settings_view.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', '');

  @override
  void initState() {
    _setLocale();
    super.initState();
  }

  void _setLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lan = prefs.getString('lan');
    Locale locale = Locale(lan ?? 'en', '');
    setState(() {
      _locale = locale;
    });
  }

  void setLocale(Locale value) async {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ModelTheme(),
        child: Consumer<ModelTheme>(
            builder: (context, ModelTheme themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: _locale,
            home: SplashPage(settingsController: widget.settingsController),
            restorationScopeId: 'app',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('uz', 'UZ'),
              Locale('ru', 'RU'),
            ],
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: themeNotifier.isDark
                ? ThemeData(
                    brightness: Brightness.dark,
                    textTheme: const TextTheme(
                      bodyMedium:
                          TextStyle(fontSize: 16.0, color: Colors.white),
                    ))
                : ThemeData(
                    brightness: Brightness.light,
                    primaryColor: CupertinoColors.white,
                    primarySwatch: Colors.blue,
                    // iconTheme: IconThemeData(color: Colors.white)
                    textTheme: const TextTheme(
                      bodyMedium: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black), // Text color for light mode
                    ),
                  ),
            darkTheme: ThemeData.dark(),
            themeMode: widget.settingsController.themeMode,
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case SettingsView.routeName:
                      return SettingsView(
                          controller: widget.settingsController);
                    default:
                      return const DashboardPage(
                        currentPage: 0,
                      );
                  }
                },
              );
            },
          );
        }));
  }
}
