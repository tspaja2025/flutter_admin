import 'package:shadcn_flutter/shadcn_flutter.dart';

class KanbanBoardScreen extends StatefulWidget {
  const KanbanBoardScreen({super.key});

  @override
  State<KanbanBoardScreen> createState() => KanbanBoardScreenState();
}

class KanbanBoardScreenState extends State<KanbanBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Flex(
            direction: .horizontal,
            spacing: 8,
            children: [
              OutlineButton(
                onPressed: () {},
                density: .icon,
                leading: const Icon(LucideIcons.plus),
                child: const Text("Add Column"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Example columns
          Flex(
            direction: .horizontal,
            crossAxisAlignment: .start,
            spacing: 16,
            children: [
              KanbanColumn(
                columnTitle: "Review",
                children: [
                  KanbanColumnItem(
                    title: "Design System Setup",
                    content:
                        "Create a comprehensive design system with colors, typography and components",
                    date: "19/11/2025",
                    priority: "High",
                    priorityColor: Colors.red,
                  ),
                  const SizedBox(height: 8),
                  KanbanColumnItem(
                    title: "API Integration",
                    content: "Integrate with backgend APIs for data fetching",
                    date: "19/11/2025",
                    priority: "High",
                    priorityColor: Colors.gray,
                  ),
                ],
              ),
              KanbanColumn(
                columnTitle: "Review",
                children: [
                  KanbanColumnItem(
                    title: "User Authentication",
                    content: "Implement login and signup functionality",
                    date: "19/11/2025",
                    priority: "High",
                    priorityColor: Colors.red,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Flex(
            direction: .horizontal,
            spacing: 16,
            children: [
              KanbanColumn(
                columnTitle: "Review",
                children: [
                  KanbanColumnItem(
                    title: "Mobile Responsiveness",
                    content: "Ensure the app works perfectly on mobile devices",
                    date: "19/11/2025",
                    priority: "High",
                    priorityColor: Colors.red,
                  ),
                ],
              ),
              KanbanColumn(
                columnTitle: "Done",
                children: [
                  KanbanColumnItem(
                    title: "Project Setup",
                    content: "Initialize Flutter project",
                    date: "19/11/2025",
                    priority: "Low",
                    priorityColor: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class KanbanColumn extends StatefulWidget {
  final String columnTitle;
  final List<Widget> children;

  const KanbanColumn({
    super.key,
    required this.columnTitle,
    required this.children,
  });

  @override
  State<KanbanColumn> createState() => KanbanColumnState();
}

class KanbanColumnState extends State<KanbanColumn> {
  final _titleKey = const TextFieldKey(#title);
  final _descriptionKey = const TextFieldKey(#description);
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                    PrimaryBadge(child: const Text("2")),
                  ],
                ),
                IconButton.ghost(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final FormController controller = FormController();

                        return AlertDialog(
                          title: const Text("Add Task"),
                          content: Column(
                            mainAxisSize: .min,
                            crossAxisAlignment: .start,
                            children: [
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 400,
                                ),
                                child: Form(
                                  controller: controller,
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      FormField(
                                        key: _titleKey,
                                        label: const Text("Title"),
                                        child: const TextField(),
                                      ),
                                      const SizedBox(height: 12),
                                      FormField(
                                        key: _descriptionKey,
                                        label: const Text("Description"),
                                        child: const TextField(),
                                      ),
                                      const SizedBox(height: 12),
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
                                        placeholder: const Text('Priority'),
                                        popup: const SelectPopup(
                                          items: SelectItemList(
                                            children: [
                                              SelectItemButton(
                                                value: 'Low',
                                                child: Text('Low'),
                                              ),
                                              SelectItemButton(
                                                value: 'Medium',
                                                child: Text('Medium'),
                                              ),
                                              SelectItemButton(
                                                value: 'High',
                                                child: Text('High'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            SecondaryButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop(controller.values);
                              },
                            ),
                            PrimaryButton(
                              child: const Text("Save changes"),
                              onPressed: () {
                                Navigator.of(context).pop(controller.values);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  density: ButtonDensity.icon,
                  icon: const Icon(LucideIcons.plus),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
  final String date;
  final String priority;
  final Color? priorityColor;

  const KanbanColumnItem({
    super.key,
    required this.title,
    required this.content,
    required this.date,
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
      padding: const .all(8),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(widget.title).small(),
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
                                leading: const Icon(LucideIcons.trash),
                                child: const Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(LucideIcons.ellipsisVertical),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(widget.content).small(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(widget.date).xSmall(),
              PrimaryBadge(
                style: ButtonStyle(
                  variance: ButtonStyle.primary()
                      .withBackgroundColor(color: widget.priorityColor)
                      .withForegroundColor(color: Colors.white),
                  size: ButtonSize.small,
                  density: ButtonDensity.dense,
                ),
                child: Text(widget.priority),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
