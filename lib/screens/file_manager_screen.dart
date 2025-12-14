import "package:shadcn_flutter/shadcn_flutter.dart";

class FileManagerScreen extends StatefulWidget {
  const FileManagerScreen({super.key});

  @override
  State<FileManagerScreen> createState() => FileManagerScreenState();
}

class FileManagerScreenState extends State<FileManagerScreen> {
  final List<FileItem> _files = [];
  final List<String> _breadcrumbPaths = ["Home"];
  String _currentPath = "";
  String _searchQuery = "";
  bool _isLoading = false;
  bool _gridView = true; // true for grid, false for list
  final String _selectedSort = "name";

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
      final mockFiles = _getMockFiles(path);

      // Apply search filter if needed
      List<FileItem> filteredFiles = mockFiles;
      if (_searchQuery.isNotEmpty) {
        filteredFiles = mockFiles
            .where(
              (file) =>
                  file.name.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();
      }

      // Sort files
      filteredFiles = _sortFiles(filteredFiles);

      setState(() {
        _files.clear();
        _files.addAll(filteredFiles);
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
    // More comprehensive mock data
    List<FileItem> files = [];

    if (path.isEmpty) {
      files = [
        FileItem(
          name: "Documents",
          path: "Documents",
          isDirectory: true,
          size: 0,
          modifiedDate: DateTime(2024, 1, 15),
        ),
        FileItem(
          name: "Images",
          path: "Images",
          isDirectory: true,
          size: 0,
          modifiedDate: DateTime(2024, 1, 14),
        ),
        FileItem(
          name: "Projects",
          path: "Projects",
          isDirectory: true,
          size: 0,
          modifiedDate: DateTime(2024, 1, 16),
        ),
        FileItem(
          name: "report.pdf",
          path: "report.pdf",
          isDirectory: false,
          size: 1024 * 1024, // 1MB
          modifiedDate: DateTime(2024, 1, 13),
        ),
        FileItem(
          name: "notes.txt",
          path: "notes.txt",
          isDirectory: false,
          size: 512,
          modifiedDate: DateTime(2024, 1, 12),
        ),
        FileItem(
          name: "budget.xlsx",
          path: "budget.xlsx",
          isDirectory: false,
          size: 2048 * 1024, // 2MB
          modifiedDate: DateTime(2024, 1, 10),
        ),
        FileItem(
          name: "presentation.pptx",
          path: "presentation.pptx",
          isDirectory: false,
          size: 3 * 1024 * 1024, // 3MB
          modifiedDate: DateTime(2024, 1, 9),
        ),
      ];
    } else if (path == "Documents") {
      files = [
        FileItem(
          name: "Work",
          path: "Documents/Work",
          isDirectory: true,
          size: 0,
          modifiedDate: DateTime(2024, 1, 14),
        ),
        FileItem(
          name: "Personal",
          path: "Documents/Personal",
          isDirectory: true,
          size: 0,
          modifiedDate: DateTime(2024, 1, 13),
        ),
        FileItem(
          name: "resume.pdf",
          path: "Documents/resume.pdf",
          isDirectory: false,
          size: 512 * 1024, // 512KB
          modifiedDate: DateTime(2024, 1, 12),
        ),
      ];
    } else if (path == "Images") {
      files = [
        FileItem(
          name: "Vacation 2023",
          path: "Images/Vacation 2023",
          isDirectory: true,
          size: 0,
          modifiedDate: DateTime(2023, 12, 20),
        ),
        FileItem(
          name: "Family",
          path: "Images/Family",
          isDirectory: true,
          size: 0,
          modifiedDate: DateTime(2023, 12, 15),
        ),
        FileItem(
          name: "beach.jpg",
          path: "Images/beach.jpg",
          isDirectory: false,
          size: 2 * 1024 * 1024, // 2MB
          modifiedDate: DateTime(2023, 12, 10),
        ),
      ];
    }

    return files;
  }

  List<FileItem> _sortFiles(List<FileItem> files) {
    switch (_selectedSort) {
      case "name":
        // Directories first, then sort by name
        files.sort((a, b) {
          // First compare by directory status
          if (a.isDirectory && !b.isDirectory) return -1;
          if (!a.isDirectory && b.isDirectory) return 1;
          // Both are same type, sort by name
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case "date":
        files.sort((a, b) {
          // Directories first
          if (a.isDirectory && !b.isDirectory) return -1;
          if (!a.isDirectory && b.isDirectory) return 1;
          // Both are same type, sort by date
          return b.modifiedDate.compareTo(a.modifiedDate);
        });
        break;
      case "size":
        files.sort((a, b) {
          // Directories first
          if (a.isDirectory && !b.isDirectory) return -1;
          if (!a.isDirectory && b.isDirectory) return 1;
          // Both are same type, sort by size
          return b.size.compareTo(a.size);
        });
        break;
      case "type":
        files.sort((a, b) {
          // Directories first
          if (a.isDirectory && !b.isDirectory) return -1;
          if (!a.isDirectory && b.isDirectory) return 1;

          // Both are files, sort by extension
          final aExt = a.name.split(".").last.toLowerCase();
          final bExt = b.name.split(".").last.toLowerCase();
          return aExt.compareTo(bExt);
        });
        break;
    }
    return files;
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

  // void _navigateToDirectory(FileItem directory) {
  //   _loadFiles(directory.path);
  // }

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
    _loadFiles(_currentPath);
  }

  void _createNewFolder() async {
    final TextEditingController controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Folder"),
        content: TextField(
          controller: controller,
          placeholder: const Text("Folder name"),
          autofocus: true,
        ),
        actions: [
          SecondaryButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          PrimaryButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text("Create"),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      // Check if folder already exists
      bool folderExists = false;
      for (var file in _files) {
        if (file.name == result && file.isDirectory) {
          folderExists = true;
          break;
        }
      }

      if (folderExists) {
        _showError("A folder with this name already exists");
      } else {
        // Add new folder to list
        setState(() {
          _files.add(
            FileItem(
              name: result,
              path: "$_currentPath${_currentPath.isNotEmpty ? "/" : ""}$result",
              isDirectory: true,
              size: 0,
              modifiedDate: DateTime.now(),
            ),
          );
          // Re-sort files to maintain directory-first order
          _files.sort((a, b) {
            if (a.isDirectory && !b.isDirectory) return -1;
            if (!a.isDirectory && b.isDirectory) return 1;
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          });
        });
        _showSuccess("Folder '$result' created");
      }
    }
  }

  void _uploadFiles() async {
    // In a real app, you would use file_picker package
    _showSuccess("Upload feature would open file picker");
    // After upload, reload files
    // _loadFiles(_currentPath);
  }

  void _toggleFileSelection(FileItem file) {
    setState(() {
      file.isSelected = !file.isSelected;
    });
  }

  void _toggleAllSelection() {
    final allSelected = _files.every((file) => file.isSelected);
    setState(() {
      for (var file in _files) {
        file.isSelected = !allSelected;
      }
    });
  }

  void _deleteSelectedFiles() {
    final selectedFiles = _files.where((file) => file.isSelected).toList();
    if (selectedFiles.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Files"),
        content: Text("Delete ${selectedFiles.length} item(s)?"),
        actions: [
          SecondaryButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          PrimaryButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _files.removeWhere((file) => file.isSelected);
              });
              _showSuccess("${selectedFiles.length} item(s) deleted");
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _renameFile(FileItem file) async {
    final TextEditingController controller = TextEditingController(
      text: file.name,
    );

    final newName = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rename"),
        content: TextField(
          controller: controller,
          placeholder: const Text("New name"),
          autofocus: true,
        ),
        actions: [
          SecondaryButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          PrimaryButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text("Rename"),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != file.name) {
      if (_files.any((f) => f.name == newName && f.path != file.path)) {
        _showError("An item with this name already exists");
      } else {
        setState(() {
          file.name = newName;
        });
        _showSuccess("Item renamed to '$newName'");
      }
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    if (bytes < 1024 * 1024 * 1024) {
      return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
    }
    return "${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB";
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Today";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      return "${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}";
    }
  }

  Widget _buildFileIcon(FileItem file) {
    if (file.isDirectory) {
      return const Icon(LucideIcons.folder, size: 48, color: Colors.blue);
    }

    final ext = file.name.split(".").last.toLowerCase();
    switch (ext) {
      case "pdf":
        return const Icon(LucideIcons.fileText, size: 48, color: Colors.red);
      case "txt":
        return const Icon(LucideIcons.fileText, size: 48, color: Colors.gray);
      case "jpg":
      case "jpeg":
      case "png":
      case "gif":
        return const Icon(LucideIcons.image, size: 48, color: Colors.green);
      case "xlsx":
      case "xls":
        return const Icon(LucideIcons.table, size: 48, color: Colors.green);
      case "pptx":
      case "ppt":
        return const Icon(
          LucideIcons.presentation,
          size: 48,
          color: Colors.orange,
        );
      default:
        return const Icon(LucideIcons.file, size: 48, color: Colors.gray);
    }
  }

  Widget _buildGridView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_files.isEmpty) {
      return Column(
        mainAxisAlignment: .start,
        children: [
          Icon(LucideIcons.folderOpen, size: 64, color: Colors.gray),
          SizedBox(height: 16),
          Text("No files found").muted(),
        ],
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: _files.map((file) => _buildFileCard(file)).toList(),
    );
  }

  Widget _buildListView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_files.isEmpty) {
      return Column(
        crossAxisAlignment: .start,
        children: [
          Icon(LucideIcons.folderOpen, size: 64, color: Colors.gray),
          SizedBox(height: 16),
          Text("No files found").muted(),
        ],
      );
    }

    return Table(
      rows: [
        TableRow(
          cells: [
            TableCell(
              child: Padding(
                padding: const .all(12),
                child: Row(
                  children: [
                    Checkbox(
                      state: _files.every((file) => file.isSelected)
                          ? CheckboxState.checked
                          : (_files.any((file) => file.isSelected)
                                ? CheckboxState.indeterminate
                                : CheckboxState.unchecked),
                      onChanged: (value) {
                        _toggleAllSelection();
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text("Name").semiBold(),
                  ],
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: .all(12),
                child: Text("Date Modified").semiBold(),
              ),
            ),
            TableCell(
              child: Padding(padding: .all(12), child: Text("Type").semiBold()),
            ),
            TableCell(
              child: Padding(padding: .all(12), child: Text("Size").semiBold()),
            ),
            TableCell(
              child: Padding(
                padding: .all(12),
                child: Text("Actions").semiBold(),
              ),
            ),
          ],
        ),
        for (var file in _files)
          TableRow(
            cells: [
              TableCell(
                child: Padding(
                  padding: const .all(12),
                  child: Row(
                    children: [
                      Checkbox(
                        state: file.isSelected
                            ? CheckboxState.checked
                            : CheckboxState.unchecked,
                        onChanged: (value) {
                          _toggleFileSelection(file);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildFileIcon(file),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(file.name).semiBold(),
                            if (!file.isDirectory)
                              Text(_formatFileSize(file.size)).muted().small(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const .all(12),
                  child: Text(_formatDate(file.modifiedDate)),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const .all(12),
                  child: Text(
                    file.isDirectory
                        ? "Folder"
                        : file.name.split(".").last.toUpperCase(),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const .all(12),
                  child: Text(
                    file.isDirectory ? "--" : _formatFileSize(file.size),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const .all(12),
                  child: _buildFileActions(file),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildFileCard(FileItem file) {
    return SizedBox(
      width: 180,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  state: file.isSelected
                      ? CheckboxState.checked
                      : CheckboxState.unchecked,
                  onChanged: (value) {
                    _toggleFileSelection(file);
                  },
                ),
                const Spacer(),
                _buildFileActions(file),
              ],
            ),
            const SizedBox(height: 8),
            Center(child: _buildFileIcon(file)),
            const SizedBox(height: 12),
            Padding(
              padding: const .symmetric(horizontal: 12),
              child: Text(
                file.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ).semiBold(),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const .symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!file.isDirectory)
                    Text(_formatFileSize(file.size)).muted().small(),
                  Text(_formatDate(file.modifiedDate)).muted().small(),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildFileActions(FileItem file) {
    return Builder(
      builder: (context) {
        return IconButton.ghost(
          onPressed: () {
            showDropdown(
              context: context,
              builder: (context) {
                return DropdownMenu(
                  children: [
                    if (!file.isDirectory)
                      MenuButton(
                        onPressed: (_) {
                          Navigator.of(context).pop();
                          _showSuccess("Downloading ${file.name}");
                        },
                        leading: const Icon(LucideIcons.download),
                        child: const Text("Download"),
                      ),
                    MenuButton(
                      onPressed: (_) {
                        Navigator.of(context).pop();
                        _renameFile(file);
                      },
                      leading: const Icon(LucideIcons.pencil),
                      child: const Text("Rename"),
                    ),
                    MenuDivider(),
                    MenuButton(
                      onPressed: (_) {
                        Navigator.of(context).pop();
                        setState(() {
                          file.isSelected = true;
                        });
                        _deleteSelectedFiles();
                      },
                      leading: const Icon(
                        LucideIcons.trash2,
                        color: Colors.red,
                      ),
                      child: const Text("Delete"),
                    ),
                  ],
                );
              },
            );
          },
          density: ButtonDensity.iconDense,
          icon: const Icon(LucideIcons.ellipsisVertical, size: 16),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = _files.where((file) => file.isSelected).length;

    return Scaffold(
      child: Column(
        children: [
          // Top toolbar
          Container(
            padding: const .all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.gray.shade200)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Breadcrumb(
                        separator: Breadcrumb.arrowSeparator,
                        children: [
                          for (int i = 0; i < _breadcrumbPaths.length; i++)
                            i == _breadcrumbPaths.length - 1
                                ? Text(_breadcrumbPaths[i]).semiBold()
                                : TextButton(
                                    onPressed: () => _navigateToPath(i),
                                    density: ButtonDensity.compact,
                                    child: i == 0
                                        ? const Icon(
                                            LucideIcons.house,
                                            size: 16,
                                          )
                                        : Text(_breadcrumbPaths[i]),
                                  ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        onChanged: _handleSearch,
                        placeholder: const Text("Search files..."),
                        features: [
                          InputFeature.leading(
                            StatedWidget.builder(
                              builder: (context, states) {
                                return const Icon(LucideIcons.search, size: 16);
                              },
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            InputFeature.trailing(
                              StatedWidget.builder(
                                builder: (context, states) {
                                  return IconButton.ghost(
                                    onPressed: () {
                                      _handleSearch("");
                                    },
                                    icon: const Icon(LucideIcons.x, size: 16),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ButtonGroup(
                      children: [
                        IconButton.outline(
                          onPressed: () {
                            setState(() {
                              _gridView = true;
                            });
                          },
                          density: ButtonDensity.iconDense,
                          icon: const Icon(LucideIcons.grid3x3, size: 16),
                        ),
                        IconButton.outline(
                          onPressed: () {
                            setState(() {
                              _gridView = false;
                            });
                          },
                          density: ButtonDensity.iconDense,
                          icon: const Icon(LucideIcons.list, size: 16),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
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
                                      onPressed: (_) {
                                        Navigator.of(context).pop();
                                        _createNewFolder();
                                      },
                                      leading: const Icon(
                                        LucideIcons.folderPlus,
                                      ),
                                      child: const Text("New Folder"),
                                    ),
                                    MenuButton(
                                      onPressed: (_) {
                                        Navigator.of(context).pop();
                                        _uploadFiles();
                                      },
                                      leading: const Icon(LucideIcons.upload),
                                      child: const Text("Upload Files"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          density: ButtonDensity.dense,
                          leading: const Icon(LucideIcons.plus, size: 16),
                          child: const Text("New"),
                        );
                      },
                    ),
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
                    const SizedBox(width: 8),
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
                                      onPressed: (_) {
                                        Navigator.of(context).pop();
                                        _createNewFolder();
                                      },
                                      leading: const Icon(
                                        LucideIcons.folderPlus,
                                      ),
                                      child: const Text("New Folder"),
                                    ),
                                    MenuButton(
                                      onPressed: (_) {
                                        Navigator.of(context).pop();
                                        _uploadFiles();
                                      },
                                      leading: const Icon(LucideIcons.upload),
                                      child: const Text("Upload Files"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          density: ButtonDensity.dense,
                          leading: const Icon(LucideIcons.plus, size: 16),
                          child: const Text("New"),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Selection toolbar
                if (selectedCount > 0)
                  Container(
                    padding: const .all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Text("$selectedCount item(s) selected"),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              for (var file in _files) {
                                file.isSelected = false;
                              }
                            });
                          },
                          child: const Text("Clear"),
                        ),
                        const SizedBox(width: 8),
                        SecondaryButton(
                          onPressed: _deleteSelectedFiles,
                          leading: const Icon(LucideIcons.trash2, size: 16),
                          child: const Text("Delete"),
                        ),
                        const SizedBox(width: 8),
                        PrimaryButton(
                          onPressed: () {
                            _showSuccess("Downloading $selectedCount file(s)");
                            setState(() {
                              for (var file in _files) {
                                file.isSelected = false;
                              }
                            });
                          },
                          leading: const Icon(LucideIcons.download, size: 16),
                          child: const Text("Download"),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Main content area
          Expanded(
            child: Padding(
              padding: const .all(16),
              child: _gridView ? _buildGridView() : _buildListView(),
            ),
          ),
        ],
      ),
    );
  }
}

class FileItem {
  String name;
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
