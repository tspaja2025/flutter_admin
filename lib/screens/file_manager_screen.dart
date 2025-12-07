import 'package:shadcn_flutter/shadcn_flutter.dart';

class FileManagerScreen extends StatefulWidget {
  const FileManagerScreen({super.key});

  @override
  State<FileManagerScreen> createState() => FileManagerScreenState();
}

class FileManagerScreenState extends State<FileManagerScreen> {
  CheckboxState _state = CheckboxState.unchecked;

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
                Breadcrumb(
                  separator: Breadcrumb.arrowSeparator,
                  children: [
                    TextButton(
                      onPressed: () {},
                      density: .compact,
                      child: const Icon(LucideIcons.house),
                    ),
                    const MoreDots(),
                    TextButton(
                      onPressed: () {},
                      density: .compact,
                      child: const Text("Components"),
                    ),
                    const Text("File Manager"),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 200,
                  child: TextField(
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
                                  onPressed: (_) {},
                                  leading: const Icon(LucideIcons.plus),
                                  child: const Text("New Folder"),
                                ),
                                MenuButton(
                                  onPressed: (_) {},
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

// Old to be removed
// import 'package:shadcn_flutter/shadcn_flutter.dart';

// class FileItem {
//   final String name;
//   final String path;
//   final bool isDirectory;
//   final int size;
//   final DateTime modifiedDate;
//   bool isSelected;

//   FileItem({
//     required this.name,
//     required this.path,
//     required this.isDirectory,
//     required this.size,
//     required this.modifiedDate,
//     this.isSelected = false,
//   });
// }

// class FileManagerScreen extends StatefulWidget {
//   const FileManagerScreen({super.key});

//   @override
//   State<FileManagerScreen> createState() => FileManagerScreenState();
// }

// class FileManagerScreenState extends State<FileManagerScreen> {
//   final List<FileItem> _files = [];
//   final List<String> _breadcrumbPaths = ["home"];
//   String _currentPath = "";
//   String _searchQuery = "";
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadFiles("");
//   }

//   Future<void> _loadFiles(String path) async {
//     setState(() {
//       _isLoading = true;
//     });

//     // API call delay simulation
//     await Future.delayed(const Duration(milliseconds: 500));

//     try {
//       // Real app uses file_picker package or platform channels
//       // to access the file system.
//       // Mock implementation:
//       final mockFiles = _getMockFiles(path);

//       setState(() {
//         _files.clear();
//         _files.addAll(mockFiles);
//         _currentPath = path;
//         _updateBreadcrumb(path);
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       _showError("Failed to load files: $e");
//     }
//   }

//   List<FileItem> _getMockFiles(String path) {
//     // Mock data
//     return [
//       FileItem(
//         name: 'Documents',
//         path: '$path/Documents',
//         isDirectory: true,
//         size: 0,
//         modifiedDate: DateTime(2024, 1, 15),
//       ),
//       FileItem(
//         name: 'Images',
//         path: '$path/Images',
//         isDirectory: true,
//         size: 0,
//         modifiedDate: DateTime(2024, 1, 14),
//       ),
//       FileItem(
//         name: 'report.pdf',
//         path: '$path/report.pdf',
//         isDirectory: false,
//         size: 1024,
//         modifiedDate: DateTime(2024, 1, 13),
//       ),
//       FileItem(
//         name: 'notes.txt',
//         path: '$path/notes.txt',
//         isDirectory: false,
//         size: 512,
//         modifiedDate: DateTime(2024, 1, 12),
//       ),
//     ];
//   }

//   void _updateBreadcrumb(String path) {
//     if (path.isEmpty) {
//       _breadcrumbPaths.clear();
//       _breadcrumbPaths.add("Home");
//     } else {
//       final parts = path.split("/").where((part) => part.isNotEmpty).toList();
//       _breadcrumbPaths.clear();
//       _breadcrumbPaths.add("Home");
//       _breadcrumbPaths.addAll(parts);
//     }
//   }

//   void _navigateToPath(int index) {
//     if (index == 0) {
//       _loadFiles("");
//     } else {
//       final path = _breadcrumbPaths.sublist(1, index + 1).join("/");
//       _loadFiles(path);
//     }
//   }

//   void _handleFileTap(FileItem file) {
//     if (file.isDirectory) {
//       _loadFiles(file.path);
//     } else {
//       _showFileDetails(file);
//     }
//   }

//   void _toggleFileSelection(FileItem file) {
//     setState(() {
//       file.isSelected = !file.isSelected;
//     });
//   }

//   void _selectAll() {
//     setState(() {
//       for (final file in _files) {
//         file.isSelected = true;
//       }
//     });
//   }

//   void _deselectAll() {
//     setState(() {
//       for (final file in _files) {
//         file.isSelected = false;
//       }
//     });
//   }

//   List<FileItem> get _selectedFiles =>
//       _files.where((file) => file.isSelected).toList();

//   List<FileItem> get _filteredFiles {
//     if (_searchQuery.isEmpty) return _files;

//     return _files
//         .where(
//           (file) =>
//               file.name.toLowerCase().contains(_searchQuery.toLowerCase()),
//         )
//         .toList();
//   }

//   void _handleSearch(String query) {
//     setState(() {
//       _searchQuery = query;
//     });
//   }

//   void _createNewFolder() async {
//     final name = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("New Folder"),
//         content: TextField(
//           placeholder: const Text("Folder name"),
//           autofocus: true,
//         ),
//         actions: [
//           SecondaryButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("Cancel"),
//           ),
//           PrimaryButton(
//             // Get folder name from text field and return it
//             onPressed: () => Navigator.of(context).pop("New Folder"),
//             child: const Text("Create"),
//           ),
//         ],
//       ),
//     );

//     if (name != null && name.isNotEmpty) {
//       // Implement folder creation logic here
//       _showSuccess("Folder '$name' created");
//       _loadFiles(_currentPath);
//     }
//   }

//   void _uploadFiles() async {
//     // file_picker package for actual file upload
//     _showSuccess("Files uploaded successfully");
//     _loadFiles(_currentPath);
//   }

//   void _downloadFile(FileItem file) {
//     // Implement download logic
//     _showSuccess("Downloading ${file.name}");
//   }

//   void _renameFile(FileItem file) async {
//     final newName = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("New Name"),
//         content: TextField(
//           placeholder: const Text("New Name"),
//           initialValue: file.name,
//           autofocus: true,
//         ),
//         actions: [
//           SecondaryButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("Cancel"),
//           ),
//           PrimaryButton(
//             onPressed: () =>
//                 Navigator.of(context).pop("${file.name} (renamed)"),
//             child: const Text("Rename"),
//           ),
//         ],
//       ),
//     );

//     if (newName != null && newName.isNotEmpty) {
//       // Implement rename logic
//       _showSuccess("Renamed to '$newName'");
//       _loadFiles(_currentPath);
//     }
//   }

//   void _deleteFiles(List<FileItem> files) async {
//     final shouldDelete = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Files"),
//         content: Text(
//           "Are you sure you want to delete ${files.length} item(s)",
//         ),
//         actions: [
//           SecondaryButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text("Cancel"),
//           ),
//           PrimaryButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );

//     if (shouldDelete == true) {
//       // Implement delete logic
//       _showSuccess("${files.length} item(s) deleted");
//       _loadFiles(_currentPath);
//     }
//   }

//   void _showFileDetails(FileItem file) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("File Details"),
//         content: Column(
//           mainAxisSize: .min,
//           crossAxisAlignment: .start,
//           children: [
//             Text("Name: ${file.name}"),
//             Text("Type: ${file.isDirectory ? 'Folder' : 'File'}"),
//             if (!file.isDirectory) Text("Size: ${_formatFileSize(file.size)}"),
//             Text("Modified: ${_formatDate(file.modifiedDate)}"),
//             Text("Path: ${file.path}"),
//           ],
//         ),
//         actions: [
//           PrimaryButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("Close"),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatFileSize(int size) {
//     if (size < 1024) return "$size B";
//     if (size < 1024 * 1024) return "${(size / 1024).toStringAsFixed(1)} KB";
//     return "${(size / (1024 * 1024)).toStringAsFixed(1)} MB";
//   }

//   String _formatDate(DateTime date) {
//     return "${date.month}/${date.day}/${date.year}";
//   }

//   void _showSuccess(String message) {
//     showToast(
//       context: context,
//       builder: (BuildContext context, ToastOverlay overlay) {
//         return SurfaceCard(child: Basic(content: Text(message)));
//       },
//       location: ToastLocation.bottomRight,
//     );
//   }

//   void _showError(String message) {
//     showToast(
//       context: context,
//       builder: (BuildContext context, ToastOverlay overlay) {
//         return SurfaceCard(child: Basic(content: Text(message)));
//       },
//       location: ToastLocation.bottomRight,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final selectedFiles = _selectedFiles;

//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header with breadcrumb, search, and actions
//           Flex(
//             direction: Axis.horizontal,
//             spacing: 8,
//             children: [
//               Expanded(
//                 child: Breadcrumb(
//                   separator: Breadcrumb.arrowSeparator,
//                   children: [
//                     for (int i = 0; i < _breadcrumbPaths.length; i++)
//                       i == _breadcrumbPaths.length - 1
//                           ? Text(_breadcrumbPaths[i])
//                           : TextButton(
//                               onPressed: () => _navigateToPath(i),
//                               density: ButtonDensity.compact,
//                               child: i == 0
//                                   ? const Icon(Icons.home)
//                                   : Text(_breadcrumbPaths[i]),
//                             ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: TextField(
//                   placeholder: const Text("Search files..."),
//                   onChanged: _handleSearch,
//                   features: [
//                     InputFeature.leading(
//                       StatedWidget.builder(
//                         builder: (context, states) {
//                           if (states.hovered) {
//                             return const Icon(LucideIcons.search);
//                           } else {
//                             return const Icon(
//                               LucideIcons.search,
//                             ).iconMutedForeground();
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Builder(
//                 builder: (context) {
//                   return SecondaryButton(
//                     density: ButtonDensity.icon,
//                     leading: const Icon(LucideIcons.plus),
//                     child: const Text("New"),
//                     onPressed: () {
//                       showDropdown(
//                         context: context,
//                         builder: (context) {
//                           return DropdownMenu(
//                             children: [
//                               MenuButton(
//                                 onPressed: (_) => _createNewFolder,
//                                 leading: const Icon(Icons.create_new_folder),
//                                 child: const Text("New Folder"),
//                               ),
//                               MenuButton(
//                                 onPressed: (_) => _uploadFiles,
//                                 leading: const Icon(Icons.upload),
//                                 child: const Text("Upload Files"),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           const Divider(),
//           const SizedBox(height: 8),

//           // Selection info and actions
//           if (selectedFiles.isNotEmpty) ...[
//             Flex(
//               direction: Axis.horizontal,
//               spacing: 8,
//               children: [
//                 Text('${selectedFiles.length} item(s) selected'),
//                 const Spacer(),
//                 SecondaryButton(
//                   child: const Text('Download'),
//                   onPressed: () {
//                     for (final file in selectedFiles) {
//                       _downloadFile(file);
//                     }
//                   },
//                 ),
//                 SecondaryButton(
//                   child: const Text('Delete'),
//                   onPressed: () => _deleteFiles(selectedFiles),
//                 ),
//                 SecondaryButton(
//                   onPressed: _deselectAll,
//                   child: const Text('Deselect All'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//           ],

//           // File grid
//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _filteredFiles.isEmpty
//                 ? const Center(child: Text('No files found'))
//                 : GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithMaxCrossAxisExtent(
//                           maxCrossAxisExtent: 200,
//                           crossAxisSpacing: 8,
//                           mainAxisSpacing: 8,
//                           childAspectRatio: 0.8,
//                         ),
//                     itemCount: _filteredFiles.length,
//                     itemBuilder: (context, index) {
//                       final file = _filteredFiles[index];
//                       return FileItemCard(
//                         file: file,
//                         onTap: () => _handleFileTap(file),
//                         onSelectionChanged: () => _toggleFileSelection(file),
//                         onMenuAction: (action) =>
//                             _handleMenuAction(action, file),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _handleMenuAction(String action, FileItem file) {
//     switch (action) {
//       case "download":
//         _downloadFile(file);
//         break;
//       case "rename":
//         _renameFile(file);
//         break;
//       case "delete":
//         _deleteFiles([file]);
//         break;
//     }
//   }
// }

// class FileItemCard extends StatelessWidget {
//   final FileItem file;
//   final VoidCallback onTap;
//   final VoidCallback onSelectionChanged;
//   final Function(String) onMenuAction;

//   const FileItemCard({
//     super.key,
//     required this.file,
//     required this.onTap,
//     required this.onSelectionChanged,
//     required this.onMenuAction,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       padding: const EdgeInsets.all(8),
//       child: Column(
//         children: [
//           // Header with checkbox and menu
//           Flex(
//             direction: Axis.horizontal,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Checkbox(
//                 state: file.isSelected
//                     ? CheckboxState.checked
//                     : CheckboxState.unchecked,
//                 onChanged: (value) => onSelectionChanged(),
//               ),
//               Builder(
//                 builder: (context) {
//                   return IconButton.ghost(
//                     density: ButtonDensity.iconDense,
//                     icon: const Icon(LucideIcons.ellipsis),
//                     onPressed: () {
//                       showDropdown(
//                         context: context,
//                         builder: (context) {
//                           return DropdownMenu(
//                             children: [
//                               MenuButton(
//                                 leading: const Icon(Icons.download),
//                                 child: const Text("Download"),
//                                 onPressed: (_) => onMenuAction('download'),
//                               ),
//                               MenuButton(
//                                 leading: const Icon(Icons.edit),
//                                 child: const Text("Rename"),
//                                 onPressed: (_) => onMenuAction('rename'),
//                               ),
//                               MenuButton(
//                                 leading: const Icon(Icons.delete),
//                                 child: const Text("Delete"),
//                                 onPressed: (_) => onMenuAction('delete'),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),

//           // File icon
//           Icon(
//             file.isDirectory ? LucideIcons.folder : LucideIcons.file,
//             size: 48,
//             color: file.isDirectory ? Colors.blue : Colors.gray,
//           ),

//           const SizedBox(height: 8),

//           // File name
//           Text(file.name).bold(),

//           const SizedBox(height: 8),

//           // File info
//           if (!file.isDirectory)
//             Text(_formatFileSize(file.size)).muted().xSmall(),

//           Text(_formatDate(file.modifiedDate)).muted().xSmall(),
//         ],
//       ),
//     );
//   }

//   String _formatFileSize(int size) {
//     if (size < 1024) return '$size B';
//     if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
//     return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
//   }

//   String _formatDate(DateTime date) {
//     return '${date.month}/${date.day}/${date.year}';
//   }
// }
