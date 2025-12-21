import "package:flutter_admin/screens/api_keys_screen.dart";
import "package:flutter_admin/screens/calculator_screen.dart";
import "package:flutter_admin/screens/calendar_screen.dart";
import "package:flutter_admin/screens/chat_screen.dart";
import "package:flutter_admin/screens/file_manager_screen.dart";
import "package:flutter_admin/screens/home_screen.dart";
import "package:flutter_admin/screens/invoice_manager_screen.dart";
import "package:flutter_admin/screens/kanban_board_screen.dart";
import "package:flutter_admin/screens/mail_screen.dart";
import "package:flutter_admin/screens/notes_screen.dart";
import "package:flutter_admin/screens/qr_generator_screen.dart";
import "package:flutter_admin/screens/todo_screen.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

class DefaultScreen extends StatefulWidget {
  const DefaultScreen({super.key});

  @override
  State<DefaultScreen> createState() => DefaultScreenState();
}

class DefaultScreenState extends State<DefaultScreen> {
  bool expanded = false;
  int selected = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const ApiKeysScreen(),
    const CalendarScreen(),
    const ChatScreen(),
    const FileManagerScreen(),
    const InvoiceManagerScreen(),
    const KanbanBoardScreen(),
    const MailScreen(),
    const NotesScreen(),
    const QrGeneratorScreen(),
    const ToDoScreen(),
    const CalculatorScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Row(
        mainAxisAlignment: .start,
        crossAxisAlignment: .start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: .stretch,
              children: [
                NavigationRail(
                  alignment: .start,
                  labelType: .none,
                  index: selected,
                  labelPosition: .bottom,
                  expanded: expanded,
                  onSelected: (index) {
                    setState(() {
                      selected = index;
                    });
                  },
                  children: [
                    _buildNavigationButton("Home", LucideIcons.house),
                    _buildNavigationButton("API Keys", LucideIcons.key),
                    _buildNavigationButton("Calendar", LucideIcons.calendar),
                    _buildNavigationButton(
                      "Chat",
                      LucideIcons.messageCircleReply,
                    ),
                    _buildNavigationButton(
                      "File Manager",
                      LucideIcons.folderOpen,
                    ),
                    _buildNavigationButton(
                      "Invoice Manager",
                      LucideIcons.receipt,
                    ),
                    _buildNavigationButton("Kanban Board", LucideIcons.kanban),
                    _buildNavigationButton("Mail", LucideIcons.mail),
                    _buildNavigationButton("Notes", LucideIcons.stickyNote),
                    _buildNavigationButton("QR Generator", LucideIcons.qrCode),
                    _buildNavigationButton("To Do", LucideIcons.listTodo),
                    _buildNavigationButton(
                      "Calculator",
                      LucideIcons.calculator,
                    ),
                  ],
                ),
                Expanded(
                  child: IndexedStack(index: selected, children: screens),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  NavigationItem _buildNavigationButton(String label, IconData icon) {
    return NavigationItem(label: Text(label), child: Icon(icon));
  }
}
