import 'package:shadcn_flutter/shadcn_flutter.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  bool value = false;
  DateTime? _value;
  ColorDerivative color = ColorDerivative.fromColor(Colors.blue);

  TableCell buildHeaderCell(String text) {
    return TableCell(
      child: Container(
        padding: const .all(8),
        alignment: .center,
        child: Text(text).muted().semiBold(),
      ),
    );
  }

  TableCell buildCell(String text) {
    return TableCell(
      child: OutlinedContainer(
        padding: const .only(top: 32, bottom: 32),
        borderRadius: .circular(0),
        child: Center(child: Text(text).muted().semiBold()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Flex(
            direction: .horizontal,
            mainAxisAlignment: .spaceBetween,
            children: [
              Wrap(
                spacing: 8,
                crossAxisAlignment: .center,
                children: [
                  IconButton.outline(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.chevronLeft),
                  ),
                  const Text("November 2025"),
                  IconButton.outline(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.chevronRight),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                crossAxisAlignment: .center,
                children: [
                  OutlineButton(onPressed: () {}, child: const Text("Today")),
                  SecondaryButton(onPressed: () {}, child: const Text("Month")),
                  GhostButton(onPressed: () {}, child: const Text("Week")),
                  GhostButton(onPressed: () {}, child: const Text("Day")),
                  SecondaryButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final FormController controller = FormController();
                          return AlertDialog(
                            title: const Text("New Event"),
                            content: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: Form(
                                controller: controller,
                                child: Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    FormField(
                                      key: FormKey(#title),
                                      label: const Text("Title"),
                                      child: TextField(
                                        placeholder: const Text("Add Title"),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    FormField(
                                      key: FormKey(#description),
                                      label: const Text("Description"),
                                      child: TextArea(
                                        expandableHeight: true,
                                        initialHeight: 50,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Switch(
                                      value: value,
                                      onChanged: (bool value) {
                                        setState(() {
                                          this.value = value;
                                        });
                                      },
                                      trailing: const Text("All Day"),
                                    ),
                                    const SizedBox(height: 8),
                                    Flex(
                                      direction: .horizontal,
                                      spacing: 8,
                                      children: [
                                        DatePicker(
                                          value: _value,
                                          mode: PromptMode.popover,
                                          placeholder: const Text("Start Date"),
                                          stateBuilder: (date) {
                                            if (date.isAfter(DateTime.now())) {
                                              return DateState.disabled;
                                            }
                                            return DateState.enabled;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _value = value;
                                            });
                                          },
                                        ),
                                        DatePicker(
                                          value: _value,
                                          mode: PromptMode.popover,
                                          placeholder: const Text("Start Time"),
                                          stateBuilder: (date) {
                                            if (date.isAfter(DateTime.now())) {
                                              return DateState.disabled;
                                            }
                                            return DateState.enabled;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _value = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Flex(
                                      direction: .horizontal,
                                      spacing: 8,
                                      children: [
                                        DatePicker(
                                          value: _value,
                                          mode: PromptMode.popover,
                                          placeholder: const Text("End Date"),
                                          stateBuilder: (date) {
                                            if (date.isAfter(DateTime.now())) {
                                              return DateState.disabled;
                                            }
                                            return DateState.enabled;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _value = value;
                                            });
                                          },
                                        ),
                                        DatePicker(
                                          value: _value,
                                          mode: PromptMode.popover,
                                          placeholder: const Text("End Time"),
                                          stateBuilder: (date) {
                                            if (date.isAfter(DateTime.now())) {
                                              return DateState.disabled;
                                            }
                                            return DateState.enabled;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _value = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ColorInput(
                                      value: color,
                                      promptMode: PromptMode.dialog,
                                      dialogTitle: const Text("Select Color"),
                                      onChanged: (value) {
                                        setState(() {
                                          color = value;
                                        });
                                      },
                                      showLabel: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              OutlineButton(
                                onPressed: () {
                                  Navigator.of(context).pop(controller.values);
                                },
                                child: const Text("Cancel"),
                              ),
                              SecondaryButton(
                                onPressed: () {
                                  Navigator.of(context).pop(controller.values);
                                },
                                child: const Text("Save"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    density: ButtonDensity.icon,
                    leading: const Icon(LucideIcons.plus),
                    child: const Text("New Event"),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Table(
            rows: [
              TableHeader(
                cells: [
                  buildHeaderCell("Sun"),
                  buildHeaderCell("Mon"),
                  buildHeaderCell("Tue"),
                  buildHeaderCell("Wed"),
                  buildHeaderCell("Thu"),
                  buildHeaderCell("Fri"),
                  buildHeaderCell("Sat"),
                ],
              ),
              TableRow(
                cells: [
                  buildCell('27'),
                  buildCell('28'),
                  buildCell('29'),
                  buildCell('30'),
                  buildCell('31'),
                  buildCell('1'),
                  buildCell('2'),
                ],
              ),
              TableRow(
                cells: [
                  buildCell('3'),
                  buildCell('4'),
                  buildCell('5'),
                  buildCell('6'),
                  buildCell('7'),
                  buildCell('8'),
                  buildCell('9'),
                ],
              ),
              TableRow(
                cells: [
                  buildCell('10'),
                  buildCell('11'),
                  buildCell('12'),
                  buildCell('13'),
                  buildCell('14'),
                  buildCell('15'),
                  buildCell('16'),
                ],
              ),
              TableRow(
                cells: [
                  buildCell('17'),
                  buildCell('18'),
                  buildCell('19'),
                  buildCell('20'),
                  buildCell('21'),
                  buildCell('22'),
                  buildCell('23'),
                ],
              ),
              TableRow(
                cells: [
                  buildCell('24'),
                  buildCell('25'),
                  buildCell('26'),
                  buildCell('27'),
                  buildCell('28'),
                  buildCell('29'),
                  buildCell('30'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
