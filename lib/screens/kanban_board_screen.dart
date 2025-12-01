import "package:shadcn_flutter/shadcn_flutter.dart";

// TODO:
// Fix DropdownMenu position
// Fix Badges -> Chips
// Fix Drag and Drop
// Fix delete navigation

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

// -----------------------------
// Main Screen (stateful, owns the data & logic)
// -----------------------------
class KanbanBoardScreen extends StatefulWidget {
  const KanbanBoardScreen({super.key});

  @override
  State<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends State<KanbanBoardScreen> {
  List<KanbanColumnData> columns = [];

  @override
  void initState() {
    super.initState();
    // Seed sample data
    columns = [
      KanbanColumnData(
        id: "col_1",
        title: "Todo",
        tasks: [
          KanbanTask(
            id: "t1",
            title: "Project Setup",
            content: "Initialize Flutter project and repo",
            date: "2025-11-19",
            priority: "Low",
            priorityColor: Colors.blue,
          ),
        ],
      ),
      KanbanColumnData(
        id: "col_2",
        title: "In Progress",
        tasks: [
          KanbanTask(
            id: "t2",
            title: "User Authentication",
            content: "Implement login & signup",
            date: "2025-11-19",
            priority: "High",
            priorityColor: Colors.red,
          ),
        ],
      ),
      KanbanColumnData(id: "col_3", title: "Done", tasks: []),
    ];
  }

  // Create a simple ID generator
  String _newId() => DateTime.now().microsecondsSinceEpoch.toString();

  // Column operations
  void addColumn(String title) {
    setState(() {
      columns.add(KanbanColumnData(id: _newId(), title: title, tasks: []));
    });
  }

  void renameColumn(String columnId, String newTitle) {
    setState(() {
      final col = columns.firstWhere((c) => c.id == columnId);
      col.title = newTitle;
    });
  }

  void deleteColumn(String columnId) {
    setState(() {
      columns.removeWhere((c) => c.id == columnId);
    });
  }

  // Task operations
  void addTask(String columnId, KanbanTask task) {
    setState(() {
      columns.firstWhere((c) => c.id == columnId).tasks.add(task);
    });
  }

  void editTask(String columnId, KanbanTask updatedTask) {
    setState(() {
      final col = columns.firstWhere((c) => c.id == columnId);
      final idx = col.tasks.indexWhere((t) => t.id == updatedTask.id);
      if (idx != -1) col.tasks[idx] = updatedTask;
    });
  }

  void deleteTask(String columnId, String taskId) {
    setState(() {
      final col = columns.firstWhere((c) => c.id == columnId);
      col.tasks.removeWhere((t) => t.id == taskId);
    });
  }

  // Move task across columns (used by drag & drop)
  void moveTask({
    required String fromColumnId,
    required String toColumnId,
    required String taskId,
    int? toIndex,
  }) {
    if (fromColumnId == toColumnId) return;
    setState(() {
      final fromCol = columns.firstWhere((c) => c.id == fromColumnId);
      final task = fromCol.tasks.firstWhere((t) => t.id == taskId);
      fromCol.tasks.removeWhere((t) => t.id == taskId);

      final toCol = columns.firstWhere((c) => c.id == toColumnId);
      if (toIndex == null || toIndex > toCol.tasks.length) {
        toCol.tasks.add(task);
      } else {
        toCol.tasks.insert(toIndex, task);
      }
    });
  }

  // Open dialog used to add a column
  Future<void> _showAddColumnDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Column"),
          content: FormField(
            key: FormKey(#columnName),
            label: Text("Column name"),
            child: TextField(controller: controller),
          ),
          actions: [
            SecondaryButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            PrimaryButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text.trim());
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      addColumn(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top actions
          Row(
            children: [
              OutlineButton(
                onPressed: _showAddColumnDialog,
                density: ButtonDensity.icon,
                leading: const Icon(LucideIcons.plus),
                child: const Text("Add Column"),
              ),
              const SizedBox(width: 8),
              // quick hint
              const Text("Drag a task to move between columns").muted(),
            ],
          ),
          const SizedBox(height: 12),

          // Columns horizontally scrollable
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columns
                    .map(
                      (col) => Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: KanbanColumnWidget(
                          key: ValueKey(col.id),
                          column: col,
                          onAddTask: (task) => addTask(col.id, task),
                          onEditTask: (task) => editTask(col.id, task),
                          onDeleteTask: (taskId) => deleteTask(col.id, taskId),
                          onMoveTask: (fromColumnId, taskId) => moveTask(
                            fromColumnId: fromColumnId,
                            toColumnId: col.id,
                            taskId: taskId,
                          ),
                          onRenameColumn: (newTitle) =>
                              renameColumn(col.id, newTitle),
                          onDeleteColumn: () => deleteColumn(col.id),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------
// Kanban Column (stateless)
// -----------------------------
typedef AddTaskCallback = void Function(KanbanTask task);
typedef EditTaskCallback = void Function(KanbanTask task);
typedef DeleteTaskCallback = void Function(String taskId);
typedef MoveTaskFromCallback =
    void Function(String fromColumnId, String taskId);

class KanbanColumnWidget extends StatelessWidget {
  final KanbanColumnData column;
  final AddTaskCallback onAddTask;
  final EditTaskCallback onEditTask;
  final DeleteTaskCallback onDeleteTask;
  final MoveTaskFromCallback onMoveTask;
  final ValueChanged<String> onRenameColumn;
  final VoidCallback onDeleteColumn;

  const KanbanColumnWidget({
    super.key,
    required this.column,
    required this.onAddTask,
    required this.onEditTask,
    required this.onDeleteTask,
    required this.onMoveTask,
    required this.onRenameColumn,
    required this.onDeleteColumn,
  });

  // helper to open the task dialog for adding
  Future<void> _openAddTaskDialog(BuildContext context) async {
    final result = await showDialog<KanbanTask>(
      context: context,
      builder: (context) {
        return TaskDialog(
          // pass null => create mode
          initialTask: null,
        );
      },
    );

    if (result != null) {
      onAddTask(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Card(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(column.title).semiBold(),
                      PrimaryBadge(child: Text("${column.tasks.length}")),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton.ghost(
                        onPressed: () => _openAddTaskDialog(context),
                        icon: const Icon(LucideIcons.plus),
                        density: ButtonDensity.icon,
                      ),
                      IconButton.ghost(
                        onPressed: () async {
                          final controller = TextEditingController(
                            text: column.title,
                          );
                          final newTitle = await showDialog<String?>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Rename Column"),
                                content: FormField(
                                  key: FormKey(#title),
                                  label: Text("Title"),
                                  child: TextField(controller: controller),
                                ),
                                actions: [
                                  SecondaryButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(null),
                                    child: const Text("Cancel"),
                                  ),
                                  PrimaryButton(
                                    onPressed: () => Navigator.of(
                                      context,
                                    ).pop(controller.text.trim()),
                                    child: const Text("Save"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (newTitle != null && newTitle.isNotEmpty) {
                            onRenameColumn(newTitle);
                          }
                        },
                        icon: Icon(LucideIcons.pencil),
                      ),
                      IconButton.ghost(
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Delete column?"),
                                content: Text(
                                  "Delete '${column.title}' and ${column.tasks.length} tasks?",
                                ),
                                actions: [
                                  SecondaryButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("Cancel"),
                                  ),
                                  PrimaryButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmed == true) {
                            onDeleteColumn();
                          }
                        },
                        icon: const Icon(LucideIcons.trash),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Task list with DragTargets
            Expanded(
              child: DragTarget<Map<String, String>>(
                // expects map {fromColumnId, taskId}
                onWillAccept: (data) => data != null,
                onAccept: (data) {
                  final fromColumnId = data["fromColumnId"]!;
                  final taskId = data["taskId"]!;
                  onMoveTask(fromColumnId, taskId);
                },
                builder: (context, candidateData, rejectedData) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: column.tasks.length,
                    itemBuilder: (context, index) {
                      final task = column.tasks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: LongPressDraggable<Map<String, String>>(
                          data: {"fromColumnId": column.id, "taskId": task.id},
                          feedback: ShadcnUI(
                            // color: Colors.transparent,
                            child: SizedBox(
                              width: 300,
                              child: KanbanTaskCard(
                                task: task,
                                onEdit: (_) {},
                                onDelete: (_) {},
                              ),
                            ),
                          ),
                          child: KanbanTaskCard(
                            task: task,
                            onEdit: (t) async {
                              final edited = await showDialog<KanbanTask>(
                                context: context,
                                builder: (_) => TaskDialog(initialTask: task),
                              );
                              if (edited != null) {
                                onEditTask(edited);
                              }
                            },
                            onDelete: (taskId) {
                              // confirm
                              showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Delete Task"),
                                  content: const Text(
                                    "Are you sure you want to delete this task?",
                                  ),
                                  actions: [
                                    SecondaryButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                      child: const Text("Cancel"),
                                    ),
                                    PrimaryButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                ),
                              ).then((confirmed) {
                                if (confirmed == true) {
                                  onDeleteTask(taskId);
                                }
                              });
                            },
                          ),
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

// -----------------------------
// Kanban Task Card (stateless)
// -----------------------------
class KanbanTaskCard extends StatelessWidget {
  final KanbanTask task;
  final ValueChanged<KanbanTask> onEdit;
  final ValueChanged<String> onDelete;

  const KanbanTaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(task.title).semiBold(),
              IconButton.ghost(
                onPressed: () {
                  showDropdown(
                    context: context,
                    builder: (ctx) {
                      return DropdownMenu(
                        children: [
                          MenuButton(
                            onPressed: (_) async {
                              // close dropdown then open edit
                              Navigator.of(ctx).pop();
                              final edited = await showDialog<KanbanTask>(
                                context: context,
                                builder: (context) =>
                                    TaskDialog(initialTask: task),
                              );
                              if (edited != null) onEdit(edited);
                            },
                            leading: const Icon(LucideIcons.pencil),
                            child: const Text("Edit"),
                          ),
                          MenuButton(
                            onPressed: (_) {
                              Navigator.of(ctx).pop();
                              onDelete(task.id);
                            },
                            leading: const Icon(LucideIcons.trash),
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(LucideIcons.ellipsisVertical),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(task.content).small(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(task.date).xSmall(),
              Chip(
                style: ButtonStyle.primary()
                    .withBackgroundColor(color: task.priorityColor)
                    .withForegroundColor(color: Colors.white),
                child: Text(task.priority),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------
// Task Dialog (reusable for create / edit)
// -----------------------------
class TaskDialog extends StatefulWidget {
  final KanbanTask? initialTask;

  const TaskDialog({super.key, this.initialTask});

  @override
  State<TaskDialog> createState() => TaskDialogState();
}

class TaskDialogState extends State<TaskDialog> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  late final TextEditingController _dateCtrl;
  String? _priority = "Low";

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initialTask?.title ?? "");
    _contentCtrl = TextEditingController(
      text: widget.initialTask?.content ?? "",
    );
    _dateCtrl = TextEditingController(
      text: widget.initialTask?.date ?? _todayString(),
    );
    _priority = widget.initialTask?.priority ?? "Low";
  }

  String _todayString() {
    final now = DateTime.now();
    return "${now.year.toString().padLeft(4, "0")}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")}";
  }

  Color priorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  void _onSave() {
    final id =
        widget.initialTask?.id ??
        DateTime.now().microsecondsSinceEpoch.toString();

    final task = KanbanTask(
      id: id,
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      date: _dateCtrl.text.trim(),
      priority: _priority.toString(),
      priorityColor: priorityColor(_priority.toString()),
    );

    Navigator.of(context).pop(task);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialTask != null;
    return AlertDialog(
      title: Text(isEditing ? "Edit Task" : "Add Task"),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Title"),
                  const SizedBox(height: 6),
                  TextField(controller: _titleCtrl),
                  const SizedBox(height: 12),
                  const Text("Description"),
                  const SizedBox(height: 6),
                  TextField(controller: _contentCtrl, maxLines: 3),
                  const SizedBox(height: 12),
                  const Text("Date (YYYY-MM-DD)"),
                  const SizedBox(height: 6),
                  TextField(controller: _dateCtrl),
                  const SizedBox(height: 12),
                  const Text("Priority"),
                  const SizedBox(height: 6),
                  Select<String>(
                    itemBuilder: (context, item) {
                      return Text(item);
                    },
                    popupConstraints: const BoxConstraints(
                      maxHeight: 300,
                      maxWidth: 200,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _priority = value;
                      });
                    },
                    value: _priority,
                    placeholder: const Text("Priority"),
                    popup: const SelectPopup(
                      items: SelectItemList(
                        children: [
                          SelectItemButton(value: "Low", child: Text("Low")),
                          SelectItemButton(
                            value: "Medium",
                            child: Text("Medium"),
                          ),
                          SelectItemButton(value: "High", child: Text("High")),
                        ],
                      ),
                    ),
                  ),
                  // DropdownButtonFormField<String>(
                  //   value: _priority,
                  //   items: const [
                  //     DropdownMenuItem(value: "Low", child: Text("Low")),
                  //     DropdownMenuItem(value: "Medium", child: Text("Medium")),
                  //     DropdownMenuItem(value: "High", child: Text("High")),
                  //   ],
                  //   onChanged: (v) {
                  //     if (v != null) setState(() => _priority = v);
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        SecondaryButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        PrimaryButton(
          onPressed: _onSave,
          child: Text(isEditing ? "Save" : "Add"),
        ),
      ],
    );
  }
}

// class KanbanBoardScreen extends StatefulWidget {
//   const KanbanBoardScreen({super.key});

//   @override
//   State<KanbanBoardScreen> createState() => KanbanBoardScreenState();
// }

// class KanbanBoardScreenState extends State<KanbanBoardScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const .all(16),
//       child: Column(
//         crossAxisAlignment: .start,
//         children: [
//           Flex(
//             direction: .horizontal,
//             spacing: 8,
//             children: [
//               OutlineButton(
//                 onPressed: () {},
//                 density: .icon,
//                 leading: const Icon(LucideIcons.plus),
//                 child: const Text("Add Column"),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           // Example columns
//           Flex(
//             direction: .horizontal,
//             crossAxisAlignment: .start,
//             spacing: 16,
//             children: [
//               KanbanColumn(
//                 columnTitle: "Review",
//                 children: [
//                   KanbanColumnItem(
//                     title: "Design System Setup",
//                     content:
//                         "Create a comprehensive design system with colors, typography and components",
//                     date: "19/11/2025",
//                     priority: "High",
//                     priorityColor: Colors.red,
//                   ),
//                   const SizedBox(height: 8),
//                   KanbanColumnItem(
//                     title: "API Integration",
//                     content: "Integrate with backgend APIs for data fetching",
//                     date: "19/11/2025",
//                     priority: "High",
//                     priorityColor: Colors.gray,
//                   ),
//                 ],
//               ),
//               KanbanColumn(
//                 columnTitle: "Review",
//                 children: [
//                   KanbanColumnItem(
//                     title: "User Authentication",
//                     content: "Implement login and signup functionality",
//                     date: "19/11/2025",
//                     priority: "High",
//                     priorityColor: Colors.red,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Flex(
//             direction: .horizontal,
//             spacing: 16,
//             children: [
//               KanbanColumn(
//                 columnTitle: "Review",
//                 children: [
//                   KanbanColumnItem(
//                     title: "Mobile Responsiveness",
//                     content: "Ensure the app works perfectly on mobile devices",
//                     date: "19/11/2025",
//                     priority: "High",
//                     priorityColor: Colors.red,
//                   ),
//                 ],
//               ),
//               KanbanColumn(
//                 columnTitle: "Done",
//                 children: [
//                   KanbanColumnItem(
//                     title: "Project Setup",
//                     content: "Initialize Flutter project",
//                     date: "19/11/2025",
//                     priority: "Low",
//                     priorityColor: Colors.blue,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class KanbanColumn extends StatefulWidget {
//   final String columnTitle;
//   final List<Widget> children;

//   const KanbanColumn({
//     super.key,
//     required this.columnTitle,
//     required this.children,
//   });

//   @override
//   State<KanbanColumn> createState() => KanbanColumnState();
// }

// class KanbanColumnState extends State<KanbanColumn> {
//   final _titleKey = const TextFieldKey(#title);
//   final _descriptionKey = const TextFieldKey(#description);
//   String? _selectedValue;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Card(
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: .spaceBetween,
//               children: [
//                 Wrap(
//                   spacing: 8,
//                   children: [
//                     Text(widget.columnTitle),
//                     PrimaryBadge(child: const Text("2")),
//                   ],
//                 ),
//                 IconButton.ghost(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         final FormController controller = FormController();

//                         return AlertDialog(
//                           title: const Text("Add Task"),
//                           content: Column(
//                             mainAxisSize: .min,
//                             crossAxisAlignment: .start,
//                             children: [
//                               ConstrainedBox(
//                                 constraints: const BoxConstraints(
//                                   maxWidth: 400,
//                                 ),
//                                 child: Form(
//                                   controller: controller,
//                                   child: Column(
//                                     crossAxisAlignment: .start,
//                                     children: [
//                                       FormField(
//                                         key: _titleKey,
//                                         label: const Text("Title"),
//                                         child: const TextField(),
//                                       ),
//                                       const SizedBox(height: 12),
//                                       FormField(
//                                         key: _descriptionKey,
//                                         label: const Text("Description"),
//                                         child: const TextField(),
//                                       ),
//                                       const SizedBox(height: 12),
//                                       Select<String>(
//                                         itemBuilder: (context, item) {
//                                           return Text(item);
//                                         },
//                                         popupConstraints: const BoxConstraints(
//                                           maxHeight: 300,
//                                           maxWidth: 200,
//                                         ),
//                                         onChanged: (value) {
//                                           setState(() {
//                                             _selectedValue = value;
//                                           });
//                                         },
//                                         value: _selectedValue,
//                                         placeholder: const Text("Priority"),
//                                         popup: const SelectPopup(
//                                           items: SelectItemList(
//                                             children: [
//                                               SelectItemButton(
//                                                 value: "Low",
//                                                 child: Text("Low"),
//                                               ),
//                                               SelectItemButton(
//                                                 value: "Medium",
//                                                 child: Text("Medium"),
//                                               ),
//                                               SelectItemButton(
//                                                 value: "High",
//                                                 child: Text("High"),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           actions: [
//                             SecondaryButton(
//                               child: const Text("Cancel"),
//                               onPressed: () {
//                                 Navigator.of(context).pop(controller.values);
//                               },
//                             ),
//                             PrimaryButton(
//                               child: const Text("Save changes"),
//                               onPressed: () {
//                                 Navigator.of(context).pop(controller.values);
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                   density: ButtonDensity.icon,
//                   icon: const Icon(LucideIcons.plus),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             ...widget.children,
//           ],
//         ),
//       ),
//     );
//   }
// }

// class KanbanColumnItem extends StatefulWidget {
//   final String title;
//   final String content;
//   final String date;
//   final String priority;
//   final Color? priorityColor;

//   const KanbanColumnItem({
//     super.key,
//     required this.title,
//     required this.content,
//     required this.date,
//     required this.priority,
//     required this.priorityColor,
//   });

//   @override
//   State<KanbanColumnItem> createState() => KanbanColumnItemState();
// }

// class KanbanColumnItemState extends State<KanbanColumnItem> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       padding: const .all(8),
//       child: Column(
//         crossAxisAlignment: .start,
//         children: [
//           Row(
//             mainAxisAlignment: .spaceBetween,
//             children: [
//               Text(widget.title).small(),
//               Builder(
//                 builder: (context) {
//                   return IconButton.ghost(
//                     onPressed: () {
//                       showDropdown(
//                         context: context,
//                         builder: (context) {
//                           return DropdownMenu(
//                             children: [
//                               MenuButton(
//                                 onPressed: (_) {},
//                                 leading: const Icon(LucideIcons.pencil),
//                                 child: const Text("Edit"),
//                               ),
//                               MenuButton(
//                                 onPressed: (_) {},
//                                 leading: const Icon(LucideIcons.trash),
//                                 child: const Text("Delete"),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                     icon: const Icon(LucideIcons.ellipsisVertical),
//                   );
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Text(widget.content).small(),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: .spaceBetween,
//             children: [
//               Text(widget.date).xSmall(),
//               Chip(
//                 style: ButtonStyle.primary()
//                     .withBackgroundColor(color: widget.priorityColor)
//                     .withForegroundColor(color: Colors.white),
//                 child: Text(widget.priority),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
