import 'package:shadcn_flutter/shadcn_flutter.dart';

class InvoiceManagerScreen extends StatefulWidget {
  const InvoiceManagerScreen({super.key});

  @override
  State<InvoiceManagerScreen> createState() => InvoiceManagerScreenState();
}

class InvoiceManagerScreenState extends State<InvoiceManagerScreen> {
  String? _selectedValue;
  DateTime? _invoiceDate;
  DateTime? _invoiceDueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .end,
              children: [
                PrimaryButton(
                  onPressed: () {},
                  density: .dense,
                  leading: const Icon(LucideIcons.plus),
                  child: const Text("New Invoice"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Column(
                  children: [
                    Table(
                      rows: [
                        // Header Row
                        TableRow(
                          cells: [
                            _buildHeaderCell("Invoice Number"),
                            _buildHeaderCell("Date"),
                            _buildHeaderCell("Due Date"),
                            _buildHeaderCell("Items"),
                            _buildHeaderCell("Status"),
                            _buildHeaderCell("Amount"),
                            _buildHeaderCell("Actions"),
                          ],
                        ),
                        // Body Rows
                        TableRow(
                          cells: [
                            _buildCell("INV-20250312"),
                            _buildCell("12/03/2025"),
                            _buildCell("31/03/2025"),
                            _buildCell("1"),
                            _buildCell("sent"),
                            _buildCell("\$400.00"),
                            TableCell(
                              child: Container(
                                padding: const .only(left: 8, right: 0),
                                alignment: .centerRight,
                                child: Row(
                                  spacing: 8,
                                  children: [
                                    IconButton.outline(
                                      onPressed: () {},
                                      density: .iconDense,
                                      icon: const Icon(LucideIcons.eye),
                                    ),
                                    IconButton.outline(
                                      onPressed: () {},
                                      density: .iconDense,
                                      icon: const Icon(LucideIcons.pencil),
                                    ),
                                    IconButton.outline(
                                      onPressed: () {},
                                      density: .iconDense,
                                      icon: const Icon(LucideIcons.trash2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    const Text("New Invoice").semiBold().x2Large(),
                    const SizedBox(height: 16),
                    const Text("Invoice Details").semiBold(),
                    const SizedBox(height: 16),
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: FormField(
                            key: FormKey(#invoiceNumber),
                            label: const Text("Invoice Number"),
                            child: TextField(
                              placeholder: const Text("INV-20250312"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: FormField(
                            key: FormKey(#invoiceStatus),
                            label: const Text("Invoice Status"),
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
                              placeholder: const Text("Select A Status"),
                              popup: SelectPopup(
                                items: SelectItemList(
                                  children: [
                                    SelectItemButton(
                                      value: "Draft",
                                      child: const Text("Draft"),
                                    ),
                                    SelectItemButton(
                                      value: "Sent",
                                      child: const Text("Sent"),
                                    ),
                                    SelectItemButton(
                                      value: "Paid",
                                      child: const Text("Paid"),
                                    ),
                                    SelectItemButton(
                                      value: "Overdue",
                                      child: const Text("Overdue"),
                                    ),
                                  ],
                                ),
                              ).call,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: FormField(
                            key: FormKey(#invoiceDate),
                            label: const Text("Invoice Date"),
                            child: DatePicker(
                              value: _invoiceDate,
                              mode: PromptMode.popover,
                              // Disable selecting dates after "today".
                              stateBuilder: (date) {
                                if (date.isAfter(DateTime.now())) {
                                  return DateState.disabled;
                                }
                                return DateState.enabled;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _invoiceDate = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: FormField(
                            key: FormKey(#invoiceDueDate),
                            label: const Text("Invoice Due Date"),
                            child: DatePicker(
                              value: _invoiceDueDate,
                              mode: PromptMode.popover,
                              // Disable selecting dates after "today".
                              stateBuilder: (date) {
                                if (date.isAfter(DateTime.now())) {
                                  return DateState.disabled;
                                }
                                return DateState.enabled;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _invoiceDueDate = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text("Client Information").semiBold(),
                    const SizedBox(height: 16),
                    FormField(
                      key: FormKey(#clientName),
                      label: const Text("Client Name"),
                      child: TextField(),
                    ),
                    const SizedBox(height: 8),
                    FormField(
                      key: FormKey(#clientEmail),
                      label: const Text("Client Email"),
                      child: TextField(),
                    ),
                    const SizedBox(height: 8),
                    FormField(
                      key: FormKey(#clientAddress),
                      label: const Text("Client Address"),
                      child: TextField(),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        const Text("Line Items").semiBold(),
                        PrimaryButton(
                          onPressed: () {},
                          density: .dense,
                          leading: const Icon(LucideIcons.plus),
                          child: const Text("Add item"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: .end,
                      spacing: 8,
                      children: [
                        SizedBox(
                          width: 200,
                          child: FormField(
                            key: FormKey(#description),
                            label: const Text("Description"),
                            child: TextField(
                              placeholder: const Text(
                                "Service or product description",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: FormField(
                            key: FormKey(#qty),
                            label: const Text("QTY"),
                            child: TextField(placeholder: const Text("0")),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: FormField(
                            key: FormKey(#unitPrice),
                            label: const Text("Unit Price"),
                            child: TextField(placeholder: const Text("0")),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: FormField(
                            key: FormKey(#amount),
                            label: const Text("Amount"),
                            child: TextField(placeholder: const Text("\$0.00")),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: FormField(
                            key: FormKey(#taxRate),
                            label: const Text("Tax Rate"),
                            child: TextField(placeholder: const Text("0")),
                          ),
                        ),
                        IconButton.outline(
                          onPressed: () {},
                          density: .icon,
                          icon: const Icon(LucideIcons.trash2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [const Text("Subtotal:"), const Text("\$0.00")],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [const Text("Tax Rate:"), const Text("\$0.00")],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [const Text("Total:"), const Text("\$0.00")],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text("Notes").semiBold(),
                    const SizedBox(height: 16),
                    TextArea(
                      initialValue:
                          "Payment terms, additional information, etc",
                      expandableHeight: true,
                      initialHeight: 100,
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
        padding: const .all(8),
        alignment: alignRight ? .centerRight : null,
        child: Text(text),
      ),
    );
  }
}

// Old to be removed
// import 'package:shadcn_flutter/shadcn_flutter.dart';

// class LineItem {
//   final TextEditingController description = TextEditingController();
//   final TextEditingController quantity = TextEditingController(text: '1');
//   final TextEditingController unitPrice = TextEditingController(text: '0.00');
//   final TextEditingController amount = TextEditingController(text: '0.00');

//   void dispose() {
//     description.dispose();
//     quantity.dispose();
//     unitPrice.dispose();
//     amount.dispose();
//   }
// }

// class InvoiceScreen extends StatefulWidget {
//   const InvoiceScreen({super.key});

//   @override
//   State<InvoiceScreen> createState() => _InvoiceScreenState();
// }

// class _InvoiceScreenState extends State<InvoiceScreen> {
//   // --- State ---
//   bool hasInvoices = false;
//   bool creating = false;

//   String? status;
//   DateTime? invoiceDate;
//   DateTime? dueDate;

//   // Form controllers
//   final TextEditingController invoiceNumberCtrl = TextEditingController();
//   final TextEditingController clientNameCtrl = TextEditingController();
//   final TextEditingController clientEmailCtrl = TextEditingController();
//   final TextEditingController clientAddressCtrl = TextEditingController();
//   final TextEditingController taxRateCtrl = TextEditingController(text: '0');
//   final TextEditingController notesCtrl = TextEditingController();

//   List<LineItem> items = [LineItem()];

//   // Layout constants
//   static const double _cardPadding = 16.0;
//   static const double _sectionSpacing = 16.0;
//   static const double _fieldSpacing = 16.0;

//   @override
//   void dispose() {
//     invoiceNumberCtrl.dispose();
//     clientNameCtrl.dispose();
//     clientEmailCtrl.dispose();
//     clientAddressCtrl.dispose();
//     taxRateCtrl.dispose();
//     notesCtrl.dispose();
//     for (final i in items) {
//       i.dispose();
//     }
//     super.dispose();
//   }

//   // --- Helpers ---
//   Widget _sectionHeader(String title, {String? subtitle}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title).semiBold().large(),
//         if (subtitle != null) ...[
//           const SizedBox(height: 6),
//           Text(subtitle).muted().small(),
//         ],
//         const SizedBox(height: 12),
//       ],
//     );
//   }

//   Widget _field({required Widget child}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: _fieldSpacing),
//       child: child,
//     );
//   }

//   double _parseCurrency(String s) {
//     try {
//       return double.parse(s.replaceAll(',', ''));
//     } catch (_) {
//       return 0.0;
//     }
//   }

//   double get subtotal {
//     double sum = 0.0;
//     for (final it in items) {
//       final q = _parseCurrency(it.quantity.text);
//       final p = _parseCurrency(it.unitPrice.text);
//       final amt = q * p;
//       sum += amt;
//       // keep amount controller in sync (safe because readOnly)
//       it.amount.text = amt.toStringAsFixed(2);
//     }
//     return sum;
//   }

//   double get taxRate {
//     return _parseCurrency(taxRateCtrl.text) / 100.0;
//   }

//   double get taxAmount => subtotal * taxRate;

//   double get total => subtotal + taxAmount;

//   // --- Actions ---
//   void _addItem() {
//     setState(() {
//       items.add(LineItem());
//     });
//   }

//   void _removeItem(int index) {
//     setState(() {
//       items[index].dispose();
//       items.removeAt(index);
//     });
//   }

//   void _saveAsDraft() {
//     // placeholder: implement persistence
//     setState(() => creating = false);
//   }

//   void _saveAndSend() {
//     // placeholder: implement validation + send
//     setState(() => creating = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final isWide = constraints.maxWidth > 900;
//           final formColumnWidth = isWide
//               ? (constraints.maxWidth - 48) * 0.6
//               : constraints.maxWidth;
//           final sideColumnWidth = isWide
//               ? (constraints.maxWidth - 48) * 0.4
//               : constraints.maxWidth;

//           return SingleChildScrollView(
//             child: creating
//                 ? _buildCreateForm(isWide, formColumnWidth, sideColumnWidth)
//                 : _buildListView(),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildListView() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SecondaryButton(
//           onPressed: () => setState(() => creating = true),
//           density: ButtonDensity.icon,
//           leading: const Icon(LucideIcons.plus),
//           child: const Text('Create New Invoice'),
//         ),
//         const SizedBox(height: _sectionSpacing),
//         Card(
//           child: Padding(
//             padding: const EdgeInsets.all(_cardPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _sectionHeader(
//                   'Invoice Manager',
//                   subtitle: 'Create and manage your invoices.',
//                 ),
//                 if (!hasInvoices)
//                   Center(
//                     child: Container(
//                       padding: const EdgeInsets.all(24),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.gray.shade200),
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             LucideIcons.fileText,
//                             size: 48,
//                             color: Colors.gray.shade400,
//                           ),
//                           const SizedBox(height: 12),
//                           const Text('No invoices yet').semiBold().medium(),
//                           const SizedBox(height: 8),
//                           const Text(
//                             'Get started by creating your first invoice.',
//                             textAlign: TextAlign.center,
//                           ).muted(),
//                           const SizedBox(height: 16),
//                           PrimaryButton(
//                             onPressed: () => setState(() => creating = true),
//                             child: const Text('Create First Invoice'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCreateForm(bool isWide, double formWidth, double sideWidth) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Action row
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SecondaryButton(
//               onPressed: () => setState(() => creating = false),
//               density: ButtonDensity.icon,
//               leading: const Icon(LucideIcons.chevronLeft, size: 16),
//               child: const Text('Back'),
//             ),
//             Row(
//               children: [
//                 SecondaryButton(
//                   onPressed: _saveAsDraft,
//                   child: const Text('Save Draft'),
//                 ),
//                 const SizedBox(width: 8),
//                 PrimaryButton(
//                   onPressed: _saveAndSend,
//                   leading: const Icon(LucideIcons.save, size: 16),
//                   child: const Text('Save & Send'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: _sectionSpacing),

//         // Main content: left form and right summary (on wide screens)
//         isWide
//             ? Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(width: formWidth, child: _buildLeftColumn()),
//                   const SizedBox(width: 24),
//                   SizedBox(width: sideWidth, child: _buildRightColumn()),
//                 ],
//               )
//             : Column(
//                 children: [
//                   _buildLeftColumn(),
//                   const SizedBox(height: 16),
//                   _buildRightColumn(),
//                 ],
//               ),
//       ],
//     );
//   }

//   Widget _buildLeftColumn() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Card(
//           child: Padding(
//             padding: const EdgeInsets.all(_cardPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _sectionHeader('Invoice Details'),
//                 Wrap(
//                   spacing: 16,
//                   runSpacing: 12,
//                   children: [
//                     SizedBox(
//                       width: 300,
//                       child: FormField(
//                         key: FormKey(#invoiceNumber),
//                         label: const Text('Invoice Number').muted().small(),
//                         child: TextField(
//                           controller: invoiceNumberCtrl,
//                           placeholder: const Text('INV-20251201'),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 220,
//                       child: FormField(
//                         key: FormKey(#status),
//                         label: const Text('Status').muted().small(),
//                         child: Select<String>(
//                           itemBuilder: (context, item) => Text(item),
//                           value: status,
//                           placeholder: const Text('Select status'),
//                           popupConstraints: const BoxConstraints(
//                             maxHeight: 260,
//                             maxWidth: 220,
//                           ),
//                           onChanged: (v) => setState(() => status = v),
//                           popup: const SelectPopup(
//                             items: SelectItemList(
//                               children: [
//                                 SelectItemButton(
//                                   value: 'Draft',
//                                   child: Text('Draft'),
//                                 ),
//                                 SelectItemButton(
//                                   value: 'Sent',
//                                   child: Text('Sent'),
//                                 ),
//                                 SelectItemButton(
//                                   value: 'Paid',
//                                   child: Text('Paid'),
//                                 ),
//                                 SelectItemButton(
//                                   value: 'Overdue',
//                                   child: Text('Overdue'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 220,
//                       child: FormField(
//                         key: FormKey(#invoiceDate),
//                         label: const Text('Invoice Date').muted().small(),
//                         child: DatePicker(
//                           value: invoiceDate,
//                           mode: PromptMode.popover,
//                           placeholder: const Text('Select date'),
//                           stateBuilder: (d) => d.isAfter(DateTime.now())
//                               ? DateState.disabled
//                               : DateState.enabled,
//                           onChanged: (v) => setState(() => invoiceDate = v),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 220,
//                       child: FormField(
//                         key: FormKey(#dueDate),
//                         label: const Text('Due Date').muted().small(),
//                         child: DatePicker(
//                           value: dueDate,
//                           mode: PromptMode.popover,
//                           placeholder: const Text('Select due date'),
//                           stateBuilder: (d) => DateState.enabled,
//                           onChanged: (v) => setState(() => dueDate = v),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: _sectionSpacing),

//         Card(
//           child: Padding(
//             padding: const EdgeInsets.all(_cardPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _sectionHeader('Client Information'),
//                 Wrap(
//                   spacing: 16,
//                   runSpacing: 12,
//                   children: [
//                     SizedBox(
//                       width: 340,
//                       child: FormField(
//                         key: FormKey(#clientName),
//                         label: const Text('Client Name').muted().small(),
//                         child: TextField(
//                           controller: clientNameCtrl,
//                           placeholder: const Text('Client or company'),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 340,
//                       child: FormField(
//                         key: FormKey(#clientEmail),
//                         label: const Text('Client Email').muted().small(),
//                         child: TextField(
//                           controller: clientEmailCtrl,
//                           placeholder: const Text('email@example.com'),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 700,
//                       child: FormField(
//                         key: FormKey(#clientAddress),
//                         label: const Text('Client Address').muted().small(),
//                         child: TextField(
//                           controller: clientAddressCtrl,
//                           placeholder: const Text('Street, City, ZIP'),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),

//         const SizedBox(height: _sectionSpacing),

//         // Line items card
//         Card(
//           child: Padding(
//             padding: const EdgeInsets.all(_cardPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _sectionHeader('Line Items'),
//                     OutlineButton(
//                       onPressed: _addItem,
//                       leading: const Icon(LucideIcons.plus, size: 16),
//                       child: const Text('Add Item'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),

//                 // Header row
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 8,
//                     horizontal: 4,
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(flex: 4, child: Text('Description').muted()),
//                       SizedBox(width: 12),
//                       SizedBox(width: 80, child: Text('Qty').muted()),
//                       SizedBox(width: 12),
//                       SizedBox(width: 120, child: Text('Unit Price').muted()),
//                       SizedBox(width: 12),
//                       SizedBox(width: 120, child: Text('Amount').muted()),
//                       SizedBox(width: 12),
//                       SizedBox(width: 40),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 ...items.asMap().entries.map((e) {
//                   final idx = e.key;
//                   final it = e.value;
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           flex: 4,
//                           child: TextField(
//                             controller: it.description,
//                             placeholder: const Text('Item description'),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         SizedBox(
//                           width: 80,
//                           child: TextField(
//                             controller: it.quantity,
//                             placeholder: const Text('1'),
//                             keyboardType: TextInputType.number,
//                             onChanged: (_) => setState(() {}),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         SizedBox(
//                           width: 120,
//                           child: TextField(
//                             controller: it.unitPrice,
//                             placeholder: const Text('0.00'),
//                             keyboardType: TextInputType.numberWithOptions(
//                               decimal: true,
//                             ),
//                             onChanged: (_) => setState(() {}),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         SizedBox(
//                           width: 120,
//                           child: TextField(
//                             controller: it.amount,
//                             readOnly: true,
//                             placeholder: const Text('0.00'),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         SizedBox(
//                           width: 40,
//                           child: IconButton.ghost(
//                             onPressed: () => _removeItem(idx),
//                             icon: const Icon(LucideIcons.trash, size: 16),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }),

//                 const SizedBox(height: 12),
//                 const Divider(),
//                 const SizedBox(height: 12),

//                 // Totals and tax
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     SizedBox(
//                       width: 320,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text('Subtotal:').muted(),
//                               Text(
//                                 '\$${subtotal.toStringAsFixed(2)}',
//                               ).semiBold(),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: const Text('Tax rate (%)').muted(),
//                               ),
//                               const SizedBox(width: 12),
//                               SizedBox(
//                                 width: 80,
//                                 child: TextField(
//                                   controller: taxRateCtrl,
//                                   placeholder: const Text('0'),
//                                   keyboardType: TextInputType.number,
//                                   onChanged: (_) => setState(() {}),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text('Tax:').muted(),
//                               Text(
//                                 '\$${taxAmount.toStringAsFixed(2)}',
//                               ).semiBold(),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text('Total:').large().semiBold(),
//                               Text(
//                                 '\$${total.toStringAsFixed(2)}',
//                               ).large().semiBold(),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),

//         const SizedBox(height: _sectionSpacing),

//         Card(
//           child: Padding(
//             padding: const EdgeInsets.all(_cardPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _sectionHeader('Notes'),
//                 FormField(
//                   key: FormKey(#notes),
//                   label: const Text('Additional notes').muted().small(),
//                   child: TextField(
//                     controller: notesCtrl,
//                     maxLines: 4,
//                     placeholder: const Text(
//                       'Payment terms, special instructions...',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRightColumn() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Card(
//           child: Padding(
//             padding: const EdgeInsets.all(_cardPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _sectionHeader('Summary'),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Invoice #').muted(),
//                     Text(
//                       invoiceNumberCtrl.text.isEmpty
//                           ? '(not set)'
//                           : invoiceNumberCtrl.text,
//                     ).semiBold(),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Client').muted(),
//                     Expanded(
//                       child: Text(
//                         clientNameCtrl.text.isEmpty
//                             ? '(not set)'
//                             : clientNameCtrl.text,
//                         textAlign: TextAlign.right,
//                       ),
//                     ).semiBold(),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 const Divider(),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Subtotal').muted(),
//                     Text('\$${subtotal.toStringAsFixed(2)}').semiBold(),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Tax').muted(),
//                     Text('\$${taxAmount.toStringAsFixed(2)}').semiBold(),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Total').large().semiBold(),
//                     Text('\$${total.toStringAsFixed(2)}').large().semiBold(),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 PrimaryButton(
//                   onPressed: _saveAndSend,
//                   child: const Text('Save & Send'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
