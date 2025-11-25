import 'package:shadcn_flutter/shadcn_flutter.dart';

class FileManagerScreen extends StatelessWidget {
  const FileManagerScreen({super.key});

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
              Breadcrumb(
                separator: Breadcrumb.arrowSeparator,
                children: [
                  TextButton(
                    onPressed: () {},
                    density: ButtonDensity.compact,
                    child: const Text("Home"),
                  ),
                  const MoreDots(),
                  TextButton(
                    onPressed: () {},
                    density: ButtonDensity.compact,
                    child: const Text("Folder Name"),
                  ),
                  const Text("Breadcrumb"),
                ],
              ),
              Expanded(
                child: TextField(
                  placeholder: const Text("Search files..."),
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
                ],
              ),
              SecondaryButton(
                onPressed: () {},
                leading: const Icon(LucideIcons.plus),
                child: const Text("New"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          SizedBox(
            width: 200,
            child: Card(
              padding: const .all(16),
              child: Column(
                children: [
                  Flex(
                    direction: .horizontal,
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Checkbox(
                        state: CheckboxState.unchecked,
                        onChanged: (_) {},
                      ),
                      IconButton.ghost(
                        onPressed: () {},
                        density: ButtonDensity.icon,
                        icon: const Icon(LucideIcons.ellipsis),
                      ),
                    ],
                  ),
                  const Icon(LucideIcons.folder),
                  const Text("Document").bold(),
                  const Text("Jan 15, 2025").muted().small(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
