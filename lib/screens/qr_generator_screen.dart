import "dart:html" as html;
import "dart:io";
import "dart:ui" as ui;

import "package:flutter/rendering.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";
import "package:path_provider/path_provider.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => QrGeneratorScreenState();
}

class QrGeneratorScreenState extends State<QrGeneratorScreen> {
  SliderValue value = const SliderValue.single(256);
  ColorDerivative foregroundColor = ColorDerivative.fromColor(Colors.black);
  ColorDerivative backgroundColor = ColorDerivative.fromColor(Colors.white);
  Uint8List? logoBytes;
  QrType selectedType = QrType.text;

  final GlobalKey qrKey = GlobalKey();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController smsController = TextEditingController();
  final TextEditingController wifiController = TextEditingController();

  String get qrData {
    switch (selectedType) {
      case QrType.text:
        return contentController.text.trim();
      case QrType.sms:
        return "SMSTO:${smsController.text.trim()}:";
      case QrType.wifi:
        return wifiController.text.trim();
    }
  }

  void _reset() {
    setState(() {
      contentController.clear();
      smsController.clear();
      wifiController.clear();
      value = const SliderValue.single(256);
      foregroundColor = ColorDerivative.fromColor(Colors.blue);
      backgroundColor = ColorDerivative.fromColor(Colors.white);
      logoBytes = null;
    });
  }

  Future<void> _downloadQr() async {
    if (kIsWeb) {
      await _downloadQrWeb();
    } else {
      await _downloadQrFile();
    }
  }

  Future<void> _downloadQrWeb() async {
    final boundary =
        qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final blob = html.Blob([pngBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "qr_code.png")
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  Future<void> _downloadQrFile() async {
    final boundary =
        qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      "${directory.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png",
    );

    await file.writeAsBytes(pngBytes);
  }

  Future<void> _pickLogo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // IMPORTANT for web support
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        logoBytes = result.files.single.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              crossAxisAlignment: .start,
              spacing: 8,
              children: [
                Expanded(child: _buildSettingsCard()),
                Expanded(child: _buildPreviewCard()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const Text("Configure your QR code").semiBold(),
          const SizedBox(height: 8),
          const Text(
            "Enter your content and customzie the appearance",
          ).muted().small(),
          const SizedBox(height: 16),
          ButtonGroup(
            children: [
              OutlineButton(
                onPressed: () => setState(() => selectedType = QrType.text),
                child: const Text("Text"),
              ),
              OutlineButton(
                onPressed: () => setState(() => selectedType = QrType.sms),
                child: const Text("SMS"),
              ),
              OutlineButton(
                onPressed: () => setState(() => selectedType = QrType.wifi),
                child: const Text("WiFi"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (selectedType == QrType.text)
            FormField(
              key: FormKey(#content),
              label: const Text("Content"),
              child: TextField(
                controller: contentController,
                onChanged: (_) => setState(() {}),
              ),
            ),

          if (selectedType == QrType.sms)
            FormField(
              key: FormKey(#smsNumber),
              label: const Text("SMS Number"),
              child: TextField(
                controller: smsController,
                keyboardType: TextInputType.phone,
                onChanged: (_) => setState(() {}),
              ),
            ),

          if (selectedType == QrType.wifi)
            FormField(
              key: FormKey(#wifiConfiguration),
              label: const Text("WiFi Configuration"),
              trailingLabel: const Text("WIFI:T:WPA;S:Network;P:Password;;"),
              child: TextField(
                controller: wifiController,
                onChanged: (_) => setState(() {}),
              ),
            ),
          const SizedBox(height: 8),
          const Text("Settings").semiBold(),
          const SizedBox(height: 16),
          Text("Size: ${value.start} px"),
          Slider(
            value: value,
            min: 128,
            max: 512,
            divisions: 12,
            onChanged: (value) {
              setState(() {
                this.value = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FormField(
                  key: FormKey(#foregroundColor),
                  label: const Text("Foreground Color"),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: ColorInput(
                      value: foregroundColor,
                      orientation: .horizontal,
                      promptMode: .popover,
                      onChanged: (value) {
                        setState(() {
                          foregroundColor = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FormField(
                  key: FormKey(#backgroundColor),
                  label: const Text("Background Color"),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: ColorInput(
                      value: backgroundColor,
                      orientation: .horizontal,
                      promptMode: .popover,
                      onChanged: (value) {
                        setState(() {
                          backgroundColor = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FormField(
            key: FormKey(#logo),
            label: const Text("Logo (optional)"),
            child: OutlineButton(
              onPressed: _pickLogo,
              child: const Text("Choose image"),
            ),
          ),
          const SizedBox(height: 8),
          OutlineButton(onPressed: _reset, child: const Text("Reset")),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Card(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const Text("Preview and Download").semiBold(),
          const SizedBox(height: 8),
          const Text("Your QR code will appear here").muted().small(),
          const SizedBox(height: 24),
          Center(
            child: Container(
              padding: const .all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.gray.shade200),
                borderRadius: .circular(12),
              ),
              child: RepaintBoundary(
                key: qrKey,
                child: QrImageView(
                  data: qrData.isEmpty ? " " : qrData,
                  version: QrVersions.auto,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                  size: value.start.toDouble(),
                  backgroundColor: backgroundColor.toColor(),
                  foregroundColor: foregroundColor.toColor(),
                  embeddedImage: logoBytes != null
                      ? MemoryImage(logoBytes!)
                      : null,
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(48, 48),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            onPressed: _downloadQr,
            leading: const Icon(LucideIcons.download),
            child: const Text("Download"),
          ),
        ],
      ),
    );
  }
}

enum QrType { text, sms, wifi }
