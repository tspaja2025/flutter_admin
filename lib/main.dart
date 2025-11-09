import 'package:flutter_admin/screens/default_screen.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorSchemes.lightGreen,
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
        colorScheme: ColorSchemes.darkGreen,
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
      home: DefaultScreen(),
    );
  }
}
