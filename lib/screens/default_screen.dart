import 'package:flutter_admin/screens/api_keys_screen.dart';
import 'package:flutter_admin/screens/calendar_screen.dart';
import 'package:flutter_admin/screens/chat_screen.dart';
import 'package:flutter_admin/screens/file_manager_screen.dart';
import 'package:flutter_admin/screens/home_screen.dart';
import 'package:flutter_admin/screens/invoice_manager_screen.dart';
import 'package:flutter_admin/screens/kanban_board_screen.dart';
import 'package:flutter_admin/screens/mail_screen.dart';
import 'package:flutter_admin/screens/notes_screen.dart';
import 'package:flutter_admin/screens/qr_generator_screen.dart';
import 'package:flutter_admin/screens/todo_screen.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

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
                  backgroundColor: Theme.of(context).colorScheme.card,
                  labelType: .expanded,
                  labelPosition: .end,
                  expanded: expanded,
                  index: selected,
                  onSelected: (int value) {
                    setState(() {
                      selected = value;
                    });
                  },
                  children: [
                    NavigationButton(
                      alignment: .centerLeft,
                      onPressed: () {
                        setState(() {
                          expanded = !expanded;
                        });
                      },
                      child: const Icon(LucideIcons.menu),
                    ),
                    const NavigationDivider(),
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
                    _buildNavigationButton(
                      "Social Manager",
                      LucideIcons.messageCircle,
                    ),
                    _buildNavigationButton("To Do", LucideIcons.listTodo),
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

  NavigationItem _buildNavigationButton(String text, IconData icon) {
    return NavigationItem(
      label: Text(text),
      alignment: .centerLeft,
      selectedStyle: const ButtonStyle.primaryIcon(),
      child: Tooltip(
        alignment: .centerRight,
        tooltip: (_) => TooltipContainer(child: Text(text)),
        child: Icon(icon),
      ),
    );
  }
}
