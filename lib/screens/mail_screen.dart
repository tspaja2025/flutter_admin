import 'package:shadcn_flutter/shadcn_flutter.dart';

class MailScreen extends StatefulWidget {
  const MailScreen({super.key});

  @override
  State<MailScreen> createState() => MailScreenState();
}

class MailScreenState extends State<MailScreen> {
  int _selected = 0;

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
                      padding: const .all(8),
                      child: Column(
                        children: [
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
    return SizedBox(
      width: double.infinity,
      child: Card(
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
      ),
    );
  }
}

// Old to be removed
// import 'package:shadcn_flutter/shadcn_flutter.dart';

// class Email {
//   final String id;
//   final String sender;
//   final String subject;
//   final String content;
//   final DateTime date;
//   bool isStarred;
//   bool isRead;
//   final String category;

//   Email({
//     required this.id,
//     required this.sender,
//     required this.subject,
//     required this.content,
//     required this.date,
//     this.isStarred = false,
//     this.isRead = false,
//     required this.category,
//   });
// }

// class EmailNavigationItem {
//   final String id;
//   final String title;
//   final IconData icon;
//   final int count;

//   EmailNavigationItem({
//     required this.id,
//     required this.title,
//     required this.icon,
//     required this.count,
//   });
// }

// class MailScreen extends StatefulWidget {
//   const MailScreen({super.key});

//   @override
//   State<MailScreen> createState() => MailScreenState();
// }

// class MailScreenState extends State<MailScreen> {
//   // Email data
//   final List<Email> emails = [
//     Email(
//       id: '1',
//       sender: 'Github',
//       subject: '[Repository] New pull request submitted',
//       content:
//           'A new pull request has been submitted to your repository. Please review it when you have a moment.',
//       date: DateTime.now().subtract(const Duration(minutes: 30)),
//       isStarred: false,
//       isRead: true,
//       category: 'inbox',
//     ),
//     Email(
//       id: '2',
//       sender: 'Marketing Team',
//       subject: 'New Product Launch Campaign',
//       content:
//           'Exciting news! We\'re launching our new product next week. Join us for the virtual launch event.',
//       date: DateTime.now().subtract(const Duration(hours: 2)),
//       isStarred: true,
//       isRead: false,
//       category: 'inbox',
//     ),
//     Email(
//       id: '3',
//       sender: 'John Doe',
//       subject: 'Meeting Tomorrow',
//       content:
//           'Just a reminder about our 10 AM meeting tomorrow to discuss the Q3 roadmap.',
//       date: DateTime.now().subtract(const Duration(hours: 5)),
//       isStarred: false,
//       isRead: true,
//       category: 'inbox',
//     ),
//     Email(
//       id: '4',
//       sender: 'Sarah Wilson',
//       subject: 'Project Update',
//       content:
//           'I\'ve completed the initial designs for the new dashboard. Let me know when you\'re available to review.',
//       date: DateTime.now().subtract(const Duration(days: 1)),
//       isStarred: false,
//       isRead: false,
//       category: 'inbox',
//     ),
//     Email(
//       id: '5',
//       sender: 'System Admin',
//       subject: 'System Maintenance',
//       content:
//           'Scheduled maintenance will occur this weekend from 2 AM to 4 AM.',
//       date: DateTime.now().subtract(const Duration(days: 2)),
//       isStarred: false,
//       isRead: true,
//       category: 'inbox',
//     ),
//   ];

//   // Navigation
//   final List<EmailNavigationItem> navItems = [
//     EmailNavigationItem(
//       id: 'inbox',
//       title: 'Inbox',
//       icon: LucideIcons.inbox,
//       count: 5,
//     ),
//     EmailNavigationItem(
//       id: 'starred',
//       title: 'Starred',
//       icon: LucideIcons.star,
//       count: 1,
//     ),
//     EmailNavigationItem(
//       id: 'sent',
//       title: 'Sent',
//       icon: LucideIcons.send,
//       count: 0,
//     ),
//     EmailNavigationItem(
//       id: 'drafts',
//       title: 'Drafts',
//       icon: LucideIcons.fileText,
//       count: 2,
//     ),
//     EmailNavigationItem(
//       id: 'spam',
//       title: 'Spam',
//       icon: LucideIcons.triangleAlert,
//       count: 0,
//     ),
//     EmailNavigationItem(
//       id: 'trash',
//       title: 'Trash',
//       icon: LucideIcons.trash,
//       count: 0,
//     ),
//   ];

//   String selectedCategory = 'inbox';
//   String searchQuery = '';

//   List<Email> get filteredEmails {
//     return emails.where((email) {
//       final matchesCategory = email.category == selectedCategory;
//       final matchesSearch =
//           searchQuery.isEmpty ||
//           email.sender.toLowerCase().contains(searchQuery.toLowerCase()) ||
//           email.subject.toLowerCase().contains(searchQuery.toLowerCase()) ||
//           email.content.toLowerCase().contains(searchQuery.toLowerCase());

//       if (selectedCategory == 'starred') {
//         return email.isStarred && matchesSearch;
//       }

//       return matchesCategory && matchesSearch;
//     }).toList();
//   }

//   void toggleStar(String emailId) {
//     setState(() {
//       final email = emails.firstWhere((e) => e.id == emailId);
//       email.isStarred = !email.isStarred;
//     });
//   }

//   void markAsRead(String emailId) {
//     setState(() {
//       final email = emails.firstWhere((e) => e.id == emailId);
//       email.isRead = true;
//     });
//   }

//   void deleteEmail(String emailId) {
//     setState(() {
//       emails.removeWhere((e) => e.id == emailId);
//     });
//   }

//   void selectCategory(String category) {
//     setState(() {
//       selectedCategory = category;
//     });
//   }

//   void onSearchChanged(String query) {
//     setState(() {
//       searchQuery = query;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: OutlinedContainer(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Navigation sidebar
//             SizedBox(
//               width: 256,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: SecondaryButton(
//                       onPressed: () {
//                         // Add compose functionality here
//                         showDialog(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: const Text('Compose Email'),
//                             content: const Text(
//                               'Email composer would open here.',
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: const Text('OK'),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                       child: const Text("Compose"),
//                     ),
//                   ),
//                   const Divider(),
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         for (final item in navItems)
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 8),
//                             child: GhostButton(
//                               onPressed: () => selectCategory(item.id),
//                               leading: Icon(item.icon),
//                               alignment: Alignment.centerLeft,
//                               // style: selectedCategory == item.id
//                               //     ? const ButtonStyle(
//                               //         backgroundColor: ButtonState.all(
//                               //           Color.fromRGBO(240, 249, 255, 1),
//                               //         ),
//                               //         foregroundColor: ButtonState.all(
//                               //           Color.fromRGBO(2, 132, 199, 1),
//                               //         ),
//                               //       )
//                               //     : null,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(item.title),
//                                   if (item.count > 0)
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 8,
//                                         vertical: 2,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: selectedCategory == item.id
//                                             ? const Color.fromRGBO(
//                                                 2,
//                                                 132,
//                                                 199,
//                                                 0.1,
//                                               )
//                                             : const Color.fromRGBO(
//                                                 100,
//                                                 116,
//                                                 139,
//                                                 0.1,
//                                               ),
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: Text(
//                                         item.count.toString(),
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: selectedCategory == item.id
//                                               ? const Color.fromRGBO(
//                                                   2,
//                                                   132,
//                                                   199,
//                                                   1,
//                                                 )
//                                               : const Color.fromRGBO(
//                                                   100,
//                                                   116,
//                                                   139,
//                                                   1,
//                                                 ),
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const VerticalDivider(),
//             // Email list
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Search bar
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: TextField(
//                       placeholder: const Text("Search Mail..."),
//                       onChanged: onSearchChanged,
//                       features: [
//                         InputFeature.leading(
//                           StatedWidget.builder(
//                             builder: (context, states) {
//                               return Icon(
//                                 LucideIcons.search,
//                                 color: states.hovered
//                                     ? null
//                                     : Colors.gray.shade500,
//                               );
//                             },
//                           ),
//                         ),
//                         if (searchQuery.isNotEmpty)
//                           InputFeature.trailing(
//                             IconButton.ghost(
//                               icon: const Icon(LucideIcons.x),
//                               onPressed: () => onSearchChanged(''),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                   const Divider(),
//                   // Email list
//                   Expanded(
//                     child: filteredEmails.isEmpty
//                         ? const Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   LucideIcons.inbox,
//                                   size: 64,
//                                   color: Colors.gray,
//                                 ),
//                                 SizedBox(height: 16),
//                                 Text(
//                                   'No emails found',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.gray,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : ListView.separated(
//                             itemCount: filteredEmails.length,
//                             separatorBuilder: (context, index) =>
//                                 const Divider(),
//                             itemBuilder: (context, index) {
//                               final email = filteredEmails[index];
//                               return EmailItem(
//                                 email: email,
//                                 onStarToggled: () => toggleStar(email.id),
//                                 onEmailTapped: () => markAsRead(email.id),
//                                 onDelete: () => deleteEmail(email.id),
//                               );
//                             },
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class EmailItem extends StatelessWidget {
//   final Email email;
//   final VoidCallback onStarToggled;
//   final VoidCallback onEmailTapped;
//   final VoidCallback onDelete;

//   const EmailItem({
//     super.key,
//     required this.email,
//     required this.onStarToggled,
//     required this.onEmailTapped,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onEmailTapped,
//       child: Container(
//         color: email.isRead ? Colors.transparent : Colors.blue.shade50,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Star toggle
//               Toggle(
//                 value: email.isStarred,
//                 onChanged: (_) => onStarToggled(),
//                 child: Icon(
//                   LucideIcons.star,
//                   fill: email.isStarred ? 1.0 : 0.0,
//                   color: email.isStarred ? Colors.amber : Colors.gray,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // Sender avatar
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: _getAvatarColor(email.sender),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Center(
//                   child: Text(
//                     email.sender.substring(0, 1).toUpperCase(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // Email content
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             email.sender,
//                             style: TextStyle(
//                               fontWeight: email.isRead
//                                   ? FontWeight.normal
//                                   : FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                         Text(
//                           _formatDate(email.date),
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.gray,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       email.subject,
//                       style: TextStyle(
//                         fontWeight: email.isRead
//                             ? FontWeight.normal
//                             : FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       email.content,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(fontSize: 13, color: Colors.gray),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // Actions
//               // PopupMenuButton(
//               //   itemBuilder: (context) => [
//               //     const PopupMenuItem(
//               //       value: 'reply',
//               //       child: Row(
//               //         children: [
//               //           Icon(LucideIcons.reply, size: 16),
//               //           SizedBox(width: 8),
//               //           Text('Reply'),
//               //         ],
//               //       ),
//               //     ),
//               //     const PopupMenuItem(
//               //       value: 'forward',
//               //       child: Row(
//               //         children: [
//               //           Icon(LucideIcons.forward, size: 16),
//               //           SizedBox(width: 8),
//               //           Text('Forward'),
//               //         ],
//               //       ),
//               //     ),
//               //     const PopupMenuItem(
//               //       value: 'archive',
//               //       child: Row(
//               //         children: [
//               //           Icon(LucideIcons.archive, size: 16),
//               //           SizedBox(width: 8),
//               //           Text('Archive'),
//               //         ],
//               //       ),
//               //     ),
//               //     const PopupMenuItem(
//               //       value: 'delete',
//               //       child: Row(
//               //         children: [
//               //           Icon(LucideIcons.trash, size: 16, color: Colors.red),
//               //           SizedBox(width: 8),
//               //           Text('Delete', style: TextStyle(color: Colors.red)),
//               //         ],
//               //       ),
//               //     ),
//               //   ],
//               //   onSelected: (value) {
//               //     if (value == 'delete') {
//               //       onDelete();
//               //     }
//               //   },
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getAvatarColor(String sender) {
//     final colors = [
//       Colors.blue,
//       Colors.green,
//       Colors.orange,
//       Colors.purple,
//       Colors.red,
//       Colors.teal,
//     ];
//     final index = sender.codeUnits.fold(0, (a, b) => a + b) % colors.length;
//     return colors[index];
//   }

//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);

//     if (difference.inMinutes < 60) {
//       return '${difference.inMinutes}m ago';
//     } else if (difference.inHours < 24) {
//       return '${difference.inHours}h ago';
//     } else if (difference.inDays < 7) {
//       return '${difference.inDays}d ago';
//     } else {
//       return '${date.month}/${date.day}';
//     }
//   }
// }
