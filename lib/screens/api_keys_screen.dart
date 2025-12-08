import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

// Add feedback to key clipboard copy.

enum DialogState { idle, loading, created }

class ApiKeysScreen extends StatefulWidget {
  const ApiKeysScreen({super.key});

  @override
  State<ApiKeysScreen> createState() => ApiKeysScreenState();
}

class ApiKeysScreenState extends State<ApiKeysScreen> {
  DialogState _dialogState = DialogState.idle;
  String? _newKey;
  List<ApiKey> _apiKeys = [];

  @override
  void initState() {
    super.initState();
    _loadApiKeys();
  }

  Future<void> _loadApiKeys() async {
    final keys = await ApiKeyService.getApiKeys();
    setState(() {
      _apiKeys = keys;
    });
  }

  Future<void> _generateApiKey(String name) async {
    setState(() {
      _dialogState = DialogState.loading;
    });

    final newKey = await ApiKeyService.createApiKey(name: name);

    setState(() {
      _dialogState = DialogState.created;
      _newKey = newKey.key;
      _apiKeys.insert(0, newKey);
    });
  }

  Future<void> _deleteApiKey(String id) async {
    await ApiKeyService.deleteApiKey(id);
    setState(() {
      _apiKeys.removeWhere((k) => k.id == id);
      showToast(
        context: context,
        builder: (context, overlay) {
          return SurfaceCard(child: Basic(content: const Text("Key deleted")));
        },
        location: ToastLocation.bottomRight,
      );
    });
  }

  void _showCreateDialog() {
    final TextEditingController nameController = TextEditingController();
    _dialogState = DialogState.idle;
    _newKey = null;

    showDialog(
      context: context,
      builder: (context) {
        final apiKeyName = const TextFieldKey("apiKeyName");

        return StatefulBuilder(
          builder: (context, setDialogState) {
            if (_dialogState == DialogState.created) {
              return AlertDialog(
                title: const Text("API Key Created"),
                content: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    children: [
                      FormField(
                        key: apiKeyName,
                        label: const Text("Key"),
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(text: _newKey),
                          features: [InputFeature.copy()],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Alert.destructive(
                        leading: const Icon(LucideIcons.info),
                        title: const Text("Important").bold(),
                        content: const Text(
                          "Copy this key now. You won’t be able to see it again.",
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  PrimaryButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Done"),
                  ),
                ],
              );
            }

            return AlertDialog(
              title: const Text("Create New API Key"),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  children: [
                    FormField(
                      key: apiKeyName,
                      label: const Text("Key Name"),
                      child: TextField(controller: nameController),
                    ),
                  ],
                ),
              ),
              actions: [
                SecondaryButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                PrimaryButton(
                  onPressed: _dialogState == DialogState.loading
                      ? null
                      : () => setDialogState(() {
                          _generateApiKey(nameController.text);
                        }),
                  child: _dialogState == DialogState.loading
                      ? const CircularProgressIndicator()
                      : const Text("Create Key"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasKeys = _apiKeys.isNotEmpty;

    return Scaffold(
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            PrimaryButton(
              onPressed: _showCreateDialog,
              density: .dense,
              leading: const Icon(LucideIcons.plus),
              child: const Text("Create New Key"),
            ),
            const SizedBox(height: 8),
            if (!hasKeys)
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const .all(8),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        const Text("Your API Keys").semiBold(),
                        const SizedBox(height: 4),
                        const Text(
                          "Manage and monitor your API keys.",
                        ).muted().small(),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: .center,
                          children: [
                            Column(
                              children: [
                                const Text("No API keys yet.").bold().large(),
                                const SizedBox(height: 4),
                                const Text(
                                  "Create your first API key to get started.",
                                ).muted().small(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const .all(8),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        const Text("Your API Keys").semiBold(),
                        const SizedBox(height: 4),
                        const Text(
                          "Manage and monitor your API keys.",
                        ).muted().small(),
                        const SizedBox(height: 16),
                        Table(
                          rows: [
                            // Header row
                            TableRow(
                              cells: [
                                _buildHeaderCell("Name"),
                                _buildHeaderCell("Key"),
                                _buildHeaderCell("Created"),
                                _buildHeaderCell("Last Used"),
                                _buildHeaderCell("Status"),
                                _buildHeaderCell("Actions", true),
                              ],
                            ),
                            // Body Rows
                            ..._apiKeys.map((key) {
                              final prefix = ApiKeyService.getKeyPrefix(
                                key.key,
                              );
                              final masked = ApiKeyService.maskApiKey(
                                prefix,
                                totalLength: 32,
                              );

                              return TableRow(
                                cells: [
                                  _buildCell(key.name),
                                  _buildCell(masked),
                                  _buildCell(
                                    key.createdAt
                                        .toLocal()
                                        .toString()
                                        .split(" ")
                                        .first,
                                  ),
                                  _buildCell(
                                    key.lastUsedAt != null
                                        ? key.lastUsedAt!
                                              .toLocal()
                                              .toString()
                                              .split("")
                                              .first
                                        : "Never",
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: const .only(left: 8, right: 8),
                                      alignment: .centerLeft,
                                      child: key.isActive
                                          ? PrimaryBadge(
                                              child: const Text("Active"),
                                            )
                                          : SecondaryBadge(
                                              child: Text("Inactive"),
                                            ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: const .only(left: 8, right: 8),
                                      alignment: .centerRight,
                                      child: IconButton.ghost(
                                        onPressed: () {
                                          _deleteApiKey(key.id);
                                        },
                                        icon: const Icon(
                                          LucideIcons.trash2,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  TableCell _buildHeaderCell(String text, [bool alignRight = false]) {
    return TableCell(
      child: Container(
        padding: const .all(8),
        alignment: alignRight ? .centerRight : null,
        child: Text(text).muted().semiBold(),
      ),
    );
  }

  TableCell _buildCell(String text, [bool alignRight = false]) {
    return TableCell(
      child: Container(
        padding: const .all(12),
        alignment: alignRight ? .centerRight : null,
        child: Text(text),
      ),
    );
  }
}

// Api Key Model
class ApiKey {
  final String id;
  final String key;
  final String name;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final bool isActive;

  ApiKey({
    required this.id,
    required this.key,
    required this.name,
    required this.createdAt,
    this.lastUsedAt,
    this.isActive = true,
  });

  // Convert to/from JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory ApiKey.fromJson(Map<String, dynamic> json) {
    return ApiKey(
      id: json['id'],
      key: json['key'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      lastUsedAt: json['lastUsedAt'] != null
          ? DateTime.parse(json['lastUsedAt'])
          : null,
      isActive: json['isActive'] ?? true,
    );
  }

  // Copy with method for updates
  ApiKey copyWith({
    String? id,
    String? key,
    String? name,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    bool? isActive,
  }) {
    return ApiKey(
      id: id ?? this.id,
      key: key ?? this.key,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

// Api Key Service
class ApiKeyService {
  static const String _storageKey = 'api_keys';

  // Generate a secure API key
  static String generateApiKey() {
    final random = Random.secure();
    final values = List<int>.generate(64, (i) => random.nextInt(256));
    return "sk${base64Url.encode(values)}".replaceAll(
      RegExp(r"[^a-zA-Z0-9]"),
      "",
    );
  }

  // Get key prefix for display
  static String getKeyPrefix(String key) {
    return key.length > 8 ? key.substring(0, 8) : key;
  }

  // Mask API key for security
  static String maskApiKey(String prefix, {int totalLength = 32}) {
    final maskedLength = totalLength - prefix.length;
    return prefix + '*' * (maskedLength > 0 ? maskedLength : 0);
  }

  // Get all API Keys from storage
  static Future<List<ApiKey>> getApiKeys() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_storageKey);
      if (stored == null) return [];

      final List<dynamic> jsonList = json.decode(stored);
      return jsonList.map((json) => ApiKey.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error reading API keys: $e');
      }
      return [];
    }
  }

  // Save API keys to storage
  static Future<void> _setApiKeys(List<ApiKey> apiKeys) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = apiKeys.map((key) => key.toJson()).toList();
      await prefs.setString(_storageKey, json.encode(jsonList));
    } catch (e) {
      if (kDebugMode) {
        print('Error saving API keys: $e');
      }
      throw Exception('Failed to save API keys');
    }
  }

  // Create a new API key
  static Future<ApiKey> createApiKey({
    required String name,
    String? customKey,
  }) async {
    final apiKeys = await getApiKeys();
    final newKey = ApiKey(
      id: '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}',
      key: customKey ?? generateApiKey(),
      name: name,
      createdAt: DateTime.now(),
      isActive: true,
    );

    final List<ApiKey> updatedKeys = [newKey, ...apiKeys];
    await _setApiKeys(updatedKeys);
    return newKey;
  }

  // Delete an API key by ID
  static Future<void> deleteApiKey(String id) async {
    final apiKeys = await getApiKeys();
    final filteredKeys = apiKeys.where((k) => k.id != id).toList();
    await _setApiKeys(filteredKeys);
  }

  // Update an API key
  static Future<void> updateApiKey(String id, ApiKey updates) async {
    final apiKeys = await getApiKeys();
    final updatedKeys = apiKeys.map((k) {
      if (k.id == id) {
        return k.copyWith(
          name: updates.name,
          lastUsedAt: updates.lastUsedAt,
          isActive: updates.isActive,
        );
      }
      return k;
    }).toList();

    await _setApiKeys(updatedKeys);
  }

  // Update last used timestamp
  static Future<void> updateLastUsed(String id) async {
    final apiKeys = await getApiKeys();
    final updatedKeys = apiKeys.map((k) {
      if (k.id == id) {
        return k.copyWith(lastUsedAt: DateTime.now());
      }
      return k;
    }).toList();

    await _setApiKeys(updatedKeys);
  }
}
