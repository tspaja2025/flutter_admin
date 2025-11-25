import 'package:shadcn_flutter/shadcn_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> projects = const [
    {
      "title": "API Keys",
      "icon": Icons.vpn_key,
      "description": "Manage and store your API credentials securely.",
    },
    {
      "title": "Calendar",
      "icon": Icons.calendar_today,
      "description": "Schedule and manage important events.",
    },
    {
      "title": "Chat",
      "icon": Icons.chat_bubble_outline,
      "description": "Real-time messaging and conversations.",
    },
    {
      "title": "File Manager",
      "icon": Icons.folder_open,
      "description": "Browse and organize your files.",
    },
    {
      "title": "Invoice",
      "icon": Icons.receipt_long,
      "description": "Create and track invoices easily.",
    },
    {
      "title": "Kanban Board",
      "icon": Icons.view_kanban,
      "description": "Organize tasks with kanban workflows.",
    },
    {
      "title": "Mail",
      "icon": Icons.email_outlined,
      "description": "Manage email communication.",
    },
    {
      "title": "Notes",
      "icon": Icons.note_alt_outlined,
      "description": "Create and keep all your notes.",
    },
    {
      "title": "QR Generator",
      "icon": Icons.qr_code_2,
      "description": "Generate custom QR codes.",
    },
    {
      "title": "Social Media",
      "icon": Icons.people_alt,
      "description": "Interact and share with your network.",
    },
    {
      "title": "To-Do",
      "icon": Icons.check_circle_outline,
      "description": "Track tasks and mark progress.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .all(16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text("Welcome Back!").x2Large().bold(),
          SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Determine number of columns based on width
                final width = constraints.maxWidth;
                final crossAxisCount = width > 1000
                    ? 4
                    : width > 700
                    ? 3
                    : 2;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
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
    );
  }
}
