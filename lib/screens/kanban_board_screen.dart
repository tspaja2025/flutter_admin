import "package:shadcn_flutter/shadcn_flutter.dart";

// Implement rest

class KanbanBoardScreen extends StatefulWidget {
  const KanbanBoardScreen({super.key});

  @override
  State<KanbanBoardScreen> createState() => KanbanBoardScreenState();
}

class KanbanBoardScreenState extends State<KanbanBoardScreen> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Padding(
        padding: const .all(16),
        child: Column(
          children: [
            Row(
              spacing: 8,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    placeholder: const Text("Search tasks..."),
                    features: [
                      InputFeature.leading(
                        StatedWidget.builder(
                          builder: (context, states) {
                            return const Icon(LucideIcons.search);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Select<String>(
                  itemBuilder: (context, item) {
                    return Text(item);
                  },
                  popupConstraints: const BoxConstraints(
                    maxHeight: 300,
                    maxWidth: 200,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
                  value: _selectedValue,
                  placeholder: const Text("Sort by"),
                  popup: SelectPopup(
                    items: SelectItemList(
                      children: [
                        SelectItemButton(
                          value: "DateCreated",
                          child: const Text("Date Created"),
                        ),
                        SelectItemButton(
                          value: "Priority",
                          child: const Text("Priority"),
                        ),
                      ],
                    ),
                  ).call,
                ),
                PrimaryButton(
                  onPressed: () {},
                  density: .dense,
                  leading: const Icon(LucideIcons.plus),
                  child: const Text("Add Column"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Flex(
              direction: .horizontal,
              crossAxisAlignment: .start,
              spacing: 8,
              children: [
                KanbanColumn(
                  columnTitle: "In Progress",
                  todoCount: "2",
                  children: [
                    KanbanColumnItem(
                      title: "Design System Setup",
                      content:
                          "Create a comprehensive design system with colors, typography, and components",
                      priority: "High",
                      priorityColor: Colors.red,
                    ),
                    const SizedBox(height: 8),
                    KanbanColumnItem(
                      title: "API Integration",
                      content: "Integrate with backend APIs for data fetching",
                      priority: "Medium",
                      priorityColor: Colors.orange,
                    ),
                  ],
                ),
                KanbanColumn(
                  columnTitle: "Review",
                  todoCount: "2",
                  children: [
                    KanbanColumnItem(
                      title: "User Authentication",
                      content: "Implement login and signup functionality",
                      priority: "High",
                      priorityColor: Colors.red,
                    ),
                  ],
                ),
                KanbanColumn(
                  columnTitle: "Done",
                  todoCount: "2",
                  children: [
                    KanbanColumnItem(
                      title: "Mobile Responsiveness",
                      content:
                          "Ensure the app works perfectly on mobile devices",
                      priority: "Medium",
                      priorityColor: Colors.orange,
                    ),
                  ],
                ),
                KanbanColumn(
                  columnTitle: "Todo",
                  todoCount: "2",
                  children: [
                    KanbanColumnItem(
                      title: "Project Setup",
                      content:
                          "Initialize Next.js project with TypeScript and Tailwind",
                      priority: "Low",
                      priorityColor: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class KanbanColumn extends StatefulWidget {
  final String columnTitle;
  final String todoCount;
  final List<Widget> children;

  const KanbanColumn({
    super.key,
    required this.columnTitle,
    required this.todoCount,
    required this.children,
  });

  @override
  State<KanbanColumn> createState() => KanbanColumnState();
}

class KanbanColumnState extends State<KanbanColumn> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    Text(widget.columnTitle),
                    Chip(child: Text(widget.todoCount)),
                  ],
                ),
                Builder(
                  builder: (context) {
                    return IconButton.ghost(
                      onPressed: () {
                        showDropdown(
                          context: context,
                          builder: (context) {
                            return DropdownMenu(
                              children: [
                                MenuButton(
                                  onPressed: (_) {},
                                  leading: const Icon(LucideIcons.plus),
                                  child: const Text("Add Item"),
                                ),
                                MenuButton(
                                  onPressed: (_) {},
                                  leading: const Icon(LucideIcons.trash2),
                                  child: const Text("Delete Column"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      density: .iconDense,
                      icon: const Icon(LucideIcons.ellipsisVertical),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...widget.children,
          ],
        ),
      ),
    );
  }
}

class KanbanColumnItem extends StatefulWidget {
  final String title;
  final String content;
  final String priority;
  final Color priorityColor;

  const KanbanColumnItem({
    super.key,
    required this.title,
    required this.content,
    required this.priority,
    required this.priorityColor,
  });

  @override
  State<KanbanColumnItem> createState() => KanbanColumnItemState();
}

class KanbanColumnItemState extends State<KanbanColumnItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(widget.title),
              Builder(
                builder: (context) {
                  return IconButton.ghost(
                    onPressed: () {
                      showDropdown(
                        context: context,
                        builder: (context) {
                          return DropdownMenu(
                            children: [
                              MenuButton(
                                onPressed: (_) {},
                                leading: const Icon(LucideIcons.pencil),
                                child: const Text("Edit"),
                              ),
                              MenuButton(
                                onPressed: (_) {},
                                leading: const Icon(LucideIcons.trash2),
                                child: const Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    density: .iconDense,
                    icon: const Icon(LucideIcons.ellipsisVertical),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(widget.content),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              const Text("4/12/2025").muted().small(),
              Container(
                padding: const .symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.priorityColor,
                  borderRadius: .circular(8),
                ),
                child: Text(widget.priority).small(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------
// Models
// -----------------------------
class KanbanTask {
  final String id;
  String title;
  String content;
  String date; // ISO or formatted string
  String priority;
  Color priorityColor;

  KanbanTask({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.priority,
    required this.priorityColor,
  });

  KanbanTask copyWith({
    String? id,
    String? title,
    String? content,
    String? date,
    String? priority,
    Color? priorityColor,
  }) {
    return KanbanTask(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      priorityColor: priorityColor ?? this.priorityColor,
    );
  }
}

class KanbanColumnData {
  final String id;
  String title;
  List<KanbanTask> tasks;

  KanbanColumnData({
    required this.id,
    required this.title,
    required this.tasks,
  });
}
