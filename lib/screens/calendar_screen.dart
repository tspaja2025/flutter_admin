import 'package:shadcn_flutter/shadcn_flutter.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  bool value = false;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
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
                IconButton.outline(
                  onPressed: () {},
                  density: .iconDense,
                  icon: const Icon(LucideIcons.chevronLeft),
                ),
                const Text("December 2025"),
                IconButton.outline(
                  onPressed: () {},
                  density: .iconDense,
                  icon: const Icon(LucideIcons.chevronRight),
                ),
                const Spacer(),
                OutlineButton(onPressed: () {}, child: const Text("Today")),
                ButtonGroup(
                  children: [
                    PrimaryButton(onPressed: () {}, child: const Text("Month")),
                    SecondaryButton(
                      onPressed: () {},
                      child: const Text("Week"),
                    ),
                    SecondaryButton(onPressed: () {}, child: const Text("Day")),
                  ],
                ),
                PrimaryButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("New Event"),
                          content: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                FormField(
                                  key: FormKey(#title),
                                  label: const Text("Title"),
                                  child: TextField(
                                    placeholder: const Text("Add title"),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                FormField(
                                  key: FormKey(#description),
                                  label: const Text("Description"),
                                  child: TextField(
                                    placeholder: const Text("Add description"),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Switch(
                                  value: value,
                                  onChanged: (value) {
                                    setState(() {
                                      this.value = value;
                                    });
                                  },
                                  trailing: const Text("All day"),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FormField(
                                        key: FormKey(#startDate),
                                        label: const Text("Start Date"),
                                        child: DatePicker(
                                          value: _startDate,
                                          mode: PromptMode.popover,
                                          stateBuilder: (date) {
                                            if (date.isAfter(DateTime.now())) {
                                              return DateState.disabled;
                                            }
                                            return DateState.enabled;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _startDate = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: FormField(
                                        key: FormKey(#startTime),
                                        label: const Text("Start Time"),
                                        child: TimePicker(
                                          value: _startTime,
                                          mode: PromptMode.popover,
                                          onChanged: (value) {
                                            setState(() {
                                              _startTime =
                                                  value ?? TimeOfDay.now();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FormField(
                                        key: FormKey(#endDate),
                                        label: const Text("End Date"),
                                        child: DatePicker(
                                          value: _endDate,
                                          mode: PromptMode.popover,
                                          stateBuilder: (date) {
                                            if (date.isAfter(DateTime.now())) {
                                              return DateState.disabled;
                                            }
                                            return DateState.enabled;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _endDate = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: FormField(
                                        key: FormKey(#endTime),
                                        label: const Text("End Time"),
                                        child: TimePicker(
                                          value: _endTime,
                                          mode: PromptMode.popover,
                                          onChanged: (value) {
                                            setState(() {
                                              _endTime =
                                                  value ?? TimeOfDay.now();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                FormField(
                                  key: FormKey(#endTime),
                                  label: const Text("Color"),
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
                                    placeholder: const Text("Select A Color"),
                                    popup: SelectPopup(
                                      items: SelectItemList(
                                        children: [
                                          SelectItemButton(
                                            value: "Blue",
                                            child: Row(
                                              spacing: 8,
                                              children: [
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius: .circular(50),
                                                  ),
                                                ),
                                                const Text("Blue"),
                                              ],
                                            ),
                                          ),
                                          SelectItemButton(
                                            value: "Green",
                                            child: Row(
                                              spacing: 8,
                                              children: [
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: .circular(50),
                                                  ),
                                                ),
                                                const Text("Green"),
                                              ],
                                            ),
                                          ),
                                          SelectItemButton(
                                            value: "Red",
                                            child: Row(
                                              spacing: 8,
                                              children: [
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius: .circular(50),
                                                  ),
                                                ),
                                                const Text("Red"),
                                              ],
                                            ),
                                          ),
                                          SelectItemButton(
                                            value: "Yellow",
                                            child: Row(
                                              spacing: 8,
                                              children: [
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    color: Colors.yellow,
                                                    borderRadius: .circular(50),
                                                  ),
                                                ),
                                                const Text("Yellow"),
                                              ],
                                            ),
                                          ),
                                          SelectItemButton(
                                            value: "Purple",
                                            child: Row(
                                              spacing: 8,
                                              children: [
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    color: Colors.purple,
                                                    borderRadius: .circular(50),
                                                  ),
                                                ),
                                                const Text("Purple"),
                                              ],
                                            ),
                                          ),
                                          SelectItemButton(
                                            value: "Orange",
                                            child: Row(
                                              spacing: 8,
                                              children: [
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange,
                                                    borderRadius: .circular(50),
                                                  ),
                                                ),
                                                const Text("Orange"),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ).call,
                                  ),
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
                                Navigator.of(context).pop();
                              },
                              child: const Text("Save"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  density: .dense,
                  leading: const Icon(LucideIcons.plus),
                  child: const Text("New Event"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Table(
              rows: [
                // Header row
                TableRow(
                  cells: [
                    _buildHeaderCell("Sun"),
                    _buildHeaderCell("Mon"),
                    _buildHeaderCell("Tue"),
                    _buildHeaderCell("Wed"),
                    _buildHeaderCell("Thu"),
                    _buildHeaderCell("Fri"),
                    _buildHeaderCell("Sat"),
                  ],
                ),
                // Body
                TableRow(
                  cells: [
                    _buildCell("31", true),
                    _buildCell("1"),
                    _buildCell("2"),
                    _buildCell("3"),
                    _buildCell("4"),
                    _buildCell("5"),
                    _buildCell("6"),
                  ],
                ),
                TableRow(
                  cells: [
                    _buildCell("7"),
                    _buildCell("8"),
                    _buildCell("9"),
                    _buildCell("10"),
                    _buildCell("11"),
                    _buildCell("12"),
                    _buildCell("13"),
                  ],
                ),
                TableRow(
                  cells: [
                    _buildCell("14"),
                    _buildCell("15"),
                    _buildCell("16"),
                    _buildCell("17"),
                    _buildCell("18"),
                    _buildCell("19"),
                    _buildCell("20"),
                  ],
                ),
                TableRow(
                  cells: [
                    _buildCell("21"),
                    _buildCell("22"),
                    _buildCell("23"),
                    _buildCell("24"),
                    _buildCell("25"),
                    _buildCell("26"),
                    _buildCell("27"),
                  ],
                ),
                TableRow(
                  cells: [
                    _buildCell("28"),
                    _buildCell("29"),
                    _buildCell("30"),
                    _buildCell("31"),
                    _buildCell("1", true),
                    _buildCell("2", true),
                    _buildCell("3", true),
                  ],
                ),
              ],
            ),
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

  TableCell _buildCell(String text, [isPreviousOrNext = false]) {
    return TableCell(
      rowHover: false,
      child: Container(
        padding: const .all(8),
        height: 96,
        decoration: BoxDecoration(
          color: isPreviousOrNext
              ? Theme.of(context).colorScheme.card
              : Theme.of(context).colorScheme.background,
          border: Border.all(color: Theme.of(context).colorScheme.border),
        ),
        alignment: .topLeft,
        child: Chip(child: isPreviousOrNext ? Text(text).muted() : Text(text)),
      ),
    );
  }
}

// Old to be removed
// import 'package:shadcn_flutter/shadcn_flutter.dart';

// enum CalendarViewMode { month, week, day }

// class CalendarEvent {
//   final String id;
//   final String title;
//   final String description;
//   final DateTime startDate;
//   final DateTime endDate;
//   final bool isAllDay;
//   final String color;

//   CalendarEvent({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.startDate,
//     required this.endDate,
//     required this.isAllDay,
//     required this.color,
//   });

//   CalendarEvent copyWith({
//     String? id,
//     String? title,
//     String? description,
//     DateTime? startDate,
//     DateTime? endDate,
//     bool? isAllDay,
//     String? color,
//   }) {
//     return CalendarEvent(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       startDate: startDate ?? this.startDate,
//       endDate: endDate ?? this.endDate,
//       isAllDay: isAllDay ?? this.isAllDay,
//       color: color ?? this.color,
//     );
//   }
// }

// class CalendarScreen extends StatefulWidget {
//   const CalendarScreen({super.key});

//   @override
//   State<CalendarScreen> createState() => CalendarScreenState();
// }

// class CalendarScreenState extends State<CalendarScreen> {
//   bool _allDay = false;
//   DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
//   DateTime? _selectedStartTime;
//   DateTime? _selectedEndTime;
//   String? _selectedColor;
//   CalendarViewMode _viewMode = CalendarViewMode.month;
//   DateTime _selectedDate = DateTime.now();

//   final List<CalendarEvent> _events = [];
//   final Map<DateTime, List<CalendarEvent>> _eventsByDate = {};

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Flex(
//             direction: Axis.horizontal,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Wrap(
//                 spacing: 8,
//                 crossAxisAlignment: WrapCrossAlignment.center,
//                 children: [
//                   IconButton.outline(
//                     onPressed: _navigateToPreviousMonth,
//                     icon: const Icon(LucideIcons.chevronLeft),
//                   ),
//                   Text(
//                     "${_getMonthName(_currentMonth.month)} ${_currentMonth.year}",
//                   ).semiBold(),
//                   IconButton.outline(
//                     onPressed: _navigateToNextMonth,
//                     icon: const Icon(LucideIcons.chevronRight),
//                   ),
//                 ],
//               ),
//               Wrap(
//                 spacing: 8,
//                 crossAxisAlignment: WrapCrossAlignment.center,
//                 children: [
//                   OutlineButton(
//                     onPressed: _goToToday,
//                     child: const Text("Today"),
//                   ),
//                   ButtonGroup(
//                     children: [
//                       SecondaryButton(
//                         onPressed: () => _changeView(CalendarViewMode.month),
//                         leading: Icon(LucideIcons.calendar),
//                         child: Text('Month'),
//                       ),
//                       SecondaryButton(
//                         onPressed: () => _changeView(CalendarViewMode.week),
//                         leading: Icon(LucideIcons.calendarRange),
//                         child: Text('Week'),
//                       ),
//                       SecondaryButton(
//                         onPressed: () => _changeView(CalendarViewMode.day),
//                         leading: Icon(LucideIcons.calendarDays),
//                         child: Text('Day'),
//                       ),
//                     ],
//                   ),
//                   SecondaryButton(
//                     onPressed: _showAddEventDialog,
//                     density: ButtonDensity.icon,
//                     leading: const Icon(LucideIcons.plus),
//                     child: const Text("New Event"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Expanded(child: _buildCurrentView()),
//         ],
//       ),
//     );
//   }

//   void _changeView(CalendarViewMode mode) {
//     setState(() {
//       _viewMode = mode;
//     });
//   }

//   Widget _buildCurrentView() {
//     switch (_viewMode) {
//       case CalendarViewMode.month:
//         return _buildMonthView();
//       case CalendarViewMode.week:
//         return _buildWeekView();
//       case CalendarViewMode.day:
//         return _buildDayView();
//     }
//   }

//   Widget _buildMonthView() {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final width = constraints.maxWidth / 7;

//         return Table(
//           columnWidths: {for (int i = 0; i < 7; i++) i: FixedTableSize(width)},
//           rows: _buildCalendarRows(),
//         );
//       },
//     );
//   }

//   Widget _buildWeekView() {
//     final weekDays = _getWeekDays(_selectedDate);

//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton.outline(
//               icon: const Icon(LucideIcons.chevronLeft),
//               onPressed: () {
//                 setState(() {
//                   _selectedDate = _selectedDate.subtract(
//                     const Duration(days: 7),
//                   );
//                 });
//               },
//             ),
//             Text("Week of ${_formatDate(weekDays.first)}").semiBold(),
//             IconButton.outline(
//               icon: const Icon(LucideIcons.chevronRight),
//               onPressed: () {
//                 setState(() {
//                   _selectedDate = _selectedDate.add(const Duration(days: 7));
//                 });
//               },
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),

//         Expanded(
//           child: ListView(
//             children: weekDays.map((day) {
//               final dayKey = DateTime(day.year, day.month, day.day);
//               final events = _eventsByDate[dayKey] ?? [];

//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "${_getWeekdayName(day.weekday)}, ${_formatDate(day)}",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     if (events.isEmpty) const Text("No events").muted(),
//                     ...events.map(_buildEventItem),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDayView() {
//     final key = DateTime(
//       _selectedDate.year,
//       _selectedDate.month,
//       _selectedDate.day,
//     );

//     final events = _eventsByDate[key] ?? [];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton.outline(
//               icon: const Icon(LucideIcons.chevronLeft),
//               onPressed: () {
//                 setState(() {
//                   _selectedDate = _selectedDate.subtract(
//                     const Duration(days: 1),
//                   );
//                 });
//               },
//             ),
//             Text(
//               "${_getWeekdayName(_selectedDate.weekday)}, ${_formatDate(_selectedDate)}",
//             ).semiBold(),
//             IconButton.outline(
//               icon: const Icon(LucideIcons.chevronRight),
//               onPressed: () {
//                 setState(() {
//                   _selectedDate = _selectedDate.add(const Duration(days: 1));
//                 });
//               },
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),

//         Expanded(
//           child: events.isEmpty
//               ? Center(child: Text("No events today").muted())
//               : ListView(children: events.map(_buildEventItem).toList()),
//         ),
//       ],
//     );
//   }

//   List<DateTime> _getWeekDays(DateTime date) {
//     // Convert Monday=1,...Sunday=7 into Sunday=0
//     int weekday = date.weekday % 7;
//     DateTime sunday = date.subtract(Duration(days: weekday));

//     return List.generate(7, (i) => sunday.add(Duration(days: i)));
//   }

//   String _getWeekdayName(int weekday) {
//     switch (weekday) {
//       case 1:
//         return "Monday";
//       case 2:
//         return "Tuesday";
//       case 3:
//         return "Wednesday";
//       case 4:
//         return "Thursday";
//       case 5:
//         return "Friday";
//       case 6:
//         return "Saturday";
//       case 7:
//         return "Sunday";
//       default:
//         return "";
//     }
//   }

//   // Color options for events
//   final List<String> _colorOptions = [
//     'Blue',
//     'Green',
//     'Red',
//     'Yellow',
//     'Purple',
//     'Orange',
//   ];

//   Color _getColorFromString(String colorName) {
//     switch (colorName) {
//       case 'Blue':
//         return Colors.blue;
//       case 'Green':
//         return Colors.green;
//       case 'Red':
//         return Colors.red;
//       case 'Yellow':
//         return Colors.yellow;
//       case 'Purple':
//         return Colors.purple;
//       case 'Orange':
//         return Colors.orange;
//       default:
//         return Colors.blue;
//     }
//   }

//   void _navigateToPreviousMonth() {
//     setState(() {
//       _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
//     });
//   }

//   void _navigateToNextMonth() {
//     setState(() {
//       _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
//     });
//   }

//   void _goToToday() {
//     setState(() {
//       _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
//     });
//   }

//   void _addEvent(CalendarEvent event) {
//     setState(() {
//       _events.add(event);
//       _organizeEventsByDate();
//     });
//   }

//   void _organizeEventsByDate() {
//     _eventsByDate.clear();
//     for (var event in _events) {
//       final date = DateTime(
//         event.startDate.year,
//         event.startDate.month,
//         event.startDate.day,
//       );
//       if (!_eventsByDate.containsKey(date)) {
//         _eventsByDate[date] = [];
//       }
//       _eventsByDate[date]!.add(event);
//     }
//   }

//   List<DateTime> _getDaysInMonth(DateTime month) {
//     final firstDayOfMonth = DateTime(month.year, month.month, 1);
//     final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

//     // Flutter: Monday = 1, Sunday = 7
//     int firstWeekday = firstDayOfMonth.weekday % 7; // Sunday becomes 0
//     int lastWeekday = lastDayOfMonth.weekday % 7; // Sunday becomes 0

//     // Start on the previous Sunday
//     final startDate = firstDayOfMonth.subtract(Duration(days: firstWeekday));

//     // End on the following Saturday
//     final endDate = lastDayOfMonth.add(Duration(days: 6 - lastWeekday));

//     // Now generate exactly 42 days (6 weeks)
//     final days = <DateTime>[];
//     var current = startDate;

//     while (days.length < 42) {
//       days.add(current);
//       current = current.add(const Duration(days: 1));
//     }

//     return days;
//   }

//   List<TableRow> _buildCalendarRows() {
//     final daysInMonth = _getDaysInMonth(_currentMonth);
//     final rows = <TableRow>[];

//     // Header row
//     rows.add(
//       TableHeader(
//         cells: [
//           'Sun',
//           'Mon',
//           'Tue',
//           'Wed',
//           'Thu',
//           'Fri',
//           'Sat',
//         ].map((day) => _buildHeaderCell(day)).toList(),
//       ),
//     );

//     // Calendar rows (6 weeks to cover all possibilities)
//     for (int week = 0; week < 6; week++) {
//       final weekDays = daysInMonth.sublist(week * 7, (week + 1) * 7);
//       final cells = weekDays.map((day) => _buildDateCell(day)).toList();
//       rows.add(TableRow(cells: cells));
//     }

//     return rows;
//   }

//   TableCell _buildHeaderCell(String text) {
//     return TableCell(
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         alignment: Alignment.center,
//         child: Text(text).muted().semiBold(),
//       ),
//     );
//   }

//   TableCell _buildDateCell(DateTime date) {
//     final isCurrentMonth = date.month == _currentMonth.month;
//     final isToday = _isToday(date);
//     final hasEvents = _eventsByDate.containsKey(
//       DateTime(date.year, date.month, date.day),
//     );
//     final dayEvents =
//         _eventsByDate[DateTime(date.year, date.month, date.day)] ?? [];

//     return TableCell(
//       child: GestureDetector(
//         onTap: () => _showDateEvents(date, dayEvents),
//         child: OutlinedContainer(
//           padding: const EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 4),
//           borderRadius: BorderRadius.circular(4),
//           backgroundColor: isToday ? Colors.blue.withOpacity(0.1) : null,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 date.day.toString(),
//                 style: TextStyle(
//                   color: isCurrentMonth
//                       ? Theme.of(context).colorScheme.foreground
//                       : Theme.of(context).colorScheme.mutedForeground,
//                   fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
//                 ),
//               ),
//               if (hasEvents) ...[
//                 const SizedBox(height: 4),
//                 ...dayEvents
//                     .take(2)
//                     .map(
//                       (event) => Container(
//                         margin: const EdgeInsets.only(bottom: 2),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 4,
//                           vertical: 2,
//                         ),
//                         decoration: BoxDecoration(
//                           color: _getColorFromString(
//                             event.color,
//                           ).withValues(alpha: 0.2),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           event.title,
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: Theme.of(context).colorScheme.foreground,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ),
//                 if (dayEvents.length > 2) ...[
//                   const SizedBox(height: 2),
//                   Text(
//                     '+${dayEvents.length - 2} more',
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Theme.of(context).colorScheme.mutedForeground,
//                     ),
//                   ),
//                 ],
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   bool _isToday(DateTime date) {
//     final now = DateTime.now();
//     return date.year == now.year &&
//         date.month == now.month &&
//         date.day == now.day;
//   }

//   void _showDateEvents(DateTime date, List<CalendarEvent> events) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Events for ${_formatDate(date)}'),
//         content: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 400),
//           child: events.isEmpty
//               ? const Text('No events for this date.').muted()
//               : Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: events
//                       .map((event) => _buildEventItem(event))
//                       .toList(),
//                 ),
//         ),
//         actions: [
//           OutlineButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("Close"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEventItem(CalendarEvent event) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         children: [
//           Container(
//             width: 4,
//             height: 40,
//             decoration: BoxDecoration(
//               color: _getColorFromString(event.color),
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(event.title).semiBold(),
//                 const SizedBox(height: 2),
//                 Text(
//                   _formatEventTime(event),
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.mutedForeground,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton.primary(
//             onPressed: () => _deleteEvent(event),
//             icon: Icon(
//               LucideIcons.trash2,
//               size: 16,
//               color: Theme.of(context).colorScheme.mutedForeground,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _deleteEvent(CalendarEvent event) {
//     setState(() {
//       _events.remove(event);
//       _organizeEventsByDate();
//     });
//     Navigator.of(context).pop(); // Close the events dialog
//   }

//   String _formatDate(DateTime date) {
//     return '${date.month}/${date.day}/${date.year}';
//   }

//   String _formatEventTime(CalendarEvent event) {
//     if (event.isAllDay) {
//       return 'All day';
//     }
//     return '${_formatTime(event.startDate)} - ${_formatTime(event.endDate)}';
//   }

//   String _formatTime(DateTime date) {
//     return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
//   }

//   void _showAddEventDialog() {
//     final FormController controller = FormController();

//     final titleController = TextEditingController();
//     final descriptionController = TextEditingController();

//     DateTime startDate = DateTime.now();
//     DateTime endDate = DateTime.now().add(const Duration(hours: 1));

//     DateTime startTime = startDate;
//     DateTime endTime = endDate;

//     bool allDay = _allDay;
//     String? selectedColor = _selectedColor;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             void updateStartDate(DateTime? value) {
//               if (value == null) return;
//               startDate = DateTime(
//                 value.year,
//                 value.month,
//                 value.day,
//                 startTime.hour,
//                 startTime.minute,
//               );

//               // Auto-fix endDate
//               if (endDate.isBefore(startDate)) {
//                 endDate = startDate.add(const Duration(hours: 1));
//                 endTime = endDate;
//               }

//               setDialogState(() {});
//             }

//             void updateEndDate(DateTime? value) {
//               if (value == null) return;
//               endDate = DateTime(
//                 value.year,
//                 value.month,
//                 value.day,
//                 endTime.hour,
//                 endTime.minute,
//               );

//               if (endDate.isBefore(startDate)) {
//                 endDate = startDate.add(const Duration(hours: 1));
//                 endTime = endDate;
//               }

//               setDialogState(() {});
//             }

//             void updateStartTime(DateTime? value) {
//               if (value == null) return;
//               startTime = value;

//               startDate = DateTime(
//                 startDate.year,
//                 startDate.month,
//                 startDate.day,
//                 value.hour,
//                 value.minute,
//               );

//               if (endDate.isBefore(startDate)) {
//                 endDate = startDate.add(const Duration(hours: 1));
//                 endTime = endDate;
//               }

//               setDialogState(() {});
//             }

//             void updateEndTime(DateTime? value) {
//               if (value == null) return;
//               endTime = value;

//               endDate = DateTime(
//                 endDate.year,
//                 endDate.month,
//                 endDate.day,
//                 value.hour,
//                 value.minute,
//               );

//               if (endDate.isBefore(startDate)) {
//                 endDate = startDate.add(const Duration(hours: 1));
//                 endTime = endDate;
//               }

//               setDialogState(() {});
//             }

//             return AlertDialog(
//               title: const Text("New Event"),
//               content: ConstrainedBox(
//                 constraints: const BoxConstraints(maxWidth: 400),
//                 child: Form(
//                   controller: controller,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Title
//                       FormField(
//                         key: FormKey(#title),
//                         label: const Text("Title"),
//                         child: TextField(
//                           controller: titleController,
//                           placeholder: const Text("Add Title"),
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       // Description
//                       FormField(
//                         key: FormKey(#description),
//                         label: const Text("Description"),
//                         child: TextArea(
//                           controller: descriptionController,
//                           expandableHeight: true,
//                           initialHeight: 50,
//                           placeholder: const Text("Add description..."),
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       // All Day Toggle
//                       Switch(
//                         value: allDay,
//                         onChanged: (bool value) {
//                           allDay = value;
//                           setDialogState(() {});
//                         },
//                         trailing: const Text("All Day"),
//                       ),

//                       const SizedBox(height: 8),

//                       // Start section
//                       Text(
//                         "Start",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 4),
//                       Wrap(
//                         spacing: 8,
//                         children: [
//                           DatePicker(
//                             value: startDate,
//                             mode: PromptMode.popover,
//                             placeholder: const Text("Start Date"),
//                             onChanged: updateStartDate,
//                           ),
//                           if (!allDay)
//                             DatePicker(
//                               value: startTime,
//                               mode: PromptMode.popover,
//                               placeholder: const Text("Start Time"),
//                               onChanged: updateStartTime,
//                             ),
//                         ],
//                       ),

//                       const SizedBox(height: 12),

//                       // End section
//                       Text(
//                         "End",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 4),
//                       Wrap(
//                         spacing: 8,
//                         children: [
//                           DatePicker(
//                             value: endDate,
//                             mode: PromptMode.popover,
//                             placeholder: const Text("End Date"),
//                             onChanged: updateEndDate,
//                           ),
//                           if (!allDay)
//                             DatePicker(
//                               value: endTime,
//                               mode: PromptMode.popover,
//                               placeholder: const Text("End Time"),
//                               onChanged: updateEndTime,
//                             ),
//                         ],
//                       ),

//                       const SizedBox(height: 12),

//                       // Color
//                       Select<String>(
//                         itemBuilder: (context, item) => Text(item),
//                         value: selectedColor,
//                         placeholder: const Text("Color"),
//                         onChanged: (v) {
//                           selectedColor = v;
//                           setDialogState(() {});
//                         },
//                         popup: SelectPopup(
//                           items: SelectItemList(
//                             children: _colorOptions
//                                 .map(
//                                   (c) => SelectItemButton(
//                                     value: c,
//                                     child: Text(c),
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                         ).call,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               actions: [
//                 OutlineButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: const Text("Cancel"),
//                 ),
//                 SecondaryButton(
//                   onPressed: () {
//                     final event = CalendarEvent(
//                       id: DateTime.now().millisecondsSinceEpoch.toString(),
//                       title: titleController.text,
//                       description: descriptionController.text,
//                       startDate: startDate,
//                       endDate: endDate,
//                       isAllDay: allDay,
//                       color: selectedColor ?? 'Blue',
//                     );

//                     _addEvent(event);

//                     setState(() {
//                       _allDay = false;
//                       _selectedColor = null;
//                     });

//                     Navigator.of(context).pop();
//                   },
//                   child: const Text("Save"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   String _getMonthName(int month) {
//     switch (month) {
//       case 1:
//         return 'January';
//       case 2:
//         return 'February';
//       case 3:
//         return 'March';
//       case 4:
//         return 'April';
//       case 5:
//         return 'May';
//       case 6:
//         return 'June';
//       case 7:
//         return 'July';
//       case 8:
//         return 'August';
//       case 9:
//         return 'September';
//       case 10:
//         return 'October';
//       case 11:
//         return 'November';
//       case 12:
//         return 'December';
//       default:
//         return '';
//     }
//   }
// }
