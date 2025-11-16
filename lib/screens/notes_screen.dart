import 'package:shadcn_flutter/shadcn_flutter.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  final hasNotes = false;
  String? selectedCategory;
  String? selectedUpdate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flex(
            direction: Axis.horizontal,
            spacing: 8,
            children: [
              Expanded(
                child: TextField(
                  placeholder: const Text("Search Notes..."),
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
              SecondaryButton(
                onPressed: () {},
                leading: const Icon(LucideIcons.plus),
                child: const Text("New Note"),
              ),
              Builder(
                builder: (context) {
                  return OutlineButton(
                    leading: const Icon(LucideIcons.download),
                    child: const Text("Export"),
                    onPressed: () {
                      showDropdown(
                        context: context,
                        builder: (context) {
                          return DropdownMenu(
                            children: [
                              MenuButton(
                                onPressed: (_) {},
                                child: Text("Export as JSON"),
                              ),
                              MenuButton(
                                onPressed: (_) {},
                                child: Text("Export as Text"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
              OutlineButton(
                // Todo:
                // Add logic to open up filters card(?)
                onPressed: () {},
                leading: const Icon(LucideIcons.filter),
                child: const Text("Filters"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 8,
                children: [
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
                        selectedCategory = value;
                      });
                    },
                    value: selectedCategory,
                    placeholder: const Text("All Categories"),
                    popup: const SelectPopup(
                      items: SelectItemList(
                        children: [
                          SelectItemButton(
                            value: "personal",
                            child: Text("Personal"),
                          ),
                          SelectItemButton(value: "work", child: Text("Work")),
                          SelectItemButton(
                            value: "ideas",
                            child: Text("Ideas"),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                        selectedUpdate = value;
                      });
                    },
                    value: selectedUpdate,
                    placeholder: const Text("Recently Updated"),
                    popup: const SelectPopup(
                      items: SelectItemList(
                        children: [
                          SelectItemButton(
                            value: "recently_updated",
                            child: Text("Recently Updated"),
                          ),
                          SelectItemButton(
                            value: "recently_created",
                            child: Text("Recently Created"),
                          ),
                          SelectItemButton(
                            value: "titleAZ",
                            child: Text("Title (A-Z)"),
                          ),
                          SelectItemButton(
                            value: "category",
                            child: Text("Category"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: [
                  IconButton.outline(
                    density: ButtonDensity.icon,
                    onPressed: () {},
                    icon: const Icon(LucideIcons.grid3x3),
                  ),
                  IconButton.outline(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.list),
                  ),
                  OutlineButton(
                    onPressed: () {},
                    leading: const Icon(LucideIcons.plus),
                    child: const Text("Category"),
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!hasNotes)
                        Center(
                          child: Column(
                            children: [
                              const Text('No notes yet').semiBold(),
                              const SizedBox(height: 4),
                              const Text(
                                'Get started by creating your first invoice.',
                              ).muted().small(),
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
