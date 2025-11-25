import 'package:flutter_admin/screens/api_keys_screen.dart';
import 'package:flutter_admin/screens/calendar_screen.dart';
import 'package:flutter_admin/screens/chat_screen.dart';
import 'package:flutter_admin/screens/file_manager_screen.dart';
import 'package:flutter_admin/screens/home_screen.dart';
import 'package:flutter_admin/screens/invoice_screen.dart';
import 'package:flutter_admin/screens/kanban_board_screen.dart';
import 'package:flutter_admin/screens/mail_screen.dart';
import 'package:flutter_admin/screens/notes_screen.dart';
import 'package:flutter_admin/screens/qr_generator_screen.dart';
import 'package:flutter_admin/screens/social_media_screen.dart';
import 'package:flutter_admin/screens/todo_screen.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class DefaultScreen extends StatefulWidget {
  final void Function(ThemeMode)? onThemeChanged;

  const DefaultScreen({super.key, this.onThemeChanged});

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
    const InvoiceScreen(),
    const KanbanBoardScreen(),
    const MailScreen(),
    const NotesScreen(),
    const QrGeneratorScreen(),
    const SocialMediaScreen(),
    const TodoScreen(),
  ];

  NavigationBarItem buildButton(String label, IconData icon) {
    return NavigationItem(
      label: Text(label),
      alignment: .centerLeft,
      child: Tooltip(
        alignment: .centerRight,
        tooltip: (_) => TooltipContainer(child: Text(label)),
        child: Icon(icon),
      ),
    );
  }

  NavigationLabel buildLabel(String label) {
    return NavigationLabel(
      alignment: .centerLeft,
      child: Text(label).semiBold().muted(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          title: const Text("Flutter Admin"),
          leading: <Widget>[
            NavigationButton(
              alignment: .centerLeft,
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              child: const Icon(LucideIcons.menu),
            ),
          ],
          trailing: <Widget>[
            IconButton.ghost(
              onPressed: () {},
              icon: const Icon(LucideIcons.search),
            ),
            Builder(
              builder: (context) {
                return GhostButton(
                  density: ButtonDensity.icon,
                  child: const Icon(LucideIcons.moon),
                  onPressed: () {
                    showDropdown(
                      context: context,
                      builder: (context) {
                        return DropdownMenu(
                          children: [
                            MenuButton(
                              onPressed: (_) =>
                                  widget.onThemeChanged?.call(ThemeMode.light),
                              child: Text("Light Mode"),
                            ),
                            MenuButton(
                              onPressed: (_) =>
                                  widget.onThemeChanged?.call(ThemeMode.dark),
                              child: Text("Dark Mode"),
                            ),
                            MenuButton(
                              onPressed: (_) =>
                                  widget.onThemeChanged?.call(ThemeMode.system),
                              child: Text("System"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
        const Divider(),
      ],
      child: Row(
        mainAxisAlignment: .start,
        crossAxisAlignment: .start,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: .stretch,
              children: [
                NavigationRail(
                  backgroundColor: Theme.of(context).colorScheme.card,
                  labelType: NavigationLabelType.expanded,
                  labelPosition: NavigationLabelPosition.end,
                  alignment: NavigationRailAlignment.start,
                  expanded: expanded,
                  index: selected,
                  onSelected: (int value) {
                    setState(() {
                      selected = value;
                    });
                  },
                  children: [
                    buildLabel("Apps"),
                    buildButton("Home", LucideIcons.house),
                    buildButton("API Keys", LucideIcons.key),
                    buildButton("Calendar", LucideIcons.calendar),
                    buildButton("Chat", LucideIcons.messageCircle),
                    buildButton("File Manager", LucideIcons.file),
                    buildButton("Invoice", LucideIcons.receipt),
                    buildButton("Kanban Board", LucideIcons.kanban),
                    buildButton("Mail", LucideIcons.mail),
                    buildButton("Notes", LucideIcons.stickyNote),
                    buildButton("Qr Generator", LucideIcons.qrCode),
                    buildButton("Social Media", LucideIcons.messageSquare),
                    buildButton("To-Do", LucideIcons.listTodo),
                  ],
                ),
                const VerticalDivider(),
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
}
