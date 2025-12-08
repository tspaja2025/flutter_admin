import 'package:shadcn_flutter/shadcn_flutter.dart';

// Implement the rest

class FileManagerScreen extends StatefulWidget {
  const FileManagerScreen({super.key});

  @override
  State<FileManagerScreen> createState() => FileManagerScreenState();
}

class FileManagerScreenState extends State<FileManagerScreen> {
  CheckboxState _state = CheckboxState.unchecked;
  final List<FileItem> _files = [];
  final List<String> _breadcrumbPaths = ["home"];
  String _currentPath = "";
  String _searchQuery = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFiles("");
  }

  Future<void> _loadFiles(String path) async {
    setState(() {
      _isLoading = true;
    });

    // API call delay simulation
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Real app uses file_picker package or platform channels
      // to access the file system.
      // Mock implementation:
      final mockFiles = _getMockFiles(path);

      setState(() {
        _files.clear();
        _files.addAll(mockFiles);
        _currentPath = path;
        _updateBreadcrumb(path);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError("Failed to load files: $e");
    }
  }

  List<FileItem> _getMockFiles(String path) {
    // Mock data
    return [
      FileItem(
        name: 'Documents',
        path: '$path/Documents',
        isDirectory: true,
        size: 0,
        modifiedDate: DateTime(2024, 1, 15),
      ),
      FileItem(
        name: 'Images',
        path: '$path/Images',
        isDirectory: true,
        size: 0,
        modifiedDate: DateTime(2024, 1, 14),
      ),
      FileItem(
        name: 'report.pdf',
        path: '$path/report.pdf',
        isDirectory: false,
        size: 1024,
        modifiedDate: DateTime(2024, 1, 13),
      ),
      FileItem(
        name: 'notes.txt',
        path: '$path/notes.txt',
        isDirectory: false,
        size: 512,
        modifiedDate: DateTime(2024, 1, 12),
      ),
    ];
  }

  void _updateBreadcrumb(String path) {
    if (path.isEmpty) {
      _breadcrumbPaths.clear();
      _breadcrumbPaths.add("Home");
    } else {
      final parts = path.split("/").where((part) => part.isNotEmpty).toList();
      _breadcrumbPaths.clear();
      _breadcrumbPaths.add("Home");
      _breadcrumbPaths.addAll(parts);
    }
  }

  void _navigateToPath(int index) {
    if (index == 0) {
      _loadFiles("");
    } else {
      final path = _breadcrumbPaths.sublist(1, index + 1).join("/");
      _loadFiles(path);
    }
  }

  void _showSuccess(String message) {
    showToast(
      context: context,
      builder: (BuildContext context, ToastOverlay overlay) {
        return SurfaceCard(child: Basic(content: Text(message)));
      },
      location: ToastLocation.bottomRight,
    );
  }

  void _showError(String message) {
    showToast(
      context: context,
      builder: (BuildContext context, ToastOverlay overlay) {
        return SurfaceCard(child: Basic(content: Text(message)));
      },
      location: ToastLocation.bottomRight,
    );
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _createNewFolder() async {
    final name = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Folder"),
        content: TextField(
          placeholder: const Text("Folder name"),
          autofocus: true,
        ),
        actions: [
          SecondaryButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          PrimaryButton(
            // Get folder name from text field and return it
            onPressed: () => Navigator.of(context).pop("New Folder"),
            child: const Text("Create"),
          ),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      // Implement folder creation logic here
      _showSuccess("Folder '$name' created");
      _loadFiles(_currentPath);
    }
  }

  void _uploadFiles() async {
    // file_picker package for actual file upload
    _showSuccess("Files uploaded successfully");
    _loadFiles(_currentPath);
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
              spacing: 8,
              children: [
                Expanded(
                  child: Breadcrumb(
                    separator: Breadcrumb.arrowSeparator,
                    children: [
                      for (int i = 0; i < _breadcrumbPaths.length; i++)
                        i == _breadcrumbPaths.length - 1
                            ? Text(_breadcrumbPaths[i])
                            : TextButton(
                                onPressed: () => _navigateToPath(i),
                                density: ButtonDensity.compact,
                                child: i == 0
                                    ? const Icon(Icons.home)
                                    : Text(_breadcrumbPaths[i]),
                              ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 200,
                  child: TextField(
                    onChanged: _handleSearch,
                    placeholder: const Text("Search files..."),
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
                ButtonGroup(
                  children: [
                    IconButton.primary(
                      onPressed: () {},
                      density: .iconDense,
                      icon: const Icon(LucideIcons.grid3x3),
                    ),
                    IconButton.outline(
                      onPressed: () {},
                      density: .iconDense,
                      icon: const Icon(LucideIcons.list),
                    ),
                  ],
                ),
                Builder(
                  builder: (context) {
                    return PrimaryButton(
                      onPressed: () {
                        showDropdown(
                          context: context,
                          builder: (context) {
                            return DropdownMenu(
                              children: [
                                MenuButton(
                                  onPressed: (_) => _createNewFolder,
                                  leading: const Icon(LucideIcons.plus),
                                  child: const Text("New Folder"),
                                ),
                                MenuButton(
                                  onPressed: (_) => _uploadFiles,
                                  leading: const Icon(LucideIcons.upload),
                                  child: const Text("Upload Files"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      density: .dense,
                      leading: const Icon(LucideIcons.plus),
                      child: const Text("New"),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: .start,
              spacing: 8,
              children: [
                _buildCard("Documents", true),
                _buildCard("Images", true),
                _buildCard("Projects", true),
                _buildCard("readme.txt"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String name, [bool isFolder = false]) {
    return SizedBox(
      width: 200,
      child: Card(
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  state: _state,
                  onChanged: (value) {
                    setState(() {
                      _state = value;
                    });
                  },
                ),
                const Spacer(),
                Builder(
                  builder: (context) {
                    return IconButton.ghost(
                      onPressed: () {
                        showDropdown(
                          context: context,
                          builder: (context) {
                            return DropdownMenu(
                              children: [
                                MenuButton(
                                  onPressed: (_) {},
                                  leading: const Icon(LucideIcons.download),
                                  child: const Text("Download"),
                                ),
                                MenuButton(
                                  onPressed: (_) {},
                                  leading: const Icon(LucideIcons.pencil),
                                  child: const Text("Rename"),
                                ),
                                MenuButton(
                                  onPressed: (_) {},
                                  leading: const Icon(LucideIcons.trash2),
                                  child: const Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      density: .iconDense,
                      icon: const Icon(LucideIcons.ellipsisVertical),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Icon(
              isFolder ? LucideIcons.folder : LucideIcons.fileText,
              size: 48,
              color: isFolder ? Colors.blue : Colors.green,
            ),
            const SizedBox(height: 4),
            Text(name).semiBold(),
            const SizedBox(height: 4),
            if (!isFolder) const Text("1.00 KB").muted().small(),
            const SizedBox(height: 4),
            const Text("Dec 3, 2025").muted().small(),
          ],
        ),
      ),
    );
  }
}

class FileItem {
  final String name;
  final String path;
  final bool isDirectory;
  final int size;
  final DateTime modifiedDate;
  bool isSelected;

  FileItem({
    required this.name,
    required this.path,
    required this.isDirectory,
    required this.size,
    required this.modifiedDate,
    this.isSelected = false,
  });
}
