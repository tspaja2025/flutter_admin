import "package:shadcn_flutter/shadcn_flutter.dart";

class KanbanBoardScreen extends StatefulWidget {
  const KanbanBoardScreen({super.key});

  @override
  State<KanbanBoardScreen> createState() => KanbanBoardScreenState();
}

class KanbanBoardScreenState extends State<KanbanBoardScreen> {
  String? _selectedValue;
  final TextEditingController _searchController = TextEditingController();

  // Sample data
  List<KanbanColumnData> _columns = [
    KanbanColumnData(
      id: "1",
      label: "To Do",
      tasks: [
        Task(
          id: "1",
          label: "Design System Setup",
          content:
              "Create a comprehensive design system with colors, typography, and components",
          date: DateTime(2025, 12, 13),
          priority: "High",
          priorityColor: Colors.red,
          columnId: "1",
        ),
        Task(
          id: "2",
          label: "API Integration",
          content: "Integrate with backend APIs for data fetching",
          date: DateTime(2025, 12, 13),
          priority: "Medium",
          priorityColor: Colors.orange,
          columnId: "1",
        ),
      ],
    ),
    KanbanColumnData(
      id: "2",
      label: "In Progress",
      tasks: [
        Task(
          id: "3",
          label: "User Authentication",
          content: "Implement login and signup functionality",
          date: DateTime(2025, 12, 13),
          priority: "High",
          priorityColor: Colors.red,
          columnId: "2",
        ),
      ],
    ),
    KanbanColumnData(
      id: "3",
      label: "Review",
      tasks: [
        Task(
          id: "4",
          label: "Mobile Responsiveness",
          content: "Ensure the app works perfectly on mobile devices",
          date: DateTime(2025, 12, 13),
          priority: "Medium",
          priorityColor: Colors.orange,
          columnId: "3",
        ),
      ],
    ),
    KanbanColumnData(
      id: "4",
      label: "Done",
      tasks: [
        Task(
          id: "5",
          label: "Project Setup",
          content: "Initialize Next.js project with TypeScript and Tailwind",
          date: DateTime(2025, 12, 13),
          priority: "Low",
          priorityColor: Colors.green,
          columnId: "4",
        ),
      ],
    ),
  ];

  // Add new Task
  void _addTask(String columnId) {
    showDialog(
      context: context,
      builder: (context) {
        final labelController = TextEditingController();
        final contentController = TextEditingController();
        String selectedPriority = "Medium";
        Color priorityColor = Colors.orange;
        bool isLabelValid = false;
        bool isContentValid = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add New Task"),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    TextField(
                      controller: labelController,
                      placeholder: const Text("Task Title"),
                      onChanged: (value) {
                        setState(() {
                          isLabelValid = value.trim().isNotEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: contentController,
                      placeholder: const Text("Description"),
                      maxLines: 3,
                      onChanged: (value) {
                        setState(() {
                          isContentValid = value.trim().isNotEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Select<String>(
                      itemBuilder: (context, item) {
                        return Text(item);
                      },
                      value: selectedPriority,
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value!;
                          priorityColor = _getPriorityColor(value);
                        });
                      },
                      placeholder: const Text("Priority"),
                      popup: SelectPopup(
                        items: SelectItemList(
                          children: [
                            SelectItemButton(
                              value: "High",
                              child: const Text("High"),
                            ),
                            SelectItemButton(
                              value: "Medium",
                              child: const Text("Medium"),
                            ),
                            SelectItemButton(
                              value: "Low",
                              child: const Text("Low"),
                            ),
                          ],
                        ),
                      ).call,
                    ),
                  ],
                ),
              ),
              actions: [
                SecondaryButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                PrimaryButton(
                  onPressed: isLabelValid && isContentValid
                      ? () {
                          final newTask = Task(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            label: labelController.text.trim(),
                            content: contentController.text.trim(),
                            date: DateTime.now(),
                            priority: selectedPriority,
                            priorityColor: priorityColor,
                            columnId: columnId,
                          );

                          setState(() {
                            final columnIndex = _columns.indexWhere(
                              (col) => col.id == columnId,
                            );
                            if (columnIndex != -1) {
                              _columns[columnIndex] = _columns[columnIndex]
                                  .copyWith(
                                    tasks: [
                                      ..._columns[columnIndex].tasks,
                                      newTask,
                                    ],
                                  );
                            }
                          });
                          Navigator.pop(context);
                        }
                      : null,
                  child: const Text("Add Task"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Add New Column
  void _addColumn() {
    showDialog(
      context: context,
      builder: (context) {
        final labelController = TextEditingController();
        bool isValid = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add New Column"),
              content: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    TextField(
                      controller: labelController,
                      placeholder: const Text("Column Name"),
                      onChanged: (value) {
                        setState(() {
                          isValid = value.trim().isNotEmpty;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                SecondaryButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                PrimaryButton(
                  onPressed: isValid
                      ? () {
                          final newColumn = KanbanColumnData(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            label: labelController.text.trim(),
                            tasks: [],
                          );

                          setState(() {
                            _columns = [..._columns, newColumn];
                          });
                          Navigator.pop(context);
                        }
                      : null,
                  child: const Text("Add Column"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Edit task
  void _editTask(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        final labelController = TextEditingController(text: task.label);
        final contentController = TextEditingController(text: task.content);
        String selectedPriority = task.priority;
        Color priorityColor = task.priorityColor;
        bool isLabelValid = true;
        bool isContentValid = true;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Edit Task"),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    TextField(
                      controller: labelController,
                      placeholder: const Text("Task Title"),
                      onChanged: (value) {
                        setState(() {
                          isLabelValid = value.trim().isNotEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: contentController,
                      placeholder: const Text("Description"),
                      maxLines: 3,
                      onChanged: (value) {
                        setState(() {
                          isContentValid = value.trim().isNotEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Select<String>(
                      itemBuilder: (context, item) {
                        return Text(item);
                      },
                      value: selectedPriority,
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value!;
                          priorityColor = _getPriorityColor(value);
                        });
                      },
                      placeholder: const Text("Priority"),
                      popup: SelectPopup(
                        items: SelectItemList(
                          children: [
                            SelectItemButton(
                              value: "High",
                              child: const Text("High"),
                            ),
                            SelectItemButton(
                              value: "Medium",
                              child: const Text("Medium"),
                            ),
                            SelectItemButton(
                              value: "Low",
                              child: const Text("Low"),
                            ),
                          ],
                        ),
                      ).call,
                    ),
                    const SizedBox(height: 16),
                    Select<String>(
                      itemBuilder: (context, item) {
                        return Text(item);
                      },
                      value: task.columnId,
                      onChanged: (value) {
                        _moveTask(task.id, task.columnId, value!);
                      },
                      placeholder: const Text("Move to Column"),
                      popup: SelectPopup(
                        items: SelectItemList(
                          children: _columns.map((column) {
                            return SelectItemButton(
                              value: column.id,
                              child: Text(column.label),
                            );
                          }).toList(),
                        ),
                      ).call,
                    ),
                  ],
                ),
              ),
              actions: [
                SecondaryButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                PrimaryButton(
                  onPressed: isLabelValid && isContentValid
                      ? () {
                          _updateTask(
                            task.id,
                            labelController.text.trim(),
                            contentController.text.trim(),
                            selectedPriority,
                            priorityColor,
                          );
                          Navigator.pop(context);
                        }
                      : null,
                  child: const Text("Save Changes"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Edit column
  void _editColumn(KanbanColumnData column) {
    showDialog(
      context: context,
      builder: (context) {
        final labelController = TextEditingController(text: column.label);
        bool isValid = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Edit Column"),
              content: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    TextField(
                      controller: labelController,
                      placeholder: const Text("Column Name"),
                      onChanged: (value) {
                        setState(() {
                          isValid = value.trim().isNotEmpty;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                SecondaryButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                PrimaryButton(
                  onPressed: isValid
                      ? () {
                          _updateColumn(column.id, labelController.text.trim());
                          Navigator.pop(context);
                        }
                      : null,
                  child: const Text("Save Changes"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Remove task
  void _deleteTask(String taskId, String columnId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm deletion"),
          content: const Text("Are you sure you want to delte this task?"),
          actions: [
            SecondaryButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            PrimaryButton(
              onPressed: () {
                setState(() {
                  final columnIndex = _columns.indexWhere(
                    (col) => col.id == columnId,
                  );

                  if (columnIndex != -1) {
                    _columns[columnIndex] = _columns[columnIndex].copyWith(
                      tasks: _columns[columnIndex].tasks
                          .where((task) => task.id != taskId)
                          .toList(),
                    );
                  }
                });
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // Remove column
  void _deleteColumn(String columnId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm deletion"),
          content: const Text(
            "Are you sure you want to delete this column? All tasks in this column will be deleted.",
          ),
          actions: [
            SecondaryButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            PrimaryButton(
              onPressed: () {
                setState(() {
                  _columns = _columns
                      .where((col) => col.id != columnId)
                      .toList();
                });
                Navigator.pop(context);
              },
              child: const Text("Delete Column"),
            ),
          ],
        );
      },
    );
  }

  // Update Task
  void _updateTask(
    String taskId,
    String label,
    String content,
    String priority,
    Color priorityColor,
  ) {
    setState(() {
      _columns = _columns.map((column) {
        final updatedTasks = column.tasks.map((task) {
          if (task.id == taskId) {
            return task.copyWith(
              label: label,
              content: content,
              priority: priority,
              priorityColor: priorityColor,
            );
          }
          return task;
        }).toList();
        return column.copyWith(tasks: updatedTasks);
      }).toList();
    });
  }

  // Update column
  void _updateColumn(String columnId, String label) {
    setState(() {
      _columns = _columns.map((column) {
        if (column.id == columnId) {
          return column.copyWith(label: label);
        }
        return column;
      }).toList();
    });
  }

  // Move task
  void _moveTask(String taskId, String fromColumnId, String toColumnId) {
    setState(() {
      Task? taskToMove;

      // Remove from source column
      _columns = _columns.map((column) {
        if (column.id == fromColumnId) {
          final filteredTasks = column.tasks
              .where((task) => task.id != taskId)
              .toList();

          taskToMove = column.tasks.firstWhere((task) => task.id == taskId);

          return column.copyWith(tasks: filteredTasks);
        }
        return column;
      }).toList();

      // Add to target column
      if (taskToMove != null) {
        _columns = _columns.map((column) {
          if (column.id == toColumnId) {
            final movedTask = taskToMove!.copyWith(columnId: toColumnId);

            return column.copyWith(tasks: [...column.tasks, movedTask]);
          }
          return column;
        }).toList();
      }
    });
  }

  // Get priority color
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      case "Low":
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  // Format Date
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // Filtered columns
  List<KanbanColumnData> get _filteredColumns {
    final searchQuery = _searchController.text.toLowerCase();

    if (searchQuery.isEmpty) return _columns;

    return _columns.map((column) {
      final filteredTasks = column.tasks.where((task) {
        return task.label.toLowerCase().contains(searchQuery) ||
            task.content.toLowerCase().contains(searchQuery);
      }).toList();
      return column.copyWith(tasks: filteredTasks);
    }).toList();
  }

  // Sort tasks
  void _sortTasks(String? sortBy) {
    if (sortBy == null) return;

    setState(() {
      _columns = _columns.map((column) {
        final sortedTasks = List<Task>.from(column.tasks);

        switch (sortBy) {
          case "DateCreated":
            sortedTasks.sort((a, b) => b.date.compareTo(a.date));
            break;
          case "Priority":
            final priorityOrder = {"High": 3, "Medium": 2, "Low": 1};

            sortedTasks.sort(
              (a, b) => (priorityOrder[b.priority] ?? 0).compareTo(
                priorityOrder[a.priority] ?? 0,
              ),
            );
            break;
          case "Title":
            sortedTasks.sort((a, b) => a.label.compareTo(b.label));
            break;
        }

        return column.copyWith(tasks: sortedTasks);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _buildActionRow(),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: .horizontal,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: .start,
                      spacing: 16,
                      children: _filteredColumns.map((column) {
                        return KanbanColumn(
                          columnData: column,
                          onAddTask: () => _addTask(column.id),
                          onEditColumn: () => _editColumn(column),
                          onDeleteColumn: () => _deleteColumn(column.id),
                          onEditTask: (task) => _editTask(task),
                          onDeleteTask: (taskId) =>
                              _deleteTask(taskId, column.id),
                          formatDate: _formatDate,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow() {
    return Row(
      spacing: 8,
      children: [
        SizedBox(
          width: 200,
          child: TextField(
            controller: _searchController,
            placeholder: const Text("Search tasks..."),
            onChanged: (_) => setState(() {}),
            features: [
              InputFeature.leading(
                StatedWidget.builder(
                  builder: (context, states) {
                    return const Icon(LucideIcons.search);
                  },
                ),
              ),
              InputFeature.trailing(
                StatedWidget.builder(
                  builder: (context, states) {
                    return IconButton.ghost(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          setState(() {});
                        });
                      },
                      density: .iconDense,
                      icon: const Icon(LucideIcons.x),
                    );
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
          popupConstraints: const BoxConstraints(maxHeight: 300, maxWidth: 200),
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
              _sortTasks(value);
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
          onPressed: _addColumn,
          leading: const Icon(LucideIcons.plus),
          child: const Text("Add Column"),
        ),
      ],
    );
  }
}

class KanbanColumn extends StatefulWidget {
  final KanbanColumnData columnData;
  final VoidCallback onAddTask;
  final VoidCallback onEditColumn;
  final VoidCallback onDeleteColumn;
  final Function(Task) onEditTask;
  final Function(String) onDeleteTask;
  final String Function(DateTime) formatDate;

  const KanbanColumn({
    super.key,
    required this.columnData,
    required this.onAddTask,
    required this.onEditColumn,
    required this.onDeleteColumn,
    required this.onEditTask,
    required this.onDeleteTask,
    required this.formatDate,
  });

  @override
  State<KanbanColumn> createState() => KanbanColumnState();
}

class KanbanColumnState extends State<KanbanColumn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: Card(
        child: Column(
          children: [
            Row(
              spacing: 8,
              children: [
                Text(widget.columnData.label).bold(),
                SecondaryBadge(child: Text(widget.columnData.total.toString())),
                const Spacer(),
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
                                  onPressed: (_) => widget.onAddTask(),
                                  leading: const Icon(LucideIcons.plus),
                                  child: const Text("New Task"),
                                ),
                                MenuButton(
                                  onPressed: (_) => widget.onEditColumn(),
                                  leading: const Icon(LucideIcons.pencil),
                                  child: const Text("Edit Column"),
                                ),
                                MenuButton(
                                  onPressed: (_) => widget.onDeleteColumn(),
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
            const SizedBox(height: 8),
            ...widget.columnData.tasks.map((task) {
              return KanbanColumnItem(
                task: task,
                onEdit: () => widget.onEditTask(task),
                onDelete: () => widget.onDeleteTask(task.id),
                formatDate: widget.formatDate,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class KanbanColumnItem extends StatefulWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String Function(DateTime) formatDate;

  const KanbanColumnItem({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.formatDate,
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
            children: [
              Text(widget.task.label),
              const Spacer(),
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
                                onPressed: (_) => widget.onEdit(),
                                leading: const Icon(LucideIcons.pencil),
                                child: const Text("Edit"),
                              ),
                              MenuButton(
                                onPressed: (_) => widget.onDelete(),
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
          Text(widget.task.content).small(),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(widget.formatDate(widget.task.date)).muted().small(),
              const SizedBox(height: 16),
              const Spacer(),
              Container(
                padding: const .symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.task.priorityColor.withValues(alpha: 0.2),
                  borderRadius: .circular(8),
                  border: .all(color: widget.task.priorityColor),
                ),
                child: Text(widget.task.priority).xSmall(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Models
class Task {
  String id;
  String label;
  String content;
  DateTime date;
  String priority;
  Color priorityColor;
  String columnId;

  Task({
    required this.id,
    required this.label,
    required this.content,
    required this.date,
    required this.priority,
    required this.priorityColor,
    required this.columnId,
  });

  Task copyWith({
    String? id,
    String? label,
    String? content,
    DateTime? date,
    String? priority,
    Color? priorityColor,
    String? columnId,
  }) {
    return Task(
      id: id ?? this.id,
      label: label ?? this.label,
      content: content ?? this.content,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      priorityColor: priorityColor ?? this.priorityColor,
      columnId: columnId ?? this.columnId,
    );
  }
}

class KanbanColumnData {
  String id;
  String label;
  List<Task> tasks;

  KanbanColumnData({
    required this.id,
    required this.label,
    required this.tasks,
  });

  int get total => tasks.length;

  KanbanColumnData copyWith({String? id, String? label, List<Task>? tasks}) {
    return KanbanColumnData(
      id: id ?? this.id,
      label: label ?? this.label,
      tasks: tasks ?? this.tasks,
    );
  }
}
