import 'package:shadcn_flutter/shadcn_flutter.dart';

// TODO:
// Fix event positioning on week / day view
// Overflow issue

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  bool _allDay = false;
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  String? _selectedColor;
  CalendarViewMode _viewMode = CalendarViewMode.month;
  final DateTime _selectedDate = DateTime.now();

  final List<CalendarEvent> _events = [];
  final Map<DateTime, List<CalendarEvent>> _eventsByDate = {};

  void _changeView(CalendarViewMode mode) {
    setState(() {
      _viewMode = mode;
    });
  }

  void _navigateToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _navigateToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _goToToday() {
    setState(() {
      _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
    });
  }

  // Color options for events
  final List<String> _colorOptions = [
    'Blue',
    'Green',
    'Red',
    'Yellow',
    'Purple',
    'Orange',
  ];

  Color _getColorFromString(String colorName) {
    switch (colorName) {
      case 'Blue':
        return Colors.blue;
      case 'Green':
        return Colors.green;
      case 'Red':
        return Colors.red;
      case 'Yellow':
        return Colors.yellow;
      case 'Purple':
        return Colors.purple;
      case 'Orange':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  void _addEvent(CalendarEvent event) {
    setState(() {
      _events.add(event);
      _organizeEventsByDate();
    });
  }

  void _organizeEventsByDate() {
    _eventsByDate.clear();
    for (var event in _events) {
      final date = DateTime(
        event.startDate.year,
        event.startDate.month,
        event.startDate.day,
      );
      if (!_eventsByDate.containsKey(date)) {
        _eventsByDate[date] = [];
      }
      _eventsByDate[date]!.add(event);
    }
  }

  void _showAddEventDialog() {
    final FormController controller = FormController();

    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(hours: 1));

    DateTime startTime = startDate;
    DateTime endTime = endDate;

    bool allDay = _allDay;
    String? selectedColor = _selectedColor;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void updateStartDate(DateTime? value) {
              if (value == null) return;
              startDate = DateTime(
                value.year,
                value.month,
                value.day,
                startTime.hour,
                startTime.minute,
              );

              // Auto-fix endDate
              if (endDate.isBefore(startDate)) {
                endDate = startDate.add(const Duration(hours: 1));
                endTime = endDate;
              }

              setDialogState(() {});
            }

            void updateEndDate(DateTime? value) {
              if (value == null) return;
              endDate = DateTime(
                value.year,
                value.month,
                value.day,
                endTime.hour,
                endTime.minute,
              );

              if (endDate.isBefore(startDate)) {
                endDate = startDate.add(const Duration(hours: 1));
                endTime = endDate;
              }

              setDialogState(() {});
            }

            void updateStartTime(DateTime? value) {
              if (value == null) return;
              startTime = value;

              startDate = DateTime(
                startDate.year,
                startDate.month,
                startDate.day,
                value.hour,
                value.minute,
              );

              if (endDate.isBefore(startDate)) {
                endDate = startDate.add(const Duration(hours: 1));
                endTime = endDate;
              }

              setDialogState(() {});
            }

            void updateEndTime(DateTime? value) {
              if (value == null) return;
              endTime = value;

              endDate = DateTime(
                endDate.year,
                endDate.month,
                endDate.day,
                value.hour,
                value.minute,
              );

              if (endDate.isBefore(startDate)) {
                endDate = startDate.add(const Duration(hours: 1));
                endTime = endDate;
              }

              setDialogState(() {});
            }

            return AlertDialog(
              title: const Text("New Event"),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  controller: controller,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      FormField(
                        key: FormKey(#title),
                        label: const Text("Title"),
                        child: TextField(
                          controller: titleController,
                          placeholder: const Text("Add Title"),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Description
                      FormField(
                        key: FormKey(#description),
                        label: const Text("Description"),
                        child: TextArea(
                          controller: descriptionController,
                          expandableHeight: true,
                          initialHeight: 50,
                          placeholder: const Text("Add description..."),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // All Day Toggle
                      Switch(
                        value: allDay,
                        onChanged: (bool value) {
                          allDay = value;
                          setDialogState(() {});
                        },
                        trailing: const Text("All Day"),
                      ),

                      const SizedBox(height: 8),

                      // Start section
                      Text(
                        "Start",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        children: [
                          DatePicker(
                            value: startDate,
                            mode: PromptMode.popover,
                            placeholder: const Text("Start Date"),
                            onChanged: updateStartDate,
                          ),
                          if (!allDay)
                            DatePicker(
                              value: startTime,
                              mode: PromptMode.popover,
                              placeholder: const Text("Start Time"),
                              onChanged: updateStartTime,
                            ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // End section
                      Text(
                        "End",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        children: [
                          DatePicker(
                            value: endDate,
                            mode: PromptMode.popover,
                            placeholder: const Text("End Date"),
                            onChanged: updateEndDate,
                          ),
                          if (!allDay)
                            DatePicker(
                              value: endTime,
                              mode: PromptMode.popover,
                              placeholder: const Text("End Time"),
                              onChanged: updateEndTime,
                            ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Color
                      Select<String>(
                        itemBuilder: (context, item) => Text(item),
                        value: selectedColor,
                        placeholder: const Text("Color"),
                        onChanged: (v) {
                          selectedColor = v;
                          setDialogState(() {});
                        },
                        popup: SelectPopup(
                          items: SelectItemList(
                            children: _colorOptions
                                .map(
                                  (c) => SelectItemButton(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                .toList(),
                          ),
                        ).call,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                OutlineButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                SecondaryButton(
                  onPressed: () {
                    final event = CalendarEvent(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      description: descriptionController.text,
                      startDate: startDate,
                      endDate: endDate,
                      isAllDay: allDay,
                      color: selectedColor ?? 'Blue',
                    );

                    _addEvent(event);

                    setState(() {
                      _allDay = false;
                      _selectedColor = null;
                    });

                    Navigator.of(context).pop();
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Calendar views

  Widget _buildDayView() {
    return _buildWeekDayColumn(_selectedDate);
  }

  List<DateTime> _generateWeekDays(DateTime date) {
    final start = date.subtract(Duration(days: date.weekday % 7));
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  Widget _buildWeekDayColumn(DateTime date) {
    final events =
        _eventsByDate[DateTime(date.year, date.month, date.day)] ?? [];

    final groups = _groupOverlappingEvents(events);

    final positioned = <Widget>[];

    for (var group in groups) {
      final laneMap = _assignEventLanes(group);
      final laneCount = laneMap.values.toSet().length;

      for (var event in group) {
        final lane = laneMap[event.id]!;
        final top = event.startDate.hour * 60 + event.startDate.minute;
        final height = event.endDate.difference(event.startDate).inMinutes;

        final widthFactor = 1 / laneCount;
        final left = lane * widthFactor;

        positioned.add(
          Positioned(
            top: top.toDouble(),
            height: height.toDouble(),
            left: left * MediaQuery.of(context).size.width / 7, // week
            width: (MediaQuery.of(context).size.width / 7) * widthFactor,
            child: _buildWeekEventBox(event),
          ),
        );
      }
    }

    return Stack(
      children: [
        ListView.builder(
          itemCount: 24,
          itemBuilder: (_, hour) => Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).colorScheme.border),
              ),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text("$hour:00", style: const TextStyle(fontSize: 10)),
            ),
          ),
        ),

        // events overlay
        ...events.map((event) {
          final top = event.startDate.hour * 60 + event.startDate.minute;
          final height = event.endDate.difference(event.startDate).inMinutes;

          return Positioned(
            top: top.toDouble(),
            left: 2,
            right: 2,
            height: height.toDouble(),
            child: GestureDetector(
              onTap: () => _showDateEvents(date, [event]),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _getColorFromString(event.color).withValues(alpha: .4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(event.title),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildWeekView() {
    final days = _generateWeekDays(_selectedDate);

    return Column(
      children: [
        Row(
          children: days
              .map(
                (d) =>
                    Expanded(child: Center(child: Text("${d.month}/${d.day}"))),
              )
              .toList(),
        ),
        const Divider(),
        Expanded(
          child: Row(
            children: days.map((d) {
              return Expanded(child: _buildWeekDayColumn(d));
            }).toList(),
          ),
        ),
      ],
    );
  }

  List<DateTime> _generateMonthDays(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);

    final firstWeekday = first.weekday % 7;
    final lastWeekday = last.weekday % 7;

    final start = first.subtract(Duration(days: firstWeekday));
    final end = last.add(Duration(days: 6 - lastWeekday));

    final days = <DateTime>[];

    for (int i = 0; i <= end.difference(start).inDays; i++) {
      days.add(DateTime(start.year, start.month, start.day + i));
    }

    return days;
  }

  Widget _buildEventChip(CalendarEvent event) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getColorFromString(event.color).withValues(alpha: .25),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        event.title,
        style: const TextStyle(fontSize: 11),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  List<List<CalendarEvent>> _groupOverlappingEvents(
    List<CalendarEvent> events,
  ) {
    events.sort((a, b) => a.startDate.compareTo(b.startDate));

    final groups = <List<CalendarEvent>>[];

    for (var event in events) {
      bool placed = false;

      for (var group in groups) {
        final last = group.last;
        // If not overlapping, add to this group
        if (event.startDate.isAfter(last.endDate)) {
          group.add(event);
          placed = true;
          break;
        }
      }

      // No existing group fits → make a new one
      if (!placed) groups.add([event]);
    }

    return groups;
  }

  Map<String, int> _assignEventLanes(List<CalendarEvent> group) {
    final lanes = <int, DateTime>{}; // lane → last event end time
    final eventLane = <String, int>{};

    for (final event in group) {
      bool assigned = false;

      for (int lane = 0; lane < lanes.length; lane++) {
        if (!event.startDate.isBefore(lanes[lane]!)) {
          lanes[lane] = event.endDate;
          eventLane[event.id] = lane;
          assigned = true;
          break;
        }
      }

      if (!assigned) {
        final newLane = lanes.length;
        lanes[newLane] = event.endDate;
        eventLane[event.id] = newLane;
      }
    }

    return eventLane; // event.id → lane index
  }

  Widget _buildWeekEventBox(CalendarEvent event) {
    return GestureDetector(
      onTap: () => _showDateEvents(event.startDate, [event]),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: _getColorFromString(event.color).withValues(alpha: .4),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          event.title,
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
      ),
    );
  }

  TableCell _buildMonthCell(DateTime date) {
    final isOutsideMonth = date.month != _currentMonth.month;
    final events =
        _eventsByDate[DateTime(date.year, date.month, date.day)] ?? [];

    return TableCell(
      child: GestureDetector(
        onTap: () => _showDateEvents(date, events),
        child: Container(
          padding: const EdgeInsets.all(6),
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.border),
            color: isOutsideMonth
                ? Theme.of(context).colorScheme.card
                : Theme.of(context).colorScheme.background,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${date.day}",
                style: TextStyle(color: isOutsideMonth ? Colors.gray : null),
              ),
              ...events.take(3).map((e) => _buildEventChip(e)),
              if (events.length > 3)
                Text(
                  "+${events.length - 3} more",
                  style: const TextStyle(fontSize: 10),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthView() {
    final days = _generateMonthDays(_currentMonth);

    return Table(
      rows: [
        TableRow(
          cells: [
            "Sun",
            "Mon",
            "Tue",
            "Wed",
            "Thu",
            "Fri",
            "Sat",
          ].map((d) => _buildHeaderCell(d)).toList(),
        ),
        ...List.generate(6, (weekIndex) {
          final weekDays = days.skip(weekIndex * 7).take(7).toList();

          return TableRow(
            cells: weekDays.map((day) => _buildMonthCell(day)).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildCalendar() {
    switch (_viewMode) {
      case CalendarViewMode.month:
        return _buildMonthView();
      case CalendarViewMode.week:
        return _buildWeekView();
      case CalendarViewMode.day:
        return _buildDayView();
    }
  }

  // Show events in the calendar, build and delete events
  void _showDateEvents(DateTime date, List<CalendarEvent> events) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Events on ${date.month}/${date.day}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: events.map((e) {
              return Alert(
                title: Text(e.title),
                content: Text(e.description),
                trailing: IconButton.ghost(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteEvent(e);
                    Navigator.pop(context);
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // Widget _buildEventItem(CalendarEvent event) {}

  void _deleteEvent(CalendarEvent event) {
    setState(() {
      _events.removeWhere((e) => e.id == event.id);
      _organizeEventsByDate();
    });
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
                IconButton.outline(
                  onPressed: _navigateToPreviousMonth,
                  density: .iconDense,
                  icon: const Icon(LucideIcons.chevronLeft),
                ),
                Text(
                  "${_getMonthName(_currentMonth.month)} ${_currentMonth.year}",
                ),
                IconButton.outline(
                  onPressed: _navigateToNextMonth,
                  density: .iconDense,
                  icon: const Icon(LucideIcons.chevronRight),
                ),
                const Spacer(),
                OutlineButton(
                  onPressed: _goToToday,
                  child: const Text("Today"),
                ),
                ButtonGroup(
                  children: [
                    SecondaryButton(
                      onPressed: () => _changeView(CalendarViewMode.month),
                      child: const Text("Month"),
                    ),
                    SecondaryButton(
                      onPressed: () => _changeView(CalendarViewMode.week),
                      child: const Text("Week"),
                    ),
                    SecondaryButton(
                      onPressed: () => _changeView(CalendarViewMode.day),
                      child: const Text("Day"),
                    ),
                  ],
                ),
                PrimaryButton(
                  onPressed: _showAddEventDialog,
                  density: .dense,
                  leading: const Icon(LucideIcons.plus),
                  child: const Text("New Event"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Expanded(child: _buildCalendar()),
          ],
        ),
      ),
    );
  }

  TableCell _buildHeaderCell(String text) {
    return TableCell(
      child: Container(
        padding: const .all(8),
        alignment: .center,
        child: Text(text).muted().semiBold(),
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}

enum CalendarViewMode { month, week, day }

class CalendarEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAllDay;
  final String color;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.isAllDay,
    required this.color,
  });

  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isAllDay,
    String? color,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isAllDay: isAllDay ?? this.isAllDay,
      color: color ?? this.color,
    );
  }
}
