import 'dart:convert';
import 'package:flutter/material.dart' as material;
import 'package:shadcn_flutter/shadcn_flutter.dart';

// -----------------------------
// Models
// -----------------------------
class Note {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tags': tags,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      tags: List<String>.from(json['tags']),
    );
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  final List<Note> _notes = [];
  String? selectedCategory;
  String? selectedUpdate;
  String _searchQuery = '';
  bool _isGridView = true;
  // Getter for hasNotes
  bool get hasNotes => _notes.isNotEmpty;

  // Filtered notes based on search and filters
  List<Note> get _filteredNotes {
    List<Note> filtered = List.from(_notes);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (note) =>
                note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                note.content.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                note.tags.any(
                  (tag) =>
                      tag.toLowerCase().contains(_searchQuery.toLowerCase()),
                ),
          )
          .toList();
    }

    // Apply category filter
    if (selectedCategory != null) {
      filtered = filtered
          .where((note) => note.category == selectedCategory)
          .toList();
    }

    // Apply sort filter
    filtered = _sortNotes(filtered);

    return filtered;
  }

  // Sort notes based on selectedUpdate
  List<Note> _sortNotes(List<Note> notes) {
    switch (selectedUpdate) {
      case 'recently_updated':
        notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case 'recently_created':
        notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'titleAZ':
        notes.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'category':
        notes.sort((a, b) => a.category.compareTo(b.category));
        break;
    }
    return notes;
  }

  // Get unique categories from notes
  List<String> get _categories {
    final categories = _notes.map((note) => note.category).toSet().toList();
    categories.sort();
    return categories;
  }

  @override
  void initState() {
    super.initState();
    // Load sample data or from storage
    _loadSampleNotes();
  }

  void _loadSampleNotes() {
    final sampleNotes = [
      Note(
        id: '1',
        title: 'Meeting Notes',
        content: 'Discuss project timeline and deliverables.',
        category: 'work',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
        tags: ['meeting', 'project'],
      ),
      Note(
        id: '2',
        title: 'Shopping List',
        content: 'Milk, Eggs, Bread, Fruits',
        category: 'personal',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
        tags: ['shopping', 'grocery'],
      ),
      Note(
        id: '3',
        title: 'App Ideas',
        content:
            '1. Task management app with AI\n2. Recipe sharing platform\n3. Budget tracker',
        category: 'ideas',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        updatedAt: DateTime.now(),
        tags: ['ideas', 'projects'],
      ),
    ];

    setState(() {
      _notes.addAll(sampleNotes);
    });
  }

  void _addNewNote() {
    // In a real app,  navigate to a note editing screen
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Note',
      content: 'Start writing your note here...',
      category: selectedCategory ?? 'personal',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: [],
    );

    setState(() {
      _notes.insert(0, newNote);
    });

    // Show success message
    showToast(
      context: context,
      builder: (context, overlay) {
        return Alert(
          title: const Text('Note Created'),
          content: const Text('Your new note has been created.'),
        );
      },
    );
  }

  void _editNote(Note note) {
    // In a real app, navigate to a note editing screen
    showDialog(
      context: context,
      builder: (context) {
        String editedTitle = note.title;
        String editedContent = note.content;

        return AlertDialog(
          title: const Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                placeholder: const Text('Title'),
                initialValue: editedTitle,
                onChanged: (value) => editedTitle = value,
              ),
              const SizedBox(height: 12),
              TextField(
                placeholder: const Text('Content'),
                initialValue: editedContent,
                onChanged: (value) => editedContent = value,
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            SecondaryButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              onPressed: () {
                final updatedNote = note.copyWith(
                  title: editedTitle,
                  content: editedContent,
                  updatedAt: DateTime.now(),
                );

                setState(() {
                  final index = _notes.indexWhere((n) => n.id == note.id);
                  if (index != -1) {
                    _notes[index] = updatedNote;
                  }
                });

                Navigator.pop(context);
                showToast(
                  context: context,
                  builder: (context, overlay) {
                    return Alert(
                      title: const Text('Note Updated'),
                      content: const Text('Your note has been saved.'),
                    );
                  },
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: Text('Are you sure you want to delete "${note.title}"?'),
          actions: [
            SecondaryButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              onPressed: () {
                setState(() {
                  _notes.removeWhere((n) => n.id == note.id);
                });
                Navigator.pop(context);
                showToast(
                  context: context,
                  builder: (context, overlay) {
                    return Alert(
                      title: const Text('Note Deleted'),
                      content: const Text('The note has been removed.'),
                    );
                  },
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportAsJson() async {
    try {
      final notesJson = _notes.map((note) => note.toJson()).toList();
      final jsonString = jsonEncode(notesJson);

      // In a real app, you would save this to a file
      // For now, just show a success message
      showToast(
        context: context,
        builder: (context, overlay) {
          return Alert(
            title: const Text('Export Successful'),
            content: const Text('Notes exported as JSON.'),
          );
        },
      );

      // Print to console for demonstration
      print('Exported JSON:\n$jsonString');
    } catch (e) {
      showToast(
        context: context,
        builder: (context, overlay) {
          return Alert(
            title: const Text('Export Failed'),
            content: Text('Error: ${e.toString()}'),
          );
        },
      );
    }
  }

  Future<void> _exportAsText() async {
    try {
      final textContent = _notes
          .map((note) {
            return '''
 Title: ${note.title}
 Category: ${note.category}
 Created: ${note.createdAt.toString()}
 Updated: ${note.updatedAt.toString()}
 Tags: ${note.tags.join(', ')}
 Content:
 ${note.content}

 ${'=' * 40}
 ''';
          })
          .join('\n');

      showToast(
        context: context,
        builder: (context, overlay) {
          return Alert(
            title: const Text('Export Successful'),
            content: const Text('Notes exported as text.'),
          );
        },
      );

      // Print to console for demonstration
      print('Exported Text:\n$textContent');
    } catch (e) {
      showToast(
        context: context,
        builder: (context, overlay) {
          return Alert(
            title: const Text('Export Failed'),
            content: Text('Error: ${e.toString()}'),
          );
        },
      );
    }
  }

  void _addNewCategory() {
    showDialog(
      context: context,
      builder: (context) {
        String newCategory = '';

        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            placeholder: const Text('Category name'),
            onChanged: (value) => newCategory = value,
          ),
          actions: [
            SecondaryButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              onPressed: () {
                if (newCategory.isNotEmpty) {
                  // In a real app, you would save this category
                  // For now, just show a message
                  showToast(
                    context: context,
                    builder: (context, overlay) {
                      return Alert(
                        title: const Text('Category Added'),
                        content: Text('"$newCategory" has been added.'),
                      );
                    },
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    }
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Flex(
            direction: .horizontal,
            spacing: 8,
            children: [
              Expanded(
                child: TextField(
                  placeholder: const Text("Search Notes..."),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  features: [
                    InputFeature.leading(
                      StatedWidget.builder(
                        builder: (context, states) {
                          if (states.hovered) {
                            return const Icon(LucideIcons.search);
                          } else {
                            return const Icon(
                              LucideIcons.search,
                            ).iconMutedForeground();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SecondaryButton(
                onPressed: _addNewNote,
                leading: const Icon(LucideIcons.plus),
                child: const Text("New Note"),
              ),
              Builder(
                builder: (context) {
                  return OutlineButton(
                    leading: const Icon(LucideIcons.download),
                    child: const Text("Export"),
                    onPressed: () {
                      showDropdown(
                        context: context,
                        builder: (context) {
                          return DropdownMenu(
                            children: [
                              MenuButton(
                                onPressed: (_) => _exportAsJson(),
                                child: const Text("Export as JSON"),
                              ),
                              MenuButton(
                                onPressed: (_) => _exportAsText(),
                                child: const Text("Export as Text"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Flex(
            direction: .horizontal,
            mainAxisAlignment: .spaceBetween,
            children: [
              Wrap(
                spacing: 8,
                children: [
                  Select<String>(
                    itemBuilder: (context, item) {
                      return Text(item);
                    },
                    popupConstraints: const BoxConstraints(
                      maxHeight: 300,
                      maxWidth: 200,
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    value: selectedCategory,
                    placeholder: const Text("All Categories"),
                    popup: SelectPopup(
                      items: SelectItemList(
                        children: [
                          const SelectItemButton(
                            value: null,
                            child: Text("All Categories"),
                          ),
                          ..._categories.map((category) {
                            return SelectItemButton(
                              value: category,
                              child: Text(category),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  Select<String>(
                    itemBuilder: (context, item) {
                      return Text(item);
                    },
                    popupConstraints: const BoxConstraints(
                      maxHeight: 300,
                      maxWidth: 200,
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedUpdate = value;
                      });
                    },
                    value: selectedUpdate,
                    placeholder: const Text("Recently Updated"),
                    popup: const SelectPopup(
                      items: SelectItemList(
                        children: [
                          SelectItemButton(
                            value: null,
                            child: Text("Recently Updated"),
                          ),
                          SelectItemButton(
                            value: "recently_updated",
                            child: Text("Recently Updated"),
                          ),
                          SelectItemButton(
                            value: "recently_created",
                            child: Text("Recently Created"),
                          ),
                          SelectItemButton(
                            value: "titleAZ",
                            child: Text("Title (A-Z)"),
                          ),
                          SelectItemButton(
                            value: "category",
                            child: Text("Category"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: [
                  IconButton.outline(
                    density: ButtonDensity.icon,
                    onPressed: () {
                      setState(() {
                        _isGridView = true;
                      });
                    },
                    icon: const Icon(LucideIcons.grid3x3),
                    // selected: _isGridView,
                  ),
                  IconButton.outline(
                    onPressed: () {
                      setState(() {
                        _isGridView = false;
                      });
                    },
                    icon: const Icon(LucideIcons.list),
                    // selected: !_isGridView,
                  ),
                  OutlineButton(
                    onPressed: _addNewCategory,
                    leading: const Icon(LucideIcons.plus),
                    child: const Text("Category"),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Card(
              padding: const .all(16),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  if (!hasNotes)
                    Center(
                      child: Column(
                        children: [
                          const Text('No notes yet').semiBold(),
                          const SizedBox(height: 4),
                          const Text(
                            'Create your first note to get started.',
                          ).muted().small(),
                          const SizedBox(height: 16),
                          PrimaryButton(
                            onPressed: _addNewNote,
                            child: const Text("Create your first note"),
                          ),
                        ],
                      ),
                    ),
                  if (hasNotes)
                    Expanded(
                      child: _isGridView ? _buildNoteGrid() : _buildNoteList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteGrid() {
    if (_filteredNotes.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Text('No notes found').semiBold(),
            const SizedBox(height: 4),
            const Text('Try changing your search or filters.').muted().small(),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: _filteredNotes.length,
      itemBuilder: (context, index) {
        final note = _filteredNotes[index];
        return Card(
          padding: const .all(12),
          child: material.InkWell(
            onTap: () => _editNote(note),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Expanded(child: Text(note.title).semiBold().small()),
                    IconButton.outline(
                      density: ButtonDensity.icon,
                      onPressed: () => _deleteNote(note),
                      icon: const Icon(LucideIcons.trash2, size: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  note.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ).small().muted(),
                const Spacer(),
                Wrap(
                  spacing: 4,
                  children: [
                    Container(
                      padding: const .symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(note.category).small(),
                    ),
                    ...note.tags.map(
                      (tag) => Container(
                        padding: const .symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.mutedForeground.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('#$tag').small().muted(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Updated ${_formatDate(note.updatedAt)}').xSmall().muted(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoteList() {
    if (_filteredNotes.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Text('No notes found').semiBold(),
            const SizedBox(height: 4),
            const Text('Try changing your search or filters.').muted().small(),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _filteredNotes.length,
      itemBuilder: (context, index) {
        final note = _filteredNotes[index];
        return Card(
          padding: const .all(12),
          child: material.InkWell(
            onTap: () => _editNote(note),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(note.title).semiBold(),
                      const SizedBox(height: 4),
                      Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ).small().muted(),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          Text(note.category).small(),
                          ...note.tags.map(
                            (tag) => Text('#$tag').small().muted(),
                          ),
                          Text(
                            'Updated ${_formatDate(note.updatedAt)}',
                          ).xSmall().muted(),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton.outline(
                  density: ButtonDensity.icon,
                  onPressed: () => _deleteNote(note),
                  icon: const Icon(LucideIcons.trash2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
