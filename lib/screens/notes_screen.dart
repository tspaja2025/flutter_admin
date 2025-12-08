import 'package:shadcn_flutter/shadcn_flutter.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  String? _selectedValue;

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
                  ),
                ),
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
                                  onPressed: (_) {},
                                  child: const Text("Export as JSON"),
                                ),
                                MenuButton(
                                  onPressed: (_) {},
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final FormController controller = FormController();

                        return AlertDialog(
                          title: const Text("New Note"),
                          content: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Form(
                              controller: controller,
                              child: Column(
                                children: [
                                  FormField(
                                    key: FormKey(#title),
                                    label: const Text("Title"),
                                    child: TextField(),
                                  ),
                                  const SizedBox(height: 8),
                                  FormField(
                                    key: FormKey(#category),
                                    label: const Text("Category"),
                                    child: Select<String>(
                                      itemBuilder: (context, item) {
                                        return Text(item);
                                      },
                                      popupConstraints: const BoxConstraints(
                                        maxHeight: 300,
                                        maxWidth: 200,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedValue = value;
                                        });
                                      },
                                      value: _selectedValue,
                                      placeholder: const Text("All Categories"),
                                      popup: SelectPopup(
                                        items: SelectItemList(
                                          children: [
                                            SelectItemButton(
                                              value: "AllCategories",
                                              child: const Text(
                                                "All Categories",
                                              ),
                                            ),
                                            SelectItemButton(
                                              value: "Personal",
                                              child: const Text("Personal"),
                                            ),
                                            SelectItemButton(
                                              value: "Work",
                                              child: const Text("Work"),
                                            ),
                                            SelectItemButton(
                                              value: "Ideas",
                                              child: const Text("Ideas"),
                                            ),
                                          ],
                                        ),
                                      ).call,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  FormField(
                                    key: FormKey(#tags),
                                    label: const Text("Tags"),
                                    child: TextField(),
                                  ),
                                  const SizedBox(height: 8),
                                  FormField(
                                    key: FormKey(#content),
                                    label: const Text("Content"),
                                    child: TextArea(
                                      expandableHeight: true,
                                      initialHeight: 100,
                                    ),
                                  ),
                                ],
                              ),
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
                                Navigator.of(context).pop();
                              },
                              child: const Text("Create Note"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  leading: const Icon(LucideIcons.plus),
                  child: const Text("New Note"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
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
                      _selectedValue = value;
                    });
                  },
                  value: _selectedValue,
                  placeholder: const Text("All Categories"),
                  popup: SelectPopup(
                    items: SelectItemList(
                      children: [
                        SelectItemButton(
                          value: "AllCategories",
                          child: const Text("All Categories"),
                        ),
                        SelectItemButton(
                          value: "Personal",
                          child: const Text("Personal"),
                        ),
                        SelectItemButton(
                          value: "Work",
                          child: const Text("Work"),
                        ),
                        SelectItemButton(
                          value: "Ideas",
                          child: const Text("Ideas"),
                        ),
                      ],
                    ),
                  ).call,
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
                      _selectedValue = value;
                    });
                  },
                  value: _selectedValue,
                  placeholder: const Text("Recently Updated"),
                  popup: SelectPopup(
                    items: SelectItemList(
                      children: [
                        SelectItemButton(
                          value: "RecentlyUpdated",
                          child: const Text("Recently Updated"),
                        ),
                        SelectItemButton(
                          value: "RecentlyCreated",
                          child: const Text("Recently Created"),
                        ),
                        SelectItemButton(
                          value: "Title(A-Z)",
                          child: const Text("Title (A-Z)"),
                        ),
                        SelectItemButton(
                          value: "Category",
                          child: const Text("Category"),
                        ),
                      ],
                    ),
                  ).call,
                ),
                const Spacer(),
                ButtonGroup(
                  children: [
                    IconButton.outline(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.grid3x3),
                    ),
                    IconButton.outline(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.list),
                    ),
                  ],
                ),
                OutlineButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        ColorDerivative color = ColorDerivative.fromColor(
                          Colors.blue,
                        );
                        final FormController controller = FormController();

                        return AlertDialog(
                          title: const Text("Manage Categories"),
                          content: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Form(
                              controller: controller,
                              child: Column(
                                children: [
                                  FormField(
                                    key: FormKey(#categoryName),
                                    label: const Text("Category Name"),
                                    child: TextField(),
                                  ),
                                  const SizedBox(height: 8),
                                  FormField(
                                    key: FormKey(#categoryColor),
                                    label: const Text("Category Color"),
                                    child: ColorInput(
                                      value: color,
                                      orientation: .horizontal,
                                      promptMode: .popover,
                                      onChanged: (value) {
                                        setState(() {
                                          color = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  OutlinedContainer(
                                    padding: const .all(8),
                                    width: MediaQuery.of(context).size.width,
                                    height: 54,
                                    child: Row(
                                      mainAxisAlignment: .spaceBetween,
                                      children: [
                                        Wrap(
                                          spacing: 8,
                                          children: [
                                            Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: .circular(50),
                                              ),
                                            ),
                                            const Text("Personal"),
                                          ],
                                        ),
                                        IconButton.ghost(
                                          onPressed: () {},
                                          icon: const Icon(LucideIcons.trash2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  OutlinedContainer(
                                    padding: const .all(8),
                                    width: MediaQuery.of(context).size.width,
                                    height: 54,
                                    child: Row(
                                      mainAxisAlignment: .spaceBetween,
                                      children: [
                                        Wrap(
                                          spacing: 8,
                                          children: [
                                            Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                color: Colors.purple,
                                                borderRadius: .circular(50),
                                              ),
                                            ),
                                            const Text("Work"),
                                          ],
                                        ),
                                        IconButton.ghost(
                                          onPressed: () {},
                                          icon: const Icon(LucideIcons.trash2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  OutlinedContainer(
                                    padding: const .all(8),
                                    width: MediaQuery.of(context).size.width,
                                    height: 54,
                                    child: Row(
                                      mainAxisAlignment: .spaceBetween,
                                      children: [
                                        Wrap(
                                          spacing: 8,
                                          children: [
                                            Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: .circular(50),
                                              ),
                                            ),
                                            const Text("Ideas"),
                                          ],
                                        ),
                                        IconButton.ghost(
                                          onPressed: () {},
                                          icon: const Icon(LucideIcons.trash2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                                Navigator.of(context).pop();
                              },
                              child: const Text("Create Category"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  leading: const Icon(LucideIcons.plus),
                  child: const Text("Category"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Column(
                  children: [
                    const Text("No notes yet").bold().large(),
                    const SizedBox(height: 8),
                    const Text("Create your first note to get started").muted(),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final FormController controller = FormController();

                            return AlertDialog(
                              title: const Text("New Note"),
                              content: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 400,
                                ),
                                child: Form(
                                  controller: controller,
                                  child: Column(
                                    children: [
                                      FormField(
                                        key: FormKey(#title),
                                        label: const Text("Title"),
                                        child: TextField(),
                                      ),
                                      const SizedBox(height: 8),
                                      FormField(
                                        key: FormKey(#category),
                                        label: const Text("Category"),
                                        child: Select<String>(
                                          itemBuilder: (context, item) {
                                            return Text(item);
                                          },
                                          popupConstraints:
                                              const BoxConstraints(
                                                maxHeight: 300,
                                                maxWidth: 200,
                                              ),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedValue = value;
                                            });
                                          },
                                          value: _selectedValue,
                                          placeholder: const Text(
                                            "All Categories",
                                          ),
                                          popup: SelectPopup(
                                            items: SelectItemList(
                                              children: [
                                                SelectItemButton(
                                                  value: "AllCategories",
                                                  child: const Text(
                                                    "All Categories",
                                                  ),
                                                ),
                                                SelectItemButton(
                                                  value: "Personal",
                                                  child: const Text("Personal"),
                                                ),
                                                SelectItemButton(
                                                  value: "Work",
                                                  child: const Text("Work"),
                                                ),
                                                SelectItemButton(
                                                  value: "Ideas",
                                                  child: const Text("Ideas"),
                                                ),
                                              ],
                                            ),
                                          ).call,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      FormField(
                                        key: FormKey(#tags),
                                        label: const Text("Tags"),
                                        child: TextField(),
                                      ),
                                      const SizedBox(height: 8),
                                      FormField(
                                        key: FormKey(#content),
                                        label: const Text("Content"),
                                        child: TextArea(
                                          expandableHeight: true,
                                          initialHeight: 100,
                                        ),
                                      ),
                                    ],
                                  ),
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
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Create Note"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text("Create Your First Note"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Example Note
            SizedBox(
              width: 300,
              child: Card(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        const Text("First Note"),
                        Wrap(
                          spacing: 8,
                          children: [
                            IconButton.ghost(
                              onPressed: () {},
                              density: .iconDense,
                              icon: const Icon(LucideIcons.pin, size: 16),
                            ),
                            IconButton.ghost(
                              onPressed: () {},
                              density: .iconDense,
                              icon: const Icon(LucideIcons.pencil, size: 16),
                            ),
                            IconButton.ghost(
                              onPressed: () {},
                              density: .iconDense,
                              icon: const Icon(LucideIcons.trash2, size: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text("This is a first note."),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Wrap(
                          spacing: 8,
                          children: [
                            Chip(child: const Text("Personal")),
                            Chip(child: const Text("Tags")),
                          ],
                        ),
                        const Text("4/12/2025").muted().small(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
