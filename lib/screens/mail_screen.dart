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
        clipBehavior: Clip.antiAlias,
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 8,
                      children: [
                        GhostButton(
                          onPressed: () {},
                          leading: const Icon(LucideIcons.inbox),
                          alignment: AlignmentGeometry.centerLeft,
                          child: const Text("Inbox"),
                        ),
                        GhostButton(
                          onPressed: () {},
                          leading: const Icon(LucideIcons.star),
                          alignment: AlignmentGeometry.centerLeft,
                          child: const Text("Starred"),
                        ),
                        GhostButton(
                          onPressed: () {},
                          leading: const Icon(LucideIcons.send),
                          alignment: AlignmentGeometry.centerLeft,
                          child: const Text("Sent"),
                        ),
                        GhostButton(
                          onPressed: () {},
                          leading: const Icon(LucideIcons.fileText),
                          alignment: AlignmentGeometry.centerLeft,
                          child: const Text("Drafts"),
                        ),
                        GhostButton(
                          onPressed: () {},
                          leading: const Icon(LucideIcons.triangleAlert),
                          alignment: AlignmentGeometry.centerLeft,
                          child: const Text("Spam"),
                        ),
                        GhostButton(
                          onPressed: () {},
                          leading: const Icon(LucideIcons.trash),
                          alignment: AlignmentGeometry.centerLeft,
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
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
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
