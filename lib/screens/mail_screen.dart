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
      padding: const EdgeInsets.all(16),
      child: OutlinedContainer(
        child: Flex(
          direction: Axis.horizontal,
          children: [
            SizedBox(
              width: 256,
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
                  const Divider(),
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
            const VerticalDivider(),
            Flexible(
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
                  const Divider(),
                  EmailItem(
                    title: "Github",
                    subtitle: "[Repository] New pull request submitted",
                    content:
                        "A new pull request has been submitted to your repository...",
                  ),
                  const Divider(),
                  EmailItem(
                    title: "Marketing Team",
                    subtitle: "New Product Launch Campaign",
                    content:
                        "Exciting news! We're launching our new product...",
                  ),
                  const Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final String content;

  const EmailItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
  });

  @override
  State<EmailItem> createState() => EmailItemState();
}

class EmailItemState extends State<EmailItem> {
  @override
  Widget build(BuildContext context) {
    bool value = false;
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Toggle(
                  value: value,
                  onChanged: (v) {
                    setState(() {
                      value = v;
                    });
                  },
                  child: const Icon(LucideIcons.star),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title).semiBold(),
                    Gap(4),
                    Text(widget.subtitle),
                    Gap(4),
                    Text(widget.content).muted().small(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
