import "package:shadcn_flutter/shadcn_flutter.dart";

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _controller.text.trim(),
          isMe: true,
          timestamp: DateTime.now(),
        ),
      );

      // Fake reply
      _messages.add(
        ChatMessage(
          text: "This is a mock reply!",
          isMe: false,
          timestamp: DateTime.now(),
        ),
      );
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Padding(
        padding: const .all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Avatar(
                  initials: Avatar.getInitials("john Doe"),
                  provider: const NetworkImage(
                    "https://avatars.githubusercontent.com/u/64018564?v=4",
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
            Expanded(
              child: ListView.builder(
                padding: const .symmetric(vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessage(_messages[index]);
                },
              ),
            ),
            Row(
              spacing: 8,
              children: [
                IconButton.ghost(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.smile),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
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

  Widget _buildMessage(ChatMessage message) {
    return Align(
      alignment: message.isMe ? .centerRight : .centerLeft,
      child: Container(
        margin: const .symmetric(vertical: 4),
        padding: const .all(12),
        decoration: BoxDecoration(
          color: message.isMe
              ? Colors.blue.withValues(alpha: .2)
              : Colors.gray.withValues(alpha: .15),
          borderRadius: .circular(12),
        ),
        child: Text(message.text),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}
