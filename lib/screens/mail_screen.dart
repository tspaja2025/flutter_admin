import "package:shadcn_flutter/shadcn_flutter.dart";

class MailScreen extends StatefulWidget {
  const MailScreen({super.key});

  @override
  State<MailScreen> createState() => MailScreenState();
}

class MailScreenState extends State<MailScreen> {
  int _selected = 0;
  bool emailView = false;
  Email? _selectedEmail;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Sample email data
  final List<Email> _emails = [
    Email(
      sender: "Github",
      subject: "[Repository] New pull request submitted",
      content:
          "A new pull request has been submitted to your repository. Please review the changes when you have a moment. The changes include bug fixes and new features for the authentication module.",
      date: DateTime.now().subtract(const Duration(hours: 2)),
      senderEmail: "notifications@github.com",
      isStarred: true,
    ),
    Email(
      sender: "Marketing Team",
      subject: "New Product Launch Campaign",
      content:
          "Exciting news! We're launching our new product next week. Join us for the virtual launch event. We have special guests and exciting announcements planned.",
      date: DateTime.now().subtract(const Duration(days: 1)),
      senderEmail: "marketing@company.com",
    ),
    Email(
      sender: "John Doe",
      subject: "Meeting Tomorrow",
      content:
          "Just a reminder about our 10 AM meeting tomorrow to discuss the Q3 roadmap. Please come prepared with your department's goals and KPIs.",
      date: DateTime.now().subtract(const Duration(days: 1)),
      senderEmail: "john.doe@company.com",
      isRead: true,
    ),
    Email(
      sender: "Sarah Wilson",
      subject: "Project Update",
      content:
          "I've completed the initial designs for the new dashboard. Let me know when you're available to review. I've included both light and dark mode versions.",
      date: DateTime.now().subtract(const Duration(days: 2)),
      senderEmail: "sarah.wilson@company.com",
      isStarred: true,
    ),
    Email(
      sender: "System Admin",
      subject: "System Maintenance",
      content:
          "Scheduled maintenance will occur this weekend from 2 AM to 4 AM. During this time, some services may be temporarily unavailable.",
      date: DateTime.now().subtract(const Duration(days: 3)),
      senderEmail: "admin@company.com",
      isRead: true,
    ),
  ];

  List<Email> get _filteredEmails {
    if (_selected == 0) return _emails; // Inbox
    if (_selected == 1) {
      return _emails.where((email) => email.isStarred).toList();
    } // Starred
    // Add more filters for other navigation items
    return _emails;
  }

  void _showNewEmailDialog() {
    _toController.clear();
    _subjectController.clear();
    _messageController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Email"),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormField(
                  key: FormKey(#to),
                  label: const Text("To"),
                  child: TextField(
                    controller: _toController,
                    placeholder: const Text("recipient@example.com"),
                  ),
                ),
                const SizedBox(height: 8),
                FormField(
                  key: FormKey(#subject),
                  label: const Text("Subject"),
                  child: TextField(
                    controller: _subjectController,
                    placeholder: const Text("Subject"),
                  ),
                ),
                const SizedBox(height: 8),
                FormField(
                  key: FormKey(#message),
                  label: const Text("Message"),
                  child: TextArea(
                    controller: _messageController,
                    placeholder: const Text("Write your message..."),
                    minLines: 5,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Button.outline(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            IconButton.outline(
              onPressed: () {
                // Add attachment functionality
                showToast(
                  context: context,
                  builder: (context, overlay) {
                    return SurfaceCard(
                      child: Basic(
                        content: const Text("Attachment feature coming soon!"),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(LucideIcons.paperclip),
            ),
            PrimaryButton(
              onPressed: () {
                if (_toController.text.isEmpty ||
                    _subjectController.text.isEmpty) {
                  showToast(
                    context: context,
                    builder: (context, overlay) {
                      return SurfaceCard(
                        child: Basic(
                          content: const Text(
                            "Please fill in all required fields",
                          ),
                        ),
                      );
                    },
                  );
                  return;
                }

                // Add the new email to sent items
                final newEmail = Email(
                  sender: "Me",
                  subject: _subjectController.text,
                  content: _messageController.text,
                  date: DateTime.now(),
                  senderEmail: "me@example.com",
                );

                // In a real app, you would send the email here
                showToast(
                  context: context,
                  builder: (context, overlay) {
                    return SurfaceCard(
                      child: Basic(
                        content: Text("Email sent to ${_toController.text}"),
                      ),
                    );
                  },
                );

                Navigator.pop(context);
              },
              leading: const Icon(LucideIcons.send),
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }

  void _toggleStar(Email email) {
    setState(() {
      final index = _emails.indexWhere((e) => e == email);
      if (index != -1) {
        _emails[index] = Email(
          sender: email.sender,
          subject: email.subject,
          content: email.content,
          date: email.date,
          senderEmail: email.senderEmail,
          isStarred: !email.isStarred,
          isRead: email.isRead,
        );
      }
    });
  }

  void _deleteEmail(Email email) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Email"),
          content: const Text("Are you sure you want to delete this email?"),
          actions: [
            Button.outline(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            PrimaryButton(
              onPressed: () {
                setState(() {
                  _emails.remove(email);
                  emailView = false;
                  _selectedEmail = null;
                });
                Navigator.pop(context);
                showToast(
                  context: context,
                  builder: (context, overlay) {
                    return SurfaceCard(
                      child: Basic(content: Text("Email moved to trash")),
                    );
                  },
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date, {bool includeTime = false}) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return includeTime ? 'Today at ${_formatTime(date)}' : 'Today';
    } else if (difference.inDays == 1) {
      return includeTime ? 'Yesterday at ${_formatTime(date)}' : 'Yesterday';
    } else if (difference.inDays < 7) {
      return includeTime
          ? '${difference.inDays} days ago at ${_formatTime(date)}'
          : '${difference.inDays} days ago';
    } else {
      return includeTime
          ? '${date.day}/${date.month}/${date.year} at ${_formatTime(date)}'
          : '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _toController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: NavigationSidebar(
                  index: _selected,
                  onSelected: (index) {
                    setState(() {
                      _selected = index;
                      emailView = false;
                      _selectedEmail = null;
                    });
                  },
                  children: [
                    NavigationItem(
                      onChanged: (_) => _showNewEmailDialog(),
                      alignment: Alignment.center,
                      style: ButtonStyle.primary(),
                      child: const Text("Compose"),
                    ),
                    const NavigationDivider(),
                    _buildNavigationButton(
                      "Inbox",
                      LucideIcons.inbox,
                      _selected == 1,
                    ),
                    _buildNavigationButton(
                      "Starred",
                      LucideIcons.star,
                      _selected == 2,
                    ),
                    _buildNavigationButton(
                      "Sent",
                      LucideIcons.send,
                      _selected == 3,
                    ),
                    _buildNavigationButton(
                      "Drafts",
                      LucideIcons.fileText,
                      _selected == 4,
                    ),
                    _buildNavigationButton(
                      "Spam",
                      LucideIcons.triangleAlert,
                      _selected == 5,
                    ),
                    _buildNavigationButton(
                      "Trash",
                      LucideIcons.trash2,
                      _selected == 6,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 342.4,
              height: MediaQuery.of(context).size.height - 32,
              child: OutlinedContainer(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: _searchController,
                        placeholder: const Text("Search mail..."),
                        onChanged: (value) {
                          setState(() {});
                        },
                        features: [
                          InputFeature.leading(const Icon(LucideIcons.search)),
                          if (_searchController.text.isNotEmpty)
                            InputFeature.trailing(
                              IconButton.ghost(
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                  });
                                },
                                density: .iconDense,
                                icon: const Icon(LucideIcons.x),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 1),
                    const Divider(),
                    Expanded(
                      child: Padding(
                        padding: emailView
                            ? EdgeInsets.zero
                            : const EdgeInsets.all(8),
                        child: _searchController.text.isNotEmpty
                            ? _buildSearchResults()
                            : Column(
                                children: [
                                  if (emailView && _selectedEmail != null)
                                    Expanded(child: _buildEmailView())
                                  else ...[
                                    Expanded(
                                      child: ListView.separated(
                                        itemCount: _filteredEmails.length,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 8),
                                        itemBuilder: (context, index) {
                                          final email = _filteredEmails[index];
                                          return _buildEmailCard(email);
                                        },
                                      ),
                                    ),
                                  ],
                                ],
                              ),
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
    IconData icon,
    bool isSelected,
  ) {
    return NavigationItem(
      selected: isSelected,
      selectedStyle: ButtonStyle.primary(),
      label: Text(label),
      child: Icon(icon),
    );
  }

  Widget _buildEmailCard(Email email) {
    return CardButton(
      onPressed: () {
        setState(() {
          emailView = true;
          _selectedEmail = email;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton.ghost(
            onPressed: () => _toggleStar(email),
            density: .iconDense,
            icon: Icon(
              email.isStarred ? LucideIcons.star : LucideIcons.star,
              color: email.isStarred ? Colors.yellow.shade600 : null,
              fill: email.isStarred ? 1.0 : 0.0,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(email.sender).semiBold(),
                    if (!email.isRead)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(email.subject),
                const SizedBox(height: 4),
                Text(
                  email.content.length > 100
                      ? '${email.content.substring(0, 100)}...'
                      : email.content,
                ).muted().small(),
                const SizedBox(height: 4),
                Text(_formatDate(email.date)).muted().xSmall(),
              ],
            ),
          ),
          IconButton.ghost(
            onPressed: () => _deleteEmail(email),
            density: .iconDense,
            icon: const Icon(LucideIcons.trash2),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailView() {
    if (_selectedEmail == null) {
      return const Center(child: Text("No email selected"));
    }

    final email = _selectedEmail!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryForeground,
            border: Border(
              bottom: BorderSide(color: Theme.of(context).colorScheme.border),
            ),
          ),
          child: Row(
            children: [
              IconButton.ghost(
                onPressed: () {
                  setState(() {
                    emailView = false;
                  });
                },
                icon: const Icon(LucideIcons.arrowLeft),
              ),
              Text(email.subject).semiBold(),
              const Spacer(),
              IconButton.ghost(
                onPressed: () => _toggleStar(email),
                density: .iconDense,
                icon: Icon(
                  email.isStarred ? LucideIcons.star : LucideIcons.star,
                  color: email.isStarred ? Colors.yellow.shade600 : null,
                  fill: email.isStarred ? 1.0 : 0.0,
                ),
              ),
              IconButton.ghost(
                onPressed: () {
                  showToast(
                    context: context,
                    builder: (context, overlay) {
                      return SurfaceCard(
                        child: Basic(content: Text("Archived")),
                      );
                    },
                  );
                },
                density: .iconDense,
                icon: const Icon(LucideIcons.archive),
              ),
              IconButton.ghost(
                onPressed: () => _deleteEmail(email),
                density: .iconDense,
                icon: const Icon(LucideIcons.trash2),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Avatar(
                initials: email.sender,
                provider: const NetworkImage(
                  "https://avatars.githubusercontent.com/u/64018564?v=4",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(email.sender).semiBold(),
                        const SizedBox(width: 8),
                        Text(email.senderEmail).muted().small(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(email.date, includeTime: true),
                    ).muted().small(),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(email.content)],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryForeground,
            border: Border(
              top: BorderSide(color: Theme.of(context).colorScheme.border),
            ),
          ),
          child: Row(
            children: [
              PrimaryButton(
                onPressed: () {
                  _toController.text = email.senderEmail;
                  _subjectController.text = "Re: ${email.subject}";
                  _showNewEmailDialog();
                },
                density: .dense,
                leading: const Icon(LucideIcons.reply),
                child: const Text("Reply"),
              ),
              const SizedBox(width: 8),
              OutlineButton(
                onPressed: () {
                  _subjectController.text = "Re: ${email.subject}";
                  _showNewEmailDialog();
                },
                density: .dense,
                leading: const Icon(LucideIcons.replyAll),
                child: const Text("Reply all"),
              ),
              const SizedBox(width: 8),
              OutlineButton(
                onPressed: () {
                  _subjectController.text = "Fwd: ${email.subject}";
                  _messageController.text =
                      "\n\n---------- Forwarded message ----------\nFrom: ${email.sender}\nDate: ${_formatDate(email.date, includeTime: true)}\nSubject: ${email.subject}\n\n${email.content}";
                  _showNewEmailDialog();
                },
                density: .dense,
                leading: const Icon(LucideIcons.forward),
                child: const Text("Forward"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    final query = _searchController.text.toLowerCase();
    final results = _emails.where((email) {
      return email.sender.toLowerCase().contains(query) ||
          email.subject.toLowerCase().contains(query) ||
          email.content.toLowerCase().contains(query);
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.search, size: 48, color: Colors.gray.shade400),
            const SizedBox(height: 16),
            Text("No results found for '$query'").muted(),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final email = results[index];
        return _buildEmailCard(email);
      },
    );
  }
}

class Email {
  final String sender;
  final String subject;
  final String content;
  final DateTime date;
  final String senderEmail;
  final bool isStarred;
  final bool isRead;

  Email({
    required this.sender,
    required this.subject,
    required this.content,
    required this.date,
    required this.senderEmail,
    this.isStarred = false,
    this.isRead = false,
  });
}
