import 'package:beda_invest/presentation/pages/drawers/switch_languages.dart';
import 'package:beda_invest/domain/controllers/settings_controller.dart';
import 'package:beda_invest/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  final SettingsController settingsController;

  const SplashPage({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Simulating some loading time
    Future.delayed(Duration(seconds: 2), () async {
      // Navigate to the HomePage when loading is finished
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? firstTime = prefs.getBool('first_time');

      if (firstTime != null && !firstTime) {
        // Not first time
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        // First time
        prefs.setBool('first_time', false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SwitchLanguages(
              settingsController: widget.settingsController,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/splash_image.png',
            fit: BoxFit.cover,
          ),

          // Content: Loader with logo
          Positioned.fill(
            bottom: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Replace this with your custom logo widget
                SizedBox(height: 20),
                LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black,
                  size: 80,
                ), // Show loader
              ],
            ),
          ),
        ],
      ),
    );
  }
}
