import 'package:flutter_admin/screens/default_screen.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  runApp(const ProjectsApp());
}

class ProjectsApp extends StatefulWidget {
  const ProjectsApp({super.key});

  @override
  State<ProjectsApp> createState() => ProjectsAppState();
}

class ProjectsAppState extends State<ProjectsApp> {
  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
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
      home: const DefaultScreen(),
    );
  }
}
