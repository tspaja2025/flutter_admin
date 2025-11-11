import 'package:shadcn_flutter/shadcn_flutter.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => TodoScreenState();
}

class TodoScreenState extends State<TodoScreen> {
  CheckboxState _state = CheckboxState.unchecked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 8,
                  children: [
                    Expanded(
                      child: TextField(
                        placeholder: Text('Description of your project'),
                        features: [InputFeature.clear()],
                      ),
                    ),
                    PrimaryButton(child: const Text('Add'), onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 8,
                children: [
                  SecondaryBadge(child: const Text("0 Active")),
                  SecondaryBadge(child: const Text("0 Completed")),
                  SecondaryBadge(child: const Text("0 Total")),
                ],
              ),
              Wrap(
                spacing: 8,
                children: [
                  SecondaryButton(onPressed: () {}, child: const Text("All")),
                  OutlineButton(onPressed: () {}, child: const Text("Active")),
                  OutlineButton(
                    onPressed: () {},
                    child: const Text("Completed"),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Card(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'No tasks yet. Add your first task above!',
                      ).semiBold(),
                      const SizedBox(height: 4),
                      const Text(
                        'Start by adding a task to get organized',
                      ).muted().small(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Example Todo tasks
          Card(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Checkbox(
                  state: _state,
                  onChanged: (value) {
                    setState(() {
                      _state = value;
                    });
                  },
                ),
                const Text("Task Title"),
                const Spacer(),
                GhostButton(
                  density: ButtonDensity.icon,
                  onPressed: () {},
                  child: const Icon(LucideIcons.pencil),
                ),
                GhostButton(
                  density: ButtonDensity.icon,
                  onPressed: () {},
                  child: const Icon(LucideIcons.trash),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
