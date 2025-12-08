import 'package:shadcn_flutter/shadcn_flutter.dart';

// Add functionality

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => ToDoScreenState();
}

class ToDoScreenState extends State<ToDoScreen> {
  CheckboxState _state = CheckboxState.unchecked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: const TextField(
                    placeholder: Text("What needs to be done?"),
                  ),
                ),
                PrimaryButton(
                  onPressed: () {},
                  leading: const Icon(LucideIcons.plus),
                  child: const Text("Add Task"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    PrimaryBadge(
                      child: Row(
                        spacing: 8,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: .circular(50),
                            ),
                          ),
                          const Text("0 Active"),
                        ],
                      ),
                    ),
                    PrimaryBadge(
                      child: Row(
                        spacing: 8,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: .circular(50),
                            ),
                          ),
                          const Text("0 Completed"),
                        ],
                      ),
                    ),
                    PrimaryBadge(
                      child: Row(
                        spacing: 8,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.gray,
                              borderRadius: .circular(50),
                            ),
                          ),
                          const Text("0 Total"),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ButtonGroup(
                  children: [
                    OutlineButton(onPressed: () {}, child: const Text("All")),
                    OutlineButton(
                      onPressed: () {},
                      child: const Text("Active"),
                    ),
                    OutlineButton(
                      onPressed: () {},
                      child: const Text("Completed"),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Column(
                  children: [
                    const Text(
                      "No tasks yet. Add your first task above!",
                    ).semiBold().large(),
                    const SizedBox(height: 8),
                    const Text(
                      "Start by adding a tasks to get organized.",
                    ).muted().small(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Example Task
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Row(
                  spacing: 8,
                  crossAxisAlignment: .start,
                  children: [
                    Checkbox(
                      state: _state,
                      onChanged: (value) {
                        setState(() {
                          _state = value;
                        });
                      },
                    ),
                    Column(
                      children: [
                        const Text("New Task").semiBold(),
                        const SizedBox(height: 8),
                        const Text("4/12/2025").muted().small(),
                      ],
                    ),
                    const Spacer(),
                    IconButton.ghost(
                      onPressed: () {},
                      density: .iconDense,
                      icon: const Icon(LucideIcons.pencil),
                    ),
                    IconButton.ghost(
                      onPressed: () {},
                      density: .iconDense,
                      icon: const Icon(LucideIcons.trash2),
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
}
