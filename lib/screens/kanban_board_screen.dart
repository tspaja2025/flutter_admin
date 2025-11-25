import 'package:shadcn_flutter/shadcn_flutter.dart';

class KanbanBoardScreen extends StatelessWidget {
  const KanbanBoardScreen({super.key});

  final _titleKey = const TextFieldKey(#title);
  // final _descriptionKey = const TextFieldKey(#description);

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
              Expanded(
                child: TextField(
                  placeholder: const Text("Search Tasks..."),
                  features: [
                    InputFeature.leading(
                      StatedWidget.builder(
                        builder: (context, states) {
                          if (states.hovered) {
                            return const Icon(LucideIcons.search);
                          } else {
                            return const Icon(
                              LucideIcons.search,
                            ).iconMutedForeground();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              OutlineButton(
                onPressed: () {},
                density: ButtonDensity.icon,
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
              Expanded(
                child: Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Wrap(
                            spacing: 8,
                            children: [
                              const Text("To Do"),
                              PrimaryBadge(child: const Text("2")),
                            ],
                          ),
                          IconButton.ghost(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  final FormController controller =
                                      FormController();

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
                                              children: [
                                                FormField(
                                                  key: _titleKey,
                                                  label: const Text("Title"),
                                                  child: const TextField(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                      Card(
                        padding: const .all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                const Text("Design System Setup").small(),
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
                                                  leading: const Icon(
                                                    LucideIcons.pencil,
                                                  ),
                                                  child: const Text("Edit"),
                                                ),
                                                MenuButton(
                                                  onPressed: (_) {},
                                                  leading: const Icon(
                                                    LucideIcons.trash,
                                                  ),
                                                  child: const Text("Delete"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        LucideIcons.ellipsisVertical,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Create a comprehensive design system with colors, typography and components",
                            ).small(),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                const Text("19/11/2025").xSmall(),
                                DestructiveBadge(child: const Text("High")),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        padding: const .all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                const Text("API Integration").small(),
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
                                                  leading: const Icon(
                                                    LucideIcons.pencil,
                                                  ),
                                                  child: const Text("Edit"),
                                                ),
                                                MenuButton(
                                                  onPressed: (_) {},
                                                  leading: const Icon(
                                                    LucideIcons.trash,
                                                  ),
                                                  child: const Text("Delete"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        LucideIcons.ellipsisVertical,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Integrate with backgend APIs for data fetching",
                            ).small(),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                const Text("19/11/2025").xSmall(),
                                PrimaryBadge(child: const Text("medium")),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Wrap(
                            spacing: 8,
                            children: [
                              const Text("In Progress"),
                              PrimaryBadge(child: const Text("1")),
                            ],
                          ),
                          IconButton.ghost(
                            onPressed: () {},
                            density: ButtonDensity.icon,
                            icon: const Icon(LucideIcons.plus),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Card(
                        padding: const .all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                const Text("User Authentication").small(),
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
                                                  leading: const Icon(
                                                    LucideIcons.pencil,
                                                  ),
                                                  child: const Text("Edit"),
                                                ),
                                                MenuButton(
                                                  onPressed: (_) {},
                                                  leading: const Icon(
                                                    LucideIcons.trash,
                                                  ),
                                                  child: const Text("Delete"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        LucideIcons.ellipsisVertical,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Implement login and signup functionality",
                            ).small(),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                const Text("19/11/2025").xSmall(),
                                DestructiveBadge(child: const Text("High")),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Flex(
            direction: .horizontal,
            spacing: 16,
            children: [
              Expanded(
                child: Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Wrap(
                            spacing: 8,
                            children: [
                              const Text("Review"),
                              PrimaryBadge(child: const Text("1")),
                            ],
                          ),
                          IconButton.ghost(
                            onPressed: () {},
                            density: ButtonDensity.icon,
                            icon: const Icon(LucideIcons.plus),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Card(
                        padding: const .all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                const Text("Mobile Responsiveness").small(),
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
                                                  leading: const Icon(
                                                    LucideIcons.pencil,
                                                  ),
                                                  child: const Text("Edit"),
                                                ),
                                                MenuButton(
                                                  onPressed: (_) {},
                                                  leading: const Icon(
                                                    LucideIcons.trash,
                                                  ),
                                                  child: const Text("Delete"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        LucideIcons.ellipsisVertical,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Ensure the app works perfectly on mobile devices",
                            ).small(),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                const Text("19/11/2025").xSmall(),
                                DestructiveBadge(child: const Text("medium")),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Wrap(
                            spacing: 8,
                            children: [
                              const Text("Done"),
                              PrimaryBadge(child: const Text("1")),
                            ],
                          ),
                          IconButton.ghost(
                            onPressed: () {},
                            density: ButtonDensity.icon,
                            icon: const Icon(LucideIcons.plus),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Card(
                        padding: const .all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                const Text("Project Setup").small(),
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
                                                  leading: const Icon(
                                                    LucideIcons.pencil,
                                                  ),
                                                  child: const Text("Edit"),
                                                ),
                                                MenuButton(
                                                  onPressed: (_) {},
                                                  leading: const Icon(
                                                    LucideIcons.trash,
                                                  ),
                                                  child: const Text("Delete"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        LucideIcons.ellipsisVertical,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text("Initialize Flutter project").small(),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                const Text("19/11/2025").xSmall(),
                                DestructiveBadge(child: const Text("Low")),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
