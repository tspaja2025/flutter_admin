import 'package:shadcn_flutter/shadcn_flutter.dart';

class SocialMediaScreen extends StatefulWidget {
  const SocialMediaScreen({super.key});

  @override
  State<SocialMediaScreen> createState() => SocialMediaScreenState();
}

class SocialMediaScreenState extends State<SocialMediaScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .all(16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Expanded(
                child: Tabs(
                  index: index,
                  children: [
                    TabItem(child: Text("Overview")),
                    TabItem(child: Text("Create Post")),
                    TabItem(child: Text("Calendar")),
                    TabItem(child: Text("Analytics")),
                    TabItem(child: Text("Accounts")),
                    TabItem(child: Text("Settings")),
                  ],
                  onChanged: (int value) {
                    setState(() {
                      index = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const Gap(8),
          IndexedStack(
            index: index,
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [Text("Overview")],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text("Post Content").semiBold(),
                      Text(
                        "Write your message and schedule it for publishing",
                      ).muted().small(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [Text("Calendar")],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [Text("Analytics")],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [Text("Accounts")],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [Text("Settings")],
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
