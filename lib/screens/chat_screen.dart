import 'package:shadcn_flutter/shadcn_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Padding(
        padding: const .all(16),
        child: Column(
          mainAxisAlignment: .spaceBetween,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Avatar(
                  initials: Avatar.getInitials("john Doe"),
                  provider: const NetworkImage(
                    'https://avatars.githubusercontent.com/u/64018564?v=4',
                  ),
                ),
                Wrap(
                  children: [
                    IconButton.ghost(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.phone),
                    ),
                    IconButton.ghost(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.video),
                    ),
                    IconButton.ghost(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.circleAlert),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              spacing: 8,
              children: [
                IconButton.ghost(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.smile),
                ),
                Expanded(
                  child: const TextField(
                    placeholder: Text("Type a message..."),
                  ),
                ),
                IconButton.ghost(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
