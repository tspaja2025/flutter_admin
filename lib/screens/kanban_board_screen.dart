import 'dart:math';
import 'package:flutter/material.dart' as material;
import "package:shadcn_flutter/shadcn_flutter.dart";

// TODO:
// Broken on mobile

class KanbanBoardScreen extends StatefulWidget {
  const KanbanBoardScreen({super.key});

  @override
  State<KanbanBoardScreen> createState() => KanbanBoardScreenState();
}

class KanbanBoardScreenState extends State<KanbanBoardScreen> {
  String? _selectedValue;
  final TextEditingController _searchController = TextEditingController();

  // State for our kanban board
  List<KanbanColumnData> columns = [
    KanbanColumnData(
      id: 'todo',
      title: 'Todo',
      tasks: [
        KanbanTask(
          id: '1',
          title: 'Project Setup',
          content: 'Initialize Next.js project with TypeScript and Tailwind',
          date: '2025-04-12',
          priority: 'Low',
          priorityColor: Colors.blue,
        ),
        KanbanTask(
          id: '2',
          title: 'Database Schema',
          content: 'Design and implement database schema',
          date: '2025-04-13',
          priority: 'Medium',
          priorityColor: Colors.orange,
        ),
      ],
    ),
    KanbanColumnData(
      id: 'in-progress',
      title: 'In Progress',
      tasks: [
        KanbanTask(
          id: '3',
          title: 'Design System Setup',
          content:
              'Create a comprehensive design system with colors, typography, and components',
          date: '2025-04-10',
          priority: 'High',
          priorityColor: Colors.red,
        ),
        KanbanTask(
          id: '4',
          title: 'API Integration',
          content: 'Integrate with backend APIs for data fetching',
          date: '2025-04-11',
          priority: 'Medium',
          priorityColor: Colors.orange,
        ),
      ],
    ),
    KanbanColumnData(
      id: 'review',
      title: 'Review',
      tasks: [
        KanbanTask(
          id: '5',
          title: 'User Authentication',
          content: 'Implement login and signup functionality',
          date: '2025-04-09',
          priority: 'High',
          priorityColor: Colors.red,
        ),
      ],
    ),
    KanbanColumnData(
      id: 'done',
      title: 'Done',
      tasks: [
        KanbanTask(
          id: '6',
          title: 'Mobile Responsiveness',
          content: 'Ensure the app works perfectly on mobile devices',
          date: '2025-04-08',
          priority: 'Medium',
          priorityColor: Colors.orange,
        ),
      ],
    ),
  ];

  // Track drag and drop
  KanbanTask? _draggedTask;
  String? _sourceColumnId;
  int? _draggedIndex;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    // You could load data from shared preferences or API here
    // For now, we'll use the hardcoded data above
  }

  void _addNewColumn() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add New Column'),
          content: TextField(
            controller: controller,
            placeholder: const Text('Column name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    columns.add(
                      KanbanColumnData(
                        id: 'column-${DateTime.now().millisecondsSinceEpoch}',
                        title: controller.text,
                        tasks: [],
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addTaskToColumn(String columnId) {
    final columnIndex = columns.indexWhere((col) => col.id == columnId);
    if (columnIndex == -1) return;

    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final contentController = TextEditingController();
        String selectedPriority = 'Medium';
        Color priorityColor = Colors.orange;

        return AlertDialog(
          title: const Text('Add New Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: .min,
              children: [
                TextField(
                  controller: titleController,
                  placeholder: const Text('Task title'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  placeholder: const Text('Task description'),
                  maxLines: 3,
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
                      switch (value) {
                        case 'High':
                          priorityColor = Colors.red;
                          break;
                        case 'Medium':
                          priorityColor = Colors.orange;
                          break;
                        case 'Low':
                          priorityColor = Colors.blue;
                          break;
                      }
                    });
                  },
                  placeholder: const Text('Priority'),
                  popup: SelectPopup(
                    items: SelectItemList(
                      children: [
                        SelectItemButton(
                          value: 'High',
                          child: const Text('High'),
                        ),
                        SelectItemButton(
                          value: 'Medium',
                          child: const Text('Medium'),
                        ),
                        SelectItemButton(
                          value: 'Low',
                          child: const Text('Low'),
                        ),
                      ],
                    ),
                  ).call,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    columns[columnIndex].tasks.add(
                      KanbanTask(
                        id: 'task-${DateTime.now().millisecondsSinceEpoch}',
                        title: titleController.text,
                        content: contentController.text,
                        date: DateTime.now().toIso8601String().split('T')[0],
                        priority: selectedPriority,
                        priorityColor: priorityColor,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editTask(KanbanTask task, String columnId) {
    final columnIndex = columns.indexWhere((col) => col.id == columnId);
    if (columnIndex == -1) return;

    final taskIndex = columns[columnIndex].tasks.indexWhere(
      (t) => t.id == task.id,
    );
    if (taskIndex == -1) return;

    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController(text: task.title);
        final contentController = TextEditingController(text: task.content);
        String selectedPriority = task.priority;
        Color priorityColor = task.priorityColor;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    TextField(
                      controller: titleController,
                      placeholder: const Text('Task title'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: contentController,
                      placeholder: const Text('Task description'),
                      maxLines: 3,
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
                          switch (value) {
                            case 'High':
                              priorityColor = Colors.red;
                              break;
                            case 'Medium':
                              priorityColor = Colors.orange;
                              break;
                            case 'Low':
                              priorityColor = Colors.blue;
                              break;
                          }
                        });
                      },
                      placeholder: const Text('Priority'),
                      popup: SelectPopup(
                        items: SelectItemList(
                          children: [
                            SelectItemButton(
                              value: 'High',
                              child: const Text('High'),
                            ),
                            SelectItemButton(
                              value: 'Medium',
                              child: const Text('Medium'),
                            ),
                            SelectItemButton(
                              value: 'Low',
                              child: const Text('Low'),
                            ),
                          ],
                        ),
                      ).call,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                PrimaryButton(
                  onPressed: () {
                    setState(() {
                      columns[columnIndex].tasks[taskIndex] = task.copyWith(
                        title: titleController.text,
                        content: contentController.text,
                        priority: selectedPriority,
                        priorityColor: priorityColor,
                      );
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteTask(KanbanTask task, String columnId) {
    final columnIndex = columns.indexWhere((col) => col.id == columnId);
    if (columnIndex == -1) return;

    setState(() {
      columns[columnIndex].tasks.removeWhere((t) => t.id == task.id);
    });
  }

  void _deleteColumn(String columnId) {
    if (columns.length <= 1) {
      showToast(
        context: context,
        builder: (context, overlay) {
          return SurfaceCard(
            child: Basic(content: const Text('Cannot delete the last column')),
          );
        },
      );
      return;
    }

    setState(() {
      columns.removeWhere((col) => col.id == columnId);
    });
  }

  void _reorderTasks(
    String sourceColumnId,
    int oldIndex,
    String targetColumnId,
    int newIndex,
  ) {
    setState(() {
      final sourceColumnIndex = columns.indexWhere(
        (col) => col.id == sourceColumnId,
      );
      final targetColumnIndex = columns.indexWhere(
        (col) => col.id == targetColumnId,
      );

      if (sourceColumnIndex != -1 && targetColumnIndex != -1) {
        final task = columns[sourceColumnIndex].tasks.removeAt(oldIndex);

        if (sourceColumnId == targetColumnId) {
          // Reordering within same column
          columns[sourceColumnIndex].tasks.insert(
            newIndex > oldIndex ? newIndex - 1 : newIndex,
            task,
          );
        } else {
          // Moving to different column
          columns[targetColumnIndex].tasks.insert(newIndex, task);
        }
      }
    });
  }

  List<KanbanColumnData> _getFilteredColumns() {
    if (_searchController.text.isEmpty) {
      return columns;
    }

    final searchTerm = _searchController.text.toLowerCase();
    return columns.map((column) {
      final filteredTasks = column.tasks.where((task) {
        return task.title.toLowerCase().contains(searchTerm) ||
            task.content.toLowerCase().contains(searchTerm) ||
            task.priority.toLowerCase().contains(searchTerm);
      }).toList();

      return column.copyWith(tasks: filteredTasks);
    }).toList();
  }

  void _sortTasks() {
    setState(() {
      for (var column in columns) {
        switch (_selectedValue) {
          case 'DateCreated':
            column.tasks.sort((a, b) => b.date.compareTo(a.date));
            break;
          case 'Priority':
            final priorityOrder = {'High': 3, 'Medium': 2, 'Low': 1};
            column.tasks.sort(
              (a, b) => (priorityOrder[b.priority] ?? 0).compareTo(
                priorityOrder[a.priority] ?? 0,
              ),
            );
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredColumns = _getFilteredColumns();

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
                    _sortTasks();
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
                  onPressed: _addNewColumn,
                  density: .dense,
                  leading: const Icon(LucideIcons.plus),
                  child: const Text("Add Column"),
                ),
              ],
            ),
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
                      children: [
                        for (var column in filteredColumns)
                          _buildKanbanColumn(column),
                      ],
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

  Widget _buildKanbanColumn(KanbanColumnData column) {
    return material.DragTarget<KanbanTask>(
      onAcceptWithDetails: (task) {
        if (_draggedTask != null && _sourceColumnId != null) {
          final targetIndex = column.tasks.length;
          _reorderTasks(
            _sourceColumnId!,
            _draggedIndex!,
            column.id,
            targetIndex,
          );
          _draggedTask = null;
          _sourceColumnId = null;
          _draggedIndex = null;
        }
      },
      builder: (context, candidateData, rejectedData) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: material.LongPressDraggable<KanbanTask>(
            data: null, // Can't drag the column itself
            feedback: const SizedBox.shrink(),
            child: KanbanColumn(
              columnTitle: column.title,
              todoCount: column.tasks.length.toString(),
              children: [
                for (int i = 0; i < column.tasks.length; i++)
                  _buildDraggableTask(column.tasks[i], column.id, i),
                const SizedBox(height: 8),
                OutlineButton(
                  onPressed: () => _addTaskToColumn(column.id),
                  child: const Row(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(LucideIcons.plus, size: 16),
                      SizedBox(width: 8),
                      Text('Add Task'),
                    ],
                  ),
                ),
              ],
              onDelete: () => _deleteColumn(column.id),
              onAddItem: () => _addTaskToColumn(column.id),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDraggableTask(KanbanTask task, String columnId, int index) {
    return material.LongPressDraggable<KanbanTask>(
      data: task,
      feedback: Transform.scale(
        scale: 1.05,
        child: Opacity(
          opacity: 0.8,
          child: _buildTaskCard(task, columnId, index, isDragging: true),
        ),
      ),
      onDragStarted: () {
        setState(() {
          _draggedTask = task;
          _sourceColumnId = columnId;
          _draggedIndex = index;
        });
      },
      onDragCompleted: () {
        _draggedTask = null;
        _sourceColumnId = null;
        _draggedIndex = null;
      },
      child: material.DragTarget<KanbanTask>(
        onAcceptWithDetails: (draggedTask) {
          if (_draggedTask != null && _sourceColumnId != null) {
            _reorderTasks(_sourceColumnId!, _draggedIndex!, columnId, index);
          }
        },
        builder: (context, candidateData, rejectedData) {
          final isOver = candidateData.isNotEmpty;
          return Column(
            children: [
              if (isOver)
                Container(
                  height: 2,
                  color: Colors.blue,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
              _buildTaskCard(task, columnId, index),
              if (isOver)
                Container(
                  height: 2,
                  color: Colors.blue,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(
    KanbanTask task,
    String columnId,
    int index, {
    bool isDragging = false,
  }) {
    return KanbanColumnItem(
      key: ValueKey(task.id),
      title: task.title,
      content: task.content,
      priority: task.priority,
      priorityColor: task.priorityColor,
      date: task.date,
      onEdit: () => _editTask(task, columnId),
      onDelete: () => _deleteTask(task, columnId),
      opacity: isDragging ? 0.5 : 1.0,
    );
  }
}

class KanbanColumn extends StatefulWidget {
  final String columnTitle;
  final String todoCount;
  final List<Widget> children;
  final VoidCallback? onDelete;
  final VoidCallback? onAddItem;

  const KanbanColumn({
    super.key,
    required this.columnTitle,
    required this.todoCount,
    required this.children,
    this.onDelete,
    this.onAddItem,
  });

  @override
  State<KanbanColumn> createState() => KanbanColumnState();
}

class KanbanColumnState extends State<KanbanColumn> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: .start,
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
                                onPressed: (_) {
                                  widget.onAddItem?.call();
                                  Navigator.pop(context);
                                },
                                leading: const Icon(LucideIcons.plus),
                                child: const Text("Add Item"),
                              ),
                              MenuButton(
                                onPressed: (_) {
                                  widget.onDelete?.call();
                                  Navigator.pop(context);
                                },
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
    );
  }
}

class KanbanColumnItem extends StatefulWidget {
  final String title;
  final String content;
  final String priority;
  final Color priorityColor;
  final String date;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final double opacity;

  const KanbanColumnItem({
    super.key,
    required this.title,
    required this.content,
    required this.priority,
    required this.priorityColor,
    required this.date,
    this.onEdit,
    this.onDelete,
    this.opacity = 1.0,
  });

  @override
  State<KanbanColumnItem> createState() => KanbanColumnItemState();
}

class KanbanColumnItemState extends State<KanbanColumnItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(fontWeight: .bold),
                ),
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
                                onPressed: (_) {
                                  widget.onEdit?.call();
                                  Navigator.pop(context);
                                },
                                leading: const Icon(LucideIcons.pencil),
                                child: const Text("Edit"),
                              ),
                              MenuButton(
                                onPressed: (_) {
                                  widget.onDelete?.call();
                                  Navigator.pop(context);
                                },
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
          const SizedBox(height: 8),
          Text(
            widget.content,
            style: TextStyle(
              color: Theme.of(context).colorScheme.mutedForeground,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(widget.date).muted().small(),
              Container(
                padding: const .symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.priorityColor.withValues(alpha: 0.2),
                  borderRadius: .circular(8),
                  border: .all(color: widget.priorityColor),
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
  String date;
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

  KanbanColumnData copyWith({
    String? id,
    String? title,
    List<KanbanTask>? tasks,
  }) {
    return KanbanColumnData(
      id: id ?? this.id,
      title: title ?? this.title,
      tasks: tasks ?? this.tasks,
    );
  }
}
