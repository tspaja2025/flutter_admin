import 'package:shadcn_flutter/shadcn_flutter.dart';

class MailScreen extends StatefulWidget {
  const MailScreen({super.key});

  @override
  State<MailScreen> createState() => MailScreenState();
}

class MailScreenState extends State<MailScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: OutlinedContainer(
        clipBehavior: .antiAlias,
        child: ResizablePanel.horizontal(
          draggerBuilder: (context) {
            return const HorizontalResizableDragger();
          },
          children: [
            ResizablePane(
              initialSize: 200,
              minSize: 160,
              maxSize: 200,
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: SecondaryButton(
                      onPressed: () {},
                      child: const Text("Compose"),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const .all(16),
                    child: Column(
                      crossAxisAlignment: .stretch,
                      spacing: 8,
                      children: [
                        GhostButton(
                          onPressed: () {},
                          leading: const Icon(LucideIcons.inbox),
                          alignment: .centerLeft,
                          child: const Text("Inbox"),
                        ),
                        GhostButton(
                          onPressed: () {},
                          leading: const Icon(LucideIcons.star),
                          alignment: .centerLeft,
                          child: const Text("Starred"),
                        ),
                        GhostButton(
                          onPressed: () {},
                          leading: const Icon(LucideIcons.send),
                          alignment: .centerLeft,
                          child: const Text("Sent"),
                        ),
                        GhostButton(
                          onPressed: () {},
                          leading: const Icon(LucideIcons.fileText),
                          alignment: .centerLeft,
                          child: const Text("Drafts"),
                        ),
                        GhostButton(
                          onPressed: () {},
                          leading: const Icon(LucideIcons.triangleAlert),
                          alignment: .centerLeft,
                          child: const Text("Spam"),
                        ),
                        GhostButton(
                          onPressed: () {},
                          leading: const Icon(LucideIcons.trash),
                          alignment: .centerLeft,
                          child: const Text("Trash"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ResizablePane(
              initialSize: 750,
              minSize: 160,
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Padding(
                    padding: const .all(15),
                    child: TextField(
                      placeholder: const Text("Search Mail..."),
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
                  Divider(),
                  Padding(
                    padding: const .all(16),
                    child: Column(
                      crossAxisAlignment: .stretch,
                      spacing: 8,
                      children: [],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
