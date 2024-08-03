import 'package:flutter/material.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: DropdownButton<ThemeMode>(
        // Read the selected themeMode from the controller
        value: controller.themeMode,
        // Call the updateThemeMode method any time the user selects a theme.
        onChanged: controller.updateThemeMode,
        items: const [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text('System Theme'),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text('Light Theme'),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text('Dark Theme'),
          )
        ],
      ),
      );
  }
}


class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({Key? key, required this.controller}) : super(key: key);

  final SettingsController controller;

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.controller.themeMode == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isDarkMode,
      onChanged: (bool value) {
        setState(() {
          isDarkMode = value;
          widget.controller
              .updateThemeMode(value ? ThemeMode.dark : ThemeMode.light);
        });
      },
      thumbIcon: MaterialStateProperty.resolveWith<Icon>(
        (Set<MaterialState> states) {
          if (isDarkMode) {
            return const Icon(Icons.dark_mode);
          } else {
            return const Icon(Icons.light_mode);
          }
        },
      ),
    );
  }
}
