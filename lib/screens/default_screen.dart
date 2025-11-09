import 'package:flutter_admin/screens/api_keys_screen.dart';
import 'package:flutter_admin/screens/calendar_screen.dart';
import 'package:flutter_admin/screens/chat_screen.dart';
import 'package:flutter_admin/screens/file_manager_screen.dart';
import 'package:flutter_admin/screens/home_screen.dart';
import 'package:flutter_admin/screens/invoice_screen.dart';
import 'package:flutter_admin/screens/kanban_board_screen.dart';
import 'package:flutter_admin/screens/mail_screen.dart';
import 'package:flutter_admin/screens/notes_screen.dart';
import 'package:flutter_admin/screens/social_media_screen.dart';
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
    const InvoiceScreen(),
    const KanbanBoardScreen(),
    const MailScreen(),
    const NotesScreen(),
    const SocialMediaScreen(),
    const TodoScreen(),
  ];

  NavigationBarItem buildButton(String label, IconData icon) {
    return NavigationItem(
      label: Text(label),
      alignment: Alignment.centerLeft,
      child: Tooltip(
        alignment: Alignment.centerRight,
        tooltip: (_) => TooltipContainer(child: Text(label)),
        child: Icon(icon),
      ),
    );
  }

  NavigationLabel buildLabel(String label) {
    return NavigationLabel(
      alignment: Alignment.centerLeft,
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
              alignment: Alignment.centerLeft,
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              child: const Icon(Icons.menu),
            ),
          ],
          trailing: <Widget>[
            GhostButton(
              density: ButtonDensity.icon,
              child: const Icon(Icons.dark_mode),
              onPressed: () {},
            ),
          ],
        ),
        const Divider(),
      ],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    buildButton("Home", Icons.home),
                    buildButton("API Keys", Icons.api),
                    buildButton("Calendar", Icons.calendar_today),
                    buildButton("Chat", Icons.message),
                    buildButton("File Manager", Icons.file_open),
                    buildButton("Invoice", Icons.receipt),
                    buildButton("Kanban Board", Icons.view_kanban),
                    buildButton("Mail", Icons.mail),
                    buildButton("Notes", Icons.note),
                    buildButton("Social Media", Icons.comment),
                    buildButton("To-Do", Icons.sticky_note_2),
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
