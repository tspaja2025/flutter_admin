import 'dart:convert';
import 'package:shadcn_flutter/shadcn_flutter.dart';

// TODO:
// Overflow issue

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  final List<Note> _notes = [];
  final List<Category> _categories = [
    Category(
      id: "1",
      name: "Personal",
      color: ColorDerivative.fromColor(Colors.blue),
    ),
    Category(
      id: "2",
      name: "work",
      color: ColorDerivative.fromColor(Colors.purple),
    ),
    Category(
      id: "3",
      name: "Ideas",
      color: ColorDerivative.fromColor(Colors.green),
    ),
  ];

  String? _selectedCategory;
  String? _selectedSort = "Recently Updated";
  bool _isGridView = false;
  String _searchQuery = "";

  List<Note> _getFilteredNotes() {
    List<Note> filtered = List.from(_notes);

    // Search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((note) {
        final query = _searchQuery.toLowerCase();
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query) ||
            note.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    // Category filter
    if (_selectedCategory != null && _selectedCategory != 'AllCategories') {
      filtered = filtered
          .where((note) => note.category == _selectedCategory)
          .toList();
    }

    // Sorting
    filtered.sort((a, b) {
      switch (_selectedSort) {
        case 'RecentlyUpdated':
          return b.updatedAt.compareTo(a.updatedAt);
        case 'RecentlyCreated':
          return b.createdAt.compareTo(a.createdAt);
        case 'Title(A-Z)':
          return a.title.compareTo(b.title);
        case 'Category':
          return a.category.compareTo(b.category);
        default:
          return b.updatedAt.compareTo(a.updatedAt);
      }
    });

    // Pinned notes to top
    filtered.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return 0;
    });

    return filtered;
  }

  void _showEditNoteDialog(Note note) {
    String? selectedCategory = note.category;

    // Create controllers for each field
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);
    final tagsController = TextEditingController(text: note.tags.join(', '));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Note"),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Title"),
                    const SizedBox(height: 4),
                    TextField(
                      controller: titleController,
                      placeholder: const Text("Enter title"),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Category field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Category"),
                    const SizedBox(height: 4),
                    Select<String>(
                      itemBuilder: (context, item) {
                        return Text(item);
                      },
                      popupConstraints: const BoxConstraints(
                        maxHeight: 300,
                        maxWidth: 200,
                      ),
                      onChanged: (value) {
                        selectedCategory = value;
                      },
                      value: selectedCategory,
                      placeholder: const Text("Select Category"),
                      popup: SelectPopup(
                        items: SelectItemList(
                          children: [
                            ..._categories.map((category) {
                              return SelectItemButton(
                                value: category.name,
                                child: Text(category.name),
                              );
                            }),
                          ],
                        ),
                      ).call,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Tags field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tags (comma-separated)"),
                    const SizedBox(height: 4),
                    TextField(
                      controller: tagsController,
                      placeholder: const Text("tag1, tag2, tag3"),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Content field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Content"),
                    const SizedBox(height: 4),
                    TextArea(
                      controller: contentController,
                      expandableHeight: true,
                      initialHeight: 100,
                      placeholder: const Text("Enter note content"),
                    ),
                  ],
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
              onPressed: () {
                final title = titleController.text.trim();
                final content = contentController.text.trim();
                final tagsText = tagsController.text.trim();

                if (title.isEmpty) {
                  _showSnackBar('Title is required');
                  return;
                }

                if (content.isEmpty) {
                  _showSnackBar('Content is required');
                  return;
                }

                final tags = tagsText
                    .split(',')
                    .map((tag) => tag.trim())
                    .where((tag) => tag.isNotEmpty)
                    .toList();

                final updatedNote = note.copyWith(
                  title: title,
                  content: content,
                  category: selectedCategory ?? note.category,
                  tags: tags,
                  updatedAt: DateTime.now(),
                );

                setState(() {
                  final index = _notes.indexWhere((n) => n.id == note.id);
                  if (index != -1) {
                    _notes[index] = updatedNote;
                  }
                });

                Navigator.of(context).pop();
                _showSnackBar('Note updated successfully');
              },
              child: const Text("Update Note"),
            ),
          ],
        );
      },
    );
  }

  void _showManageCategoriesDialog() {
    ColorDerivative color = ColorDerivative.fromColor(Colors.blue);
    final categoryNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Manage Categories"),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category name field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Category Name"),
                    const SizedBox(height: 4),
                    TextField(
                      controller: categoryNameController,
                      placeholder: const Text("Enter category name"),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Color picker
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Category Color"),
                    const SizedBox(height: 4),
                    ColorInput(
                      value: color,
                      orientation: .horizontal,
                      promptMode: .popover,
                      onChanged: (value) {
                        color = value;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Existing categories
                ..._categories.map((category) {
                  return OutlinedContainer(
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    height: 54,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 8,
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: category.color.toColor(),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            Text(category.name),
                          ],
                        ),
                        IconButton.ghost(
                          onPressed: () {
                            _deleteCategory(category);
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(LucideIcons.trash2),
                        ),
                      ],
                    ),
                  );
                }),
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
              onPressed: () {
                final name = categoryNameController.text.trim();
                if (name.isEmpty) {
                  _showSnackBar('Category name is required');
                  return;
                }

                // Check if category already exists
                if (_categories.any(
                  (c) => c.name.toLowerCase() == name.toLowerCase(),
                )) {
                  _showSnackBar('Category already exists');
                  return;
                }

                final newCategory = Category(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  color: color,
                );

                setState(() {
                  _categories.add(newCategory);
                });

                Navigator.of(context).pop();
                _showSnackBar('Category created successfully');
              },
              child: const Text("Create Category"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Note"),
          content: const Text("Are you sure you want to delete this note?"),
          actions: [
            SecondaryButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            DestructiveButton(
              onPressed: () {
                setState(() {
                  _notes.removeWhere((n) => n.id == note.id);
                });
                Navigator.of(context).pop();
                _showSnackBar('Note deleted successfully');
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _togglePinNote(Note note) {
    setState(() {
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note.copyWith(isPinned: !note.isPinned);
      }
    });
  }

  void _deleteCategory(Category category) {
    // Check if any notes use this category
    final notesUsingCategory = _notes.any(
      (note) => note.category == category.name,
    );

    if (notesUsingCategory) {
      _showSnackBar('Cannot delete category: Notes are using it');
      return;
    }

    setState(() {
      _categories.removeWhere((c) => c.id == category.id);
    });
    _showSnackBar('Category deleted successfully');
  }

  void _exportNotes(String format) {
    if (_notes.isEmpty) {
      _showSnackBar('No notes to export');
      return;
    }

    String exportData;
    if (format == 'json') {
      final notesJson = _notes.map((note) {
        return {
          'id': note.id,
          'title': note.title,
          'content': note.content,
          'category': note.category,
          'tags': note.tags,
          'createdAt': note.createdAt.toIso8601String(),
          'updatedAt': note.updatedAt.toIso8601String(),
          'isPinned': note.isPinned,
        };
      }).toList();
      exportData = const JsonEncoder.withIndent('  ').convert(notesJson);
    } else {
      exportData = _notes
          .map((note) {
            return '''
 Title: ${note.title}
 Category: ${note.category}
 Tags: ${note.tags.join(', ')}
 Created: ${_formatDate(note.createdAt)}
 Updated: ${_formatDate(note.updatedAt)}
 Pinned: ${note.isPinned ? 'Yes' : 'No'}

 ${note.content}

 ${'-' * 40}
 ''';
          })
          .join('\n');
    }

    // In a real app, you would save this to a file
    // For now, we'll just show it in a dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Exported as ${format.toUpperCase()}"),
          content: SizedBox(
            width: 500,
            height: 400,
            child: TextField(
              initialValue: exportData,
              readOnly: true,
              maxLines: null,
            ),
          ),
          actions: [
            PrimaryButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );

    _showSnackBar('Notes exported successfully');
  }

  void _showSnackBar(String message) {
    showToast(
      context: context,
      builder: (context, overlay) {
        return SurfaceCard(child: Basic(content: Text(message)));
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = _getFilteredNotes();
    final hasNotes = filteredNotes.isNotEmpty;

    return Scaffold(
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            // Search / Export / New Note Row
            _buildActionsRow(),
            const SizedBox(height: 8),
            // Filters row
            _buildFiltersRow(),
            const SizedBox(height: 8),
            // Notes Grid/List or Empty State
            if (!hasNotes) _buildNoNotes(),
            if (hasNotes) _buildNotesList(filteredNotes),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsRow() {
    return Row(
      mainAxisAlignment: .spaceBetween,
      spacing: 8,
      children: [
        SizedBox(
          width: 200,
          child: TextField(
            placeholder: const Text("Search notes..."),
            features: [
              InputFeature.leading(
                StatedWidget.builder(
                  builder: (context, states) {
                    return const Icon(LucideIcons.search);
                  },
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        Wrap(
          spacing: 8,
          children: [
            Builder(
              builder: (context) {
                return OutlineButton(
                  onPressed: () {
                    showDropdown(
                      context: context,
                      builder: (context) {
                        return DropdownMenu(
                          children: [
                            MenuButton(
                              onPressed: (_) {
                                _exportNotes('json');
                                Navigator.of(context).pop();
                              },
                              child: const Text("Export as JSON"),
                            ),
                            MenuButton(
                              onPressed: (_) {
                                _exportNotes('text');
                                Navigator.of(context).pop();
                              },
                              child: const Text("Export as Text"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  leading: const Icon(LucideIcons.download),
                  child: const Text("Export"),
                );
              },
            ),
            PrimaryButton(
              onPressed: _showCreateNoteDialog,
              leading: const Icon(LucideIcons.plus),
              child: const Text("New Note"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFiltersRow() {
    return Row(
      spacing: 8,
      children: [
        Select<String>(
          itemBuilder: (context, item) {
            return Text(item);
          },
          popupConstraints: const BoxConstraints(maxHeight: 300, maxWidth: 200),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
          value: _selectedCategory,
          placeholder: const Text("All Categories"),
          popup: SelectPopup(
            items: SelectItemList(
              children: [
                const SelectItemButton(
                  value: "AllCategories",
                  child: Text("All Categories"),
                ),
                ..._categories.map((category) {
                  return SelectItemButton(
                    value: category.name,
                    child: Text(category.name),
                  );
                }),
              ],
            ),
          ).call,
        ),
        Select<String>(
          itemBuilder: (context, item) {
            return Text(item);
          },
          popupConstraints: const BoxConstraints(maxHeight: 300, maxWidth: 200),
          onChanged: (value) {
            setState(() {
              _selectedSort = value;
            });
          },
          value: _selectedSort,
          placeholder: const Text("Recently Updated"),
          popup: SelectPopup(
            items: SelectItemList(
              children: const [
                SelectItemButton(
                  value: "RecentlyUpdated",
                  child: Text("Recently Updated"),
                ),
                SelectItemButton(
                  value: "RecentlyCreated",
                  child: Text("Recently Created"),
                ),
                SelectItemButton(
                  value: "Title(A-Z)",
                  child: Text("Title (A-Z)"),
                ),
                SelectItemButton(value: "Category", child: Text("Category")),
              ],
            ),
          ).call,
        ),
        const Spacer(),
        ButtonGroup(
          children: [
            IconButton.outline(
              onPressed: () {
                setState(() {
                  _isGridView = true;
                });
              },
              icon: const Icon(LucideIcons.grid3x3),
              variance: _isGridView
                  ? ButtonVariance.primary
                  : ButtonVariance.outline,
            ),
            IconButton.outline(
              onPressed: () {
                setState(() {
                  _isGridView = false;
                });
              },
              icon: const Icon(LucideIcons.list),
              variance: !_isGridView
                  ? ButtonVariance.primary
                  : ButtonVariance.outline,
            ),
          ],
        ),
        OutlineButton(
          onPressed: _showManageCategoriesDialog,
          leading: const Icon(LucideIcons.plus),
          child: const Text("Category"),
        ),
      ],
    );
  }

  Widget _buildNotesList(List<Note> notes) {
    if (_isGridView) {
      return Expanded(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return _buildNoteCard(notes[index]);
          },
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildNoteCard(notes[index]),
            );
          },
        ),
      );
    }
  }

  Widget _buildNoteCard(Note note) {
    return SizedBox(
      width: _isGridView ? null : double.infinity,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Wrap(
                  spacing: 4,
                  children: [
                    IconButton.ghost(
                      onPressed: () {
                        _togglePinNote(note);
                      },
                      density: .iconDense,
                      icon: Icon(
                        note.isPinned ? LucideIcons.pinOff : LucideIcons.pin,
                        size: 16,
                        color: note.isPinned ? Colors.amber : null,
                      ),
                    ),
                    IconButton.ghost(
                      onPressed: () {
                        _showEditNoteDialog(note);
                      },
                      density: .iconDense,
                      icon: const Icon(LucideIcons.pencil, size: 16),
                    ),
                    IconButton.ghost(
                      onPressed: () {
                        _showDeleteConfirmation(note);
                      },
                      density: .iconDense,
                      icon: const Icon(LucideIcons.trash2, size: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(note.content, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(child: Text(note.category)),
                    ...note.tags.take(2).map((tag) {
                      return Chip(child: Text(tag));
                    }),
                    if (note.tags.length > 2)
                      Chip(child: Text('+${note.tags.length - 2}')),
                  ],
                ),
                Text(
                  _formatDate(note.updatedAt),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.mutedForeground,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoNotes() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text("No notes yet").bold().large(),
            const SizedBox(height: 8),
            const Text("Create your first note to get started").muted(),
            const SizedBox(height: 16),
            PrimaryButton(
              onPressed: _showCreateNoteDialog,
              child: const Text("Create Your First Note"),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateNoteDialog() {
    String? selectedCategory;

    // Create controllers for each field
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final tagsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Note"),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Title"),
                    const SizedBox(height: 4),
                    TextField(
                      controller: titleController,
                      placeholder: const Text("Enter title"),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Category field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Category"),
                    const SizedBox(height: 4),
                    Select<String>(
                      itemBuilder: (context, item) {
                        return Text(item);
                      },
                      popupConstraints: const BoxConstraints(
                        maxHeight: 300,
                        maxWidth: 200,
                      ),
                      onChanged: (value) {
                        selectedCategory = value;
                      },
                      value: selectedCategory,
                      placeholder: const Text("Select Category"),
                      popup: SelectPopup(
                        items: SelectItemList(
                          children: [
                            ..._categories.map((category) {
                              return SelectItemButton(
                                value: category.name,
                                child: Text(category.name),
                              );
                            }),
                          ],
                        ),
                      ).call,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Tags field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tags (comma-separated)"),
                    const SizedBox(height: 4),
                    TextField(
                      controller: tagsController,
                      placeholder: const Text("tag1, tag2, tag3"),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Content field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Content"),
                    const SizedBox(height: 4),
                    TextArea(
                      controller: contentController,
                      expandableHeight: true,
                      initialHeight: 100,
                      placeholder: const Text("Enter note content"),
                    ),
                  ],
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
              onPressed: () {
                final title = titleController.text.trim();
                final content = contentController.text.trim();
                final tagsText = tagsController.text.trim();

                if (title.isEmpty) {
                  _showSnackBar('Title is required');
                  return;
                }

                if (content.isEmpty) {
                  _showSnackBar('Content is required');
                  return;
                }

                final tags = tagsText
                    .split(',')
                    .map((tag) => tag.trim())
                    .where((tag) => tag.isNotEmpty)
                    .toList();

                final newNote = Note(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: title,
                  content: content,
                  category: selectedCategory ?? _categories.first.name,
                  tags: tags,
                );

                setState(() {
                  _notes.add(newNote);
                });

                Navigator.of(context).pop();
                _showSnackBar('Note created successfully');
              },
              child: const Text("Create Note"),
            ),
          ],
        );
      },
    );
  }
}

class Note {
  final String id;
  String title;
  String content;
  String category;
  List<String> tags;
  DateTime createdAt;
  DateTime updatedAt;
  bool isPinned;
  ColorDerivative color;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.tags = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isPinned = false,
    ColorDerivative? color,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       color = color ?? ColorDerivative.fromColor(Colors.blue);

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
    ColorDerivative? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      color: color ?? this.color,
    );
  }
}

class Category {
  final String id;
  String name;
  ColorDerivative color;

  Category({required this.id, required this.name, required this.color});

  Category copyWith({String? id, String? name, ColorDerivative? color}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }
}
