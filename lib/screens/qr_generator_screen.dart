import 'package:qr_flutter/qr_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => QrGeneratorScreenState();
}

class QrGeneratorScreenState extends State<QrGeneratorScreen> {
  SliderValue value = const SliderValue.single(256);
  ColorDerivative foregroundColor = ColorDerivative.fromColor(Colors.black);
  ColorDerivative backgroundColor = ColorDerivative.fromColor(Colors.white);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: .start,
            spacing: 8,
            children: [
              Expanded(
                flex: 2,
                child: Card(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      //  Content Input
                      const TextField(placeholder: Text("Content")),
                      const SizedBox(height: 12),
                      const TextField(
                        placeholder: Text("SMS Number"),
                        hintText: "+123456789",
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      const TextField(
                        placeholder: Text("WiFi Configuration"),
                        hintText: "WIFI:T:WPA;S:SSID;P:Password;;",
                      ),

                      const SizedBox(height: 12),

                      // Appearance
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [const Text("Size (px)"), Text("size")],
                      ),
                      Slider(
                        value: value,
                        min: 128,
                        max: 512,
                        divisions: 8,
                        onChanged: (value) {
                          setState(() {
                            this.value = value;
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Text("Background"),
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: ColorInput(
                              value: backgroundColor,
                              orientation: .horizontal,
                              promptMode: PromptMode.popover,
                              onChanged: (value) {
                                setState(() {
                                  backgroundColor = value;
                                });
                              },
                            ),
                          ),
                          const Text("Foreground"),
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: ColorInput(
                              value: foregroundColor,
                              orientation: .horizontal,
                              promptMode: PromptMode.popover,
                              onChanged: (value) {
                                setState(() {
                                  foregroundColor = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Logo
                      Wrap(
                        spacing: 8,
                        children: [
                          PrimaryButton(
                            onPressed: () {},
                            leading: const Icon(LucideIcons.upload),
                            child: const Text("Upload Logo"),
                          ),
                          DestructiveButton(
                            onPressed: () {},
                            leading: const Icon(LucideIcons.upload),
                            child: const Text("Delete Logo"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      SecondaryButton(
                        onPressed: () {},
                        leading: const Icon(Icons.refresh),
                        child: const Text("Reset All"),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Column(
                    children: [
                      QrImageView(
                        data: '1234567890',
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          PrimaryButton(
                            leading: const Icon(LucideIcons.download),
                            child: const Text("PNG"),
                          ),
                          PrimaryButton(
                            leading: const Icon(LucideIcons.download),
                            child: const Text("SVG"),
                          ),
                        ],
                      ),
                    ],
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
