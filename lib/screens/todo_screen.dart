import "package:shadcn_flutter/shadcn_flutter.dart";

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => ToDoScreenState();
}

class ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _taskController = TextEditingController();
  List<Task> _tasks = [];
  TaskFilter _currentFilter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    // Initialize with some example tasks
    _tasks = [
      Task(
        id: "1",
        title: "Learn Flutter",
        description: "Complete shadcn_flutter tutorial",
        createdDate: DateTime(2025, 4, 10),
        isCompleted: true,
        completedDate: DateTime(2025, 4, 11),
      ),
      Task(
        id: "2",
        title: "Build ToDo App",
        description: "Add all required functionality",
        createdDate: DateTime(2025, 4, 11),
      ),
      Task(
        id: "3",
        title: "Write documentation",
        createdDate: DateTime(2025, 4, 12),
      ),
    ];
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    final taskText = _taskController.text.trim();
    if (taskText.isEmpty) return;

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: taskText,
    );

    setState(() {
      _tasks.add(newTask);
      _taskController.clear();
    });
  }

  void _toggleTaskCompletion(String taskId) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        final task = _tasks[taskIndex];
        _tasks[taskIndex] = task.copyWith(
          isCompleted: !task.isCompleted,
          completedDate: !task.isCompleted ? DateTime.now() : null,
        );
      }
    });
  }

  void _deleteTask(String taskId) {
    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
    });
  }

  void _editTask(String taskId) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    final task = _tasks[taskIndex];
    _taskController.text = task.title;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Task"),
        content: TextField(
          controller: _taskController,
          autofocus: true,
          placeholder: const Text("Enter task description"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _taskController.clear();
            },
            child: const Text("Cancel"),
          ),
          PrimaryButton(
            onPressed: () {
              final newTitle = _taskController.text.trim();
              if (newTitle.isNotEmpty) {
                setState(() {
                  _tasks[taskIndex] = task.copyWith(title: newTitle);
                });
              }
              Navigator.pop(context);
              _taskController.clear();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _setFilter(TaskFilter filter) {
    setState(() {
      _currentFilter = filter;
    });
  }

  List<Task> get _filteredTasks {
    switch (_currentFilter) {
      case TaskFilter.active:
        return _tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return _tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.all:
        return _tasks;
    }
  }

  int get _activeCount => _tasks.where((task) => !task.isCompleted).length;
  int get _completedCount => _tasks.where((task) => task.isCompleted).length;

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Task Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    placeholder: const Text("What needs to be done?"),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                PrimaryButton(
                  onPressed: _addTask,
                  leading: const Icon(Icons.add),
                  child: const Text("Add Task"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Statistics Badges
            Row(
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    OutlineBadge(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text("$_activeCount Active"),
                        ],
                      ),
                    ),
                    OutlineBadge(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text("$_completedCount Completed"),
                        ],
                      ),
                    ),
                    OutlineBadge(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.gray,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text("${_tasks.length} Total"),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ButtonGroup(
                  children: [
                    OutlineButton(
                      onPressed: () => _setFilter(TaskFilter.all),
                      child: const Text("All"),
                    ),
                    OutlineButton(
                      onPressed: () => _setFilter(TaskFilter.active),
                      child: const Text("Active"),
                    ),
                    OutlineButton(
                      onPressed: () => _setFilter(TaskFilter.completed),
                      child: const Text("Completed"),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Task List
            Expanded(
              child: _filteredTasks.isEmpty
                  ? Center(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "No tasks found",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _tasks.isEmpty
                                    ? "Start by adding a task to get organized."
                                    : "No ${_currentFilter.name} tasks.",
                                style: TextStyle(color: Colors.gray.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredTasks.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final task = _filteredTasks[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  state: task.isCompleted
                                      ? CheckboxState.checked
                                      : CheckboxState.unchecked,
                                  onChanged: (_) =>
                                      _toggleTaskCompletion(task.id),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          decoration: task.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          color: task.isCompleted
                                              ? Colors.gray
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        task.isCompleted
                                            ? "Completed: ${_formatDate(task.completedDate!)}"
                                            : "Created: ${_formatDate(task.createdDate)}",
                                        style: TextStyle(
                                          color: Colors.gray.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton.ghost(
                                  onPressed: () => _editTask(task.id),
                                  icon: const Icon(Icons.edit, size: 20),
                                ),
                                IconButton.ghost(
                                  onPressed: () => _deleteTask(task.id),
                                  icon: const Icon(Icons.delete, size: 20),
                                ),
                              ],
                            ),
                          ),
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

enum TaskFilter { all, active, completed }

class Task {
  final String id;
  String title;
  String? description;
  DateTime createdDate;
  bool isCompleted;
  DateTime? completedDate;

  Task({
    required this.id,
    required this.title,
    this.description,
    DateTime? createdDate,
    this.isCompleted = false,
    this.completedDate,
  }) : createdDate = createdDate ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdDate,
    bool? isCompleted,
    DateTime? completedDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}
