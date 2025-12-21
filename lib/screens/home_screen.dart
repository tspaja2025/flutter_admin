import "package:shadcn_flutter/shadcn_flutter.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> projects = const [
    {
      "title": "API Keys",
      "icon": LucideIcons.key,
      "description": "Manage and store your API credentials securely.",
    },
    {
      "title": "Calendar",
      "icon": LucideIcons.calendar,
      "description": "Schedule and manage important events.",
    },
    {
      "title": "Chat",
      "icon": LucideIcons.messageCircleReply,
      "description": "Real-time messaging and conversations.",
    },
    {
      "title": "File Manager",
      "icon": LucideIcons.folderOpen,
      "description": "Browse and organize your files.",
    },
    {
      "title": "Invoice",
      "icon": LucideIcons.receipt,
      "description": "Create and track invoices easily.",
    },
    {
      "title": "Kanban Board",
      "icon": LucideIcons.kanban,
      "description": "Organize tasks with kanban workflows.",
    },
    {
      "title": "Mail",
      "icon": LucideIcons.mail,
      "description": "Manage email communication.",
    },
    {
      "title": "Notes",
      "icon": LucideIcons.stickyNote,
      "description": "Create and keep all your notes.",
    },
    {
      "title": "QR Generator",
      "icon": LucideIcons.qrCode,
      "description": "Generate custom QR codes.",
    },
    {
      "title": "To-Do",
      "icon": LucideIcons.listTodo,
      "description": "Track tasks and mark progress.",
    },
    {
      "title": "Calculator",
      "icon": LucideIcons.calculator,
      "description": "Calculate expressions.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const Text("Welcome Back!").x2Large().bold(),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Determine number of columns based on width
                  final width = constraints.maxWidth;
                  final crossAxisCount = width > 1000
                      ? 4
                      : width > 480
                      ? 2
                      : 1;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];

                      return Card(
                        padding: const .all(16),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Card(
                              borderRadius: .circular(50),
                              child: Icon(project["icon"], size: 28),
                            ),
                            const SizedBox(height: 16),
                            Text(project["title"]).small().semiBold(),
                            const SizedBox(height: 6),
                            Text(project["description"]).muted().small(),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
