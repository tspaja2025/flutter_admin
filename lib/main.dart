import 'package:flutter_admin/screens/default_screen.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorSchemes.lightDefaultColor,
        radius: 0.5,
        scaling: 1.2,
        surfaceOpacity: 0.8,
        surfaceBlur: 10,
        typography: Typography.geist(
          sans: TextStyle(fontFamily: "Inter"),
          mono: TextStyle(fontFamily: "FiraCode"),
        ),
      ),
      darkTheme: ThemeData.dark(
        colorScheme: ColorSchemes.darkDefaultColor,
        radius: 0.5,
        scaling: 1.2,
        surfaceOpacity: 0.8,
        surfaceBlur: 10,
        typography: Typography.geist(
          sans: TextStyle(fontFamily: "Inter"),
          mono: TextStyle(fontFamily: "FiraCode"),
        ),
      ),
      title: "Flutter Admin",
      home: DefaultScreen(onThemeChanged: _changeTheme),
    );
  }
}
