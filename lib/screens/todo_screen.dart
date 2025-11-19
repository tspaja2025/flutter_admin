import 'package:shadcn_flutter/shadcn_flutter.dart';

enum TodoFilter { all, active, completed }

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => TodoScreenState();
}

class TodoScreenState extends State<TodoScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final TextEditingController _textEditingController = TextEditingController();
  List<Todo> _todos = [];
  TodoFilter _currentFilter = TodoFilter.all;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _addTodo() {
    final text = _textEditingController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _todos.add(Todo(id: DateTime.now().millisecondsSinceEpoch, title: text));
      _textEditingController.clear();
    });

    _listKey.currentState?.insertItem(0);
    FocusScope.of(context).unfocus();
  }

  void _toggleTodo(int id) {
    setState(() {
      _todos = _todos.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(isCompleted: !todo.isCompleted);
        }
        return todo;
      }).toList();
    });
  }

  void _deleteTodo(int index) {
    final removed = _todos[index];

    _listKey.currentState?.removeItem(
      index,
      (context, animation) =>
          _buildAnimatedItem(animation, removed, index, isRemoved: true),
      duration: const Duration(milliseconds: 200),
    );
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _updateTodo(int id, String newTitle) {
    if (newTitle.trim().isEmpty) {
      _deleteTodo(id);
      return;
    }

    setState(() {
      _todos = _todos.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(title: newTitle.trim());
        }
        return todo;
      }).toList();
    });
  }

  void _setFilter(TodoFilter filter) {
    setState(() {
      _currentFilter = filter;
    });
  }

  List<Todo> get _filteredTodos {
    switch (_currentFilter) {
      case TodoFilter.active:
        return _todos.where((todo) => !todo.isCompleted).toList();
      case TodoFilter.completed:
        return _todos.where((todo) => todo.isCompleted).toList();
      case TodoFilter.all:
        return _todos;
    }
  }

  int get _activeCount => _todos.where((todo) => !todo.isCompleted).length;
  int get _completedCount => _todos.where((todo) => todo.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTodos;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddTodoInput(controller: _textEditingController, onAdd: _addTodo),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TodoStatsRow(
                active: _activeCount,
                completed: _completedCount,
                total: _todos.length,
              ),
              TodoFilterRow(current: _currentFilter, onSelect: _setFilter),
            ],
          ),

          const SizedBox(height: 8),

          Expanded(child: _buildTodoList(filtered)),
        ],
      ),
    );
  }

  Widget _buildTodoList(List<Todo> filtered) {
    if (_todos.isEmpty) {
      return const EmptyStateCard(isEmpty: true);
    }

    if (filtered.isEmpty && _currentFilter != TodoFilter.all) {
      return const EmptyStateCard(isEmpty: false);
    }

    if (_currentFilter == TodoFilter.all) {
      return AnimatedList(
        key: _listKey,
        initialItemCount: _todos.length,
        itemBuilder: (context, index, animation) {
          final todo = _todos[index];
          return _buildAnimatedItem(animation, todo, index);
        },
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final todo = filtered[index];

        final realIndex = _todos.indexOf(todo);

        return _buildDismissible(todo, realIndex);
      },
    );
  }

  Widget _buildAnimatedItem(
    Animation<double> animation,
    Todo todo,
    int index, {
    bool isRemoved = false,
  }) {
    final slide = Tween<Offset>(
      begin: isRemoved ? const Offset(1, 0) : const Offset(-0.1, 0),
      end: Offset.zero,
    ).animate(animation);

    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: slide,
          child: _buildDismissible(todo, index),
        ),
      ),
    );
  }

  Widget _buildDismissible(Todo todo, int index) {
    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: Colors.red,
        child: const Icon(LucideIcons.trash, color: Colors.white),
      ),
      onDismissed: (_) => _deleteTodo(index),
      child: TodoItem(
        todo: todo,
        onToggle: () => _toggleTodo(todo.id),
        onDelete: () => _deleteTodo(index),
        onUpdate: (newText) => _updateTodo(todo.id, newText),
      ),
    );
  }
}

class AddTodoInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const AddTodoInput({
    super.key,
    required this.controller,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              placeholder: const Text("Add a new task"),
              features: const [InputFeature.clear()],
              onSubmitted: (_) => onAdd(),
            ),
          ),
          const SizedBox(width: 8),
          PrimaryButton(onPressed: onAdd, child: const Text("Add")),
        ],
      ),
    );
  }
}

class TodoStatsRow extends StatelessWidget {
  final int active;
  final int completed;
  final int total;

  const TodoStatsRow({
    super.key,
    required this.active,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        SecondaryBadge(child: Text("$active Active")),
        SecondaryBadge(child: Text("$completed Completed")),
        SecondaryBadge(child: Text("$total Total")),
      ],
    );
  }
}

class TodoFilterRow extends StatelessWidget {
  final TodoFilter current;
  final Function(TodoFilter) onSelect;

  const TodoFilterRow({
    super.key,
    required this.current,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    Widget button(String label, TodoFilter filter) {
      final bool selected = current == filter;

      return selected
          ? PrimaryButton(onPressed: () => onSelect(filter), child: Text(label))
          : OutlineButton(
              onPressed: () => onSelect(filter),
              child: Text(label),
            );
    }

    return Wrap(
      spacing: 8,
      children: [
        button("All", TodoFilter.all),
        button("Active", TodoFilter.active),
        button("Completed", TodoFilter.completed),
      ],
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  final bool isEmpty;

  const EmptyStateCard({super.key, required this.isEmpty});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isEmpty
                      ? "No Tasks yet. Add your first task above!"
                      : "No tasks match the current filter",
                ).semiBold(),
                const SizedBox(height: 8),
                Text(
                  isEmpty
                      ? "Start by adding a task to get organized"
                      : "Try changing the filter or mark some tasks as completed",
                ).muted().small(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TodoItem extends StatefulWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Function(String) onUpdate;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<TodoItem> createState() => TodoItemState();
}

class TodoItemState extends State<TodoItem> {
  final TextEditingController _editingController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _editingController.text = widget.todo.title;
  }

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveEdit() {
    widget.onUpdate(_editingController.text);
    setState(() {
      _isEditing = false;
    });
  }

  void _cancelEdit() {
    _editingController.text = widget.todo.title;
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(24),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SizeTransition(sizeFactor: animation, child: child),
          );
        },
        child: _isEditing ? _buildEditingMode() : _buildDisplayMode(),
      ),
    );
  }

  Widget _buildDisplayMode() {
    return Row(
      key: const ValueKey("display"),
      children: [
        Checkbox(
          state: widget.todo.isCompleted
              ? CheckboxState.checked
              : CheckboxState.unchecked,
          onChanged: (_) => widget.onToggle(),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            widget.todo.title,
            style: widget.todo.isCompleted
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
        ),
        GhostButton(
          density: ButtonDensity.icon,
          onPressed: _startEditing,
          child: const Icon(LucideIcons.pencil),
        ),
        GhostButton(
          density: ButtonDensity.icon,
          onPressed: widget.onDelete,
          child: const Icon(LucideIcons.trash),
        ),
      ],
    );
  }

  Widget _buildEditingMode() {
    return Row(
      key: const ValueKey("editing"),
      children: [
        const SizedBox(width: 44),
        Expanded(
          child: TextField(
            controller: _editingController,
            autofocus: true,
            onSubmitted: (_) => _saveEdit(),
          ),
        ),
        const SizedBox(width: 8),
        GhostButton(
          density: ButtonDensity.icon,
          onPressed: _saveEdit,
          child: const Icon(LucideIcons.check),
        ),
        GhostButton(
          density: ButtonDensity.icon,
          onPressed: _cancelEdit,
          child: const Icon(LucideIcons.x),
        ),
      ],
    );
  }
}

class Todo {
  final int id;
  final String title;
  bool isCompleted;

  Todo({required this.id, required this.title, this.isCompleted = false});

  Todo copyWith({int? id, String? title, bool? isCompleted}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
