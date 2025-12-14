import "package:shadcn_flutter/shadcn_flutter.dart";

class MailScreen extends StatefulWidget {
  const MailScreen({super.key});

  @override
  State<MailScreen> createState() => MailScreenState();
}

class MailScreenState extends State<MailScreen> {
  int _selected = 0;
  bool emailView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Padding(
        padding: const .all(16),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 32,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).colorScheme.border,
                    ),
                    top: BorderSide(
                      color: Theme.of(context).colorScheme.border,
                    ),
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.border,
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: .circular(12),
                    bottomLeft: .circular(12),
                  ),
                ),
                child: NavigationSidebar(
                  index: _selected,
                  onSelected: (index) {
                    setState(() {
                      _selected = index;
                    });
                  },
                  children: [
                    NavigationItem(
                      onChanged: (_) {},
                      alignment: .center,
                      style: ButtonStyle.primary(),
                      child: const Text("Compose"),
                    ),
                    const NavigationDivider(),
                    _buildNavigationButton("Inbox", LucideIcons.inbox, true),
                    _buildNavigationButton("Starred", LucideIcons.star),
                    _buildNavigationButton("Sent", LucideIcons.send),
                    _buildNavigationButton("Drafts", LucideIcons.fileText),
                    _buildNavigationButton("Spam", LucideIcons.triangleAlert),
                    _buildNavigationButton("Trash", LucideIcons.trash2),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 342.4,
              height: MediaQuery.of(context).size.height - 32,
              child: OutlinedContainer(
                borderRadius: BorderRadius.only(
                  topRight: .circular(12),
                  bottomRight: .circular(12),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Wrap(
                      crossAxisAlignment: .start,
                      children: [
                        Padding(
                          padding: const .all(8),
                          child: TextField(
                            placeholder: const Text("Search mail..."),
                            features: [
                              InputFeature.leading(
                                StatedWidget.builder(
                                  builder: (context, states) {
                                    return const Icon(LucideIcons.search);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    const Divider(),
                    Padding(
                      padding: emailView ? const .all(0) : const .all(8),
                      child: Column(
                        children: [
                          if (emailView)
                            _buildEmailView()
                          else ...[
                            _buildEmailCard(
                              "Github",
                              "[Repository] New pull request submitted",
                              "A new pull request has been submitted to your repository.",
                            ),
                            const SizedBox(height: 8),
                            _buildEmailCard(
                              "Marketing Team",
                              "New Product Launch Campaign",
                              "Exciting news! We're launching our new product next week. Join us for the virtual launch event.",
                            ),
                            const SizedBox(height: 8),
                            _buildEmailCard(
                              "John Doe",
                              "Meeting Tomorrow",
                              "Just a reminder about our 10 AM meeting tomorrow to discuss the Q3 roadmap.",
                            ),
                            const SizedBox(height: 8),
                            _buildEmailCard(
                              "Sarah Wilson",
                              "Project Update",
                              "I've completed the initial designs for the new dashboard. Let me know when you're available to review.",
                            ),
                            const SizedBox(height: 8),
                            _buildEmailCard(
                              "System Admin",
                              "System Maintenance",
                              "Scheduled maintenance will occur this weekend from 2 AM to 4 AM.",
                            ),
                          ],
                        ],
                      ),
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

  NavigationBarItem _buildNavigationButton(
    String label,
    IconData icon, [
    bool isSelected = false,
  ]) {
    return NavigationItem(
      selected: isSelected,
      selectedStyle: ButtonStyle.primary(),
      label: Text(label),
      child: Icon(icon),
    );
  }

  Widget _buildEmailCard(String title, String subject, String content) {
    return CardButton(
      onPressed: () {
        setState(() {
          emailView = true;
        });
      },
      child: Row(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          IconButton.ghost(
            onPressed: () {},
            density: .iconDense,
            icon: const Icon(LucideIcons.star),
          ),
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(title).semiBold(),
              const SizedBox(height: 4),
              Text(subject),
              const SizedBox(height: 4),
              Text(content).muted().small(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmailView() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Container(
          padding: const .all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryForeground,
            border: Border(
              bottom: BorderSide(color: Theme.of(context).colorScheme.border),
            ),
          ),
          child: Row(
            spacing: 8,
            children: [
              IconButton.ghost(
                onPressed: () {
                  setState(() {
                    emailView = false;
                  });
                },
                icon: const Icon(LucideIcons.arrowLeft),
              ),
              const Text("Q4 Budget Review Meeting"),
              const Spacer(),
              IconButton.ghost(
                onPressed: () {},
                density: .iconDense,
                icon: const Icon(LucideIcons.star),
              ),
              IconButton.ghost(
                onPressed: () {},
                density: .iconDense,
                icon: const Icon(LucideIcons.archive),
              ),
              IconButton.ghost(
                onPressed: () {},
                density: .iconDense,
                icon: const Icon(LucideIcons.trash2),
              ),
            ],
          ),
        ),
        Padding(
          padding: const .all(8),
          child: Row(
            spacing: 8,
            children: [
              Avatar(
                initials: "Sarah Johnson",
                provider: const NetworkImage(
                  "https://avatars.githubusercontent.com/u/64018564?v=4",
                ),
              ),
              Column(
                crossAxisAlignment: .start,
                spacing: 4,
                children: [
                  const Text("Sarah Johnson").semiBold(),
                  const Text("sarah.johnson@company.com").muted().small(),
                  const Text("Dec 9, 2025 at 8:00 AM").muted().small(),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
        SizedBox(
          height: MediaQuery.of(context).size.height - 270.4,
          child: Padding(
            padding: const .all(8),
            child: Column(children: [const Text("lorem ipsum...")]),
          ),
        ),
        Container(
          padding: const .all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryForeground,
            border: Border(
              top: BorderSide(color: Theme.of(context).colorScheme.border),
            ),
          ),
          child: Row(
            spacing: 8,
            children: [
              PrimaryButton(
                onPressed: () {},
                density: .dense,
                leading: const Icon(LucideIcons.reply),
                child: const Text("Reply"),
              ),
              OutlineButton(
                onPressed: () {},
                density: .iconDense,
                leading: const Icon(LucideIcons.replyAll),
                child: const Text("Reply all"),
              ),
              OutlineButton(
                onPressed: () {},
                density: .iconDense,
                leading: const Icon(LucideIcons.forward),
                child: const Text("Forward"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
